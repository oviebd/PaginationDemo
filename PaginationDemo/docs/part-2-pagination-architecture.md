# Pagination Isn't About Loading More Data. It's About Designing Systems That Scale. (Part 2)

**Author:** Habibur Rahman  
**Category:** Software Architecture  
**Series:** [Part 1 — Theory & trade-offs](https://habiburrahmanovie.com/blog/pagination_isn_t_about_loading_more_data_it_s_about_designing_systems_that_scale_part_1)  
**Code:** [github.com/oviebd/PaginationDemo](https://github.com/oviebd/PaginationDemo)

---

In [Part 1](https://habiburrahmanovie.com/blog/pagination_isn_t_about_loading_more_data_it_s_about_designing_systems_that_scale_part_1), we established the real problem: pagination is an architectural decision about consistency, scalability, and change — not a spinner at the bottom of a list.

We also drew a hard line:

> The ViewModel should ask for the next page.  
> It should never know *how* that page is fetched.

Part 2 is the practical half of that idea.

We'll walk through a small SwiftUI demo — [PaginationDemo](https://github.com/oviebd/PaginationDemo) — that runs **offset** and **cursor** pagination behind the same screen, the same ViewModel, and the same infinite-scroll UX. Full source lives on GitHub; here we focus on the architecture that makes the swap cheap.

---

## What We're Building

A post feed with:

- Fake backend (`posts.json` + simulated network delay)
- Infinite scrolling + pull-to-refresh
- Two pagination strategies: **Offset** and **Cursor**
- One ViewModel that doesn't care which strategy is active
- A composition root that wires the strategy in

Infinite scrolling is still just UX — *when* to ask for more. Offset and cursor remain the *how*. Part 1 already separated those ideas. The demo makes that separation concrete.

---

## The Architecture

```text
HomeView
   │  picks PaginationType (.offset | .cursor)
   ▼
AppContainer  ← composition root / DI
   │
   ├── OffsetRepository  ──┐
   │                       ├──▶ FeedRepository (protocol)
   └── CursorRepository  ──┘
                              │
                              ▼
                         FeedViewModel
                              │
                              ▼
                           FeedView
```

Read this top-down once, then bottom-up:

- **FeedView** renders posts and triggers load / next / refresh.
- **FeedViewModel** owns UI state: items, loading, `hasMore`, errors.
- **FeedRepository** is the contract. Three verbs. No page numbers. No cursors.
- **OffsetRepository / CursorRepository** own the strategy and its private state.
- **AppContainer** is the only place that knows which concrete repository exists.

That last sentence is the whole lesson.

---

## The Contract That Protects the ViewModel

The repository surface is intentionally small:

```swift
protocol FeedRepository {
    func loadFirstPage() async throws -> PageResponse<Post>
    func loadNextPage() async throws -> PageResponse<Post>
    func refresh() async throws -> PageResponse<Post>
}
```

`PageResponse` carries `items` and `hasMore`. That's the only pagination language the presentation layer is allowed to speak.

The ViewModel then becomes almost boring — which is what you want:

```swift
let response = try await repository.loadNextPage()
posts.append(contentsOf: response.items)
hasMore = response.hasMore
```

No `currentPage`. No `nextCursor`. No `if strategy == .cursor`.

If your backend migrates from offset to cursor tomorrow, this file doesn't move. That's not elegance for its own sake — that's how you keep feature teams from blocking each other when the data layer evolves.

> Pagination is a data concern, not a presentation concern.

---

## Offset Pagination — Inside the Repository

Offset thinks in pages:

> Skip `page * pageSize`, take the next batch.

In the demo, `OffsetRepository` keeps a private `currentPage`, resets it on first load / refresh, and advances it after each successful fetch. The fake API returns the full dataset; the repository slices the window. In production, that slice would be `offset` / `limit` on the server — the ownership boundary stays the same.

**What belongs here**

- Page index and page size
- Mapping API results into `PageResponse`
- Knowing when `hasMore` becomes `false`

**What does not**

- Whether the user scrolled
- Whether the UI shows a spinner
- Whether this feed is "offset mode"

Offset remains the right call for stable catalogs, reports, and admin tables — places where random access matters more than live consistency. Part 1 covered the failure mode under inserts; the demo simply shows where that logic should live when you still choose offset on purpose.

---

## Cursor Pagination — Same Contract, Different Memory

Cursor thinks in continuity:

> Continue after the last item I already saw.

`CursorRepository` keeps a private `nextCursor` (an index into the ordered feed in this demo — in production, usually an opaque token or a sort key like `createdAt + id`). First load resets the cursor. Each page advances it to the end of the window just returned. New items arriving *above* that point don't reshuffle what "next" means the way page 2 does with offsets.

From the ViewModel's perspective, nothing changed. Same three methods. Same `PageResponse`. Same append path.

That's the architectural payoff of Part 1's museum analogy: the guide remembers where you stopped. The visitor never asks for "room 5."

---

## Dependency Injection Without Framework Noise

Having two repositories is useless if the View still does this:

```swift
FeedViewModel(repository: OffsetRepository())
```

That's a composition leak. The View became a factory. Swapping strategies means editing UI code. Testing means fighting the View.

The fix is a **composition root** — one place that creates the object graph.

```swift
final class AppContainer {
    private let paginationType: PaginationType

    func makeFeedRepository() -> FeedRepository {
        switch paginationType {
        case .offset: return OffsetRepository()
        case .cursor: return CursorRepository()
        }
    }

    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(repository: makeFeedRepository())
    }
}
```

`HomeView` chooses `.offset` or `.cursor`, builds an `AppContainer`, and hands it to `FeedView`. `FeedView` asks the container for a ViewModel. It never imports a concrete repository.

That's dependency injection in the only form this app needs: **constructor injection + a single wiring site**. No third-party DI container. No service locator sprinkled through the tree. When the graph is this small, ceremony is a smell.

Architecturally, you've separated three decisions that beginners glue together:

| Decision | Owner |
|---|---|
| *When* to load more | View (scroll / refresh) |
| *What* loading means for the UI | ViewModel |
| *How* the next page is computed | Repository (selected by container) |

Change any one without rewriting the other two.

---

## Why This Scales Beyond a Demo

This isn't about 200 local JSON posts. It's about the cost of change.

- **Backend evolves** — replace `FakeAPI` or change cursor encoding inside one repository.
- **Product needs both strategies** — admin screen gets offset; home feed gets cursor; both reuse `FeedViewModel`.
- **Testing becomes honest** — inject a fake `FeedRepository` that returns canned `PageResponse`s. No networking. No SwiftUI.
- **Teams stay unblocked** — presentation owns UX; data owns pagination mechanics.

Good architecture isn't predicting every future requirement. It's making the expensive futures *cheap to express*.

---

## What to Explore in the Repo

Clone [PaginationDemo](https://github.com/oviebd/PaginationDemo) and read in this order:

1. `FeedRepository` — the boundary  
2. `OffsetRepository` / `CursorRepository` — strategy + private state  
3. `FeedViewModel` — strategy-agnostic state machine  
4. `AppContainer` / `HomeView` — composition root and runtime switch  
5. `FeedView` — infinite scroll as UX only  

Run both lab entries. Same screen. Different repositories. Zero ViewModel edits.

---

## Key Takeaway

> Same feed. Two pagination strategies. One ViewModel.  
> The repository owns the *how*. Dependency injection owns the *which*. The UI owns the *when*.

Pagination still isn't about loading the next 20 items. It's about designing a system that can change how those items are fetched — without rewriting the product around it.

That was the claim in Part 1. This is what it looks like in Swift.
