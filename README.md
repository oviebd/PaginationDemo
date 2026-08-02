# PaginationDemo

A SwiftUI reference app that demonstrates **offset** and **cursor** pagination behind the same feed UI, ViewModel, and infinite-scroll experience.

Pagination here is treated as a data-layer concern—not a UI detail. The ViewModel asks for the next page; it never knows *how* that page is fetched.

> Same feed. Two strategies. One ViewModel.

---

## Features

- Infinite scrolling with pull-to-refresh
- Offset and cursor pagination behind a shared `FeedRepository` contract
- Strategy-agnostic `FeedViewModel` (no page numbers, no cursors in the UI layer)
- Composition-root dependency injection via `AppContainer`
- Fake backend (`posts.json` + simulated network delay) for offline demos
- Clean layering: View → ViewModel → Repository → Fake API

---

## Requirements

| Item | Version |
|------|---------|
| Xcode | 16+ (recommended) |
| iOS Deployment Target | 26.2 |
| Swift | 5.0 |
| Platforms | iOS |

---

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/oviebd/PaginationDemo.git
cd PaginationDemo
```

2. Open the project in Xcode:

```bash
open PaginationDemo/PaginationDemo.xcodeproj
```

3. Select an iOS Simulator or device, then run (**⌘R**).

4. From **Pagination Lab**, choose:

   - **Offset Pagination** — page-index based loading
   - **Cursor Pagination** — continue-after-cursor loading

Both screens share the same `FeedView` and `FeedViewModel`. Only the repository wired by `AppContainer` changes.

---

## Architecture

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

| Decision | Owner |
|----------|--------|
| *When* to load more | View (scroll / refresh) |
| *What* loading means for the UI | ViewModel |
| *How* the next page is computed | Repository (selected by container) |

### Repository contract

```swift
protocol FeedRepository {
    func loadFirstPage() async throws -> PageResponse<Post>
    func loadNextPage() async throws -> PageResponse<Post>
    func refresh() async throws -> PageResponse<Post>
}
```

`PageResponse` exposes only `items` and `hasMore`. That is the only pagination language the presentation layer is allowed to speak.

### Offset vs cursor

| Strategy | Private state | Mental model |
|----------|---------------|--------------|
| **Offset** | `currentPage` + `pageSize` | Skip `page * pageSize`, take the next batch |
| **Cursor** | `nextCursor` + `pageSize` | Continue after the last item already seen |

Swap strategies by changing `PaginationType` in `AppContainer`—no ViewModel edits required.

---

## Project Structure

```text
PaginationDemo/
├── PaginationDemo/                 # App sources
│   ├── Core/
│   │   ├── AppContainer.swift      # Composition root / DI
│   │   └── AppEnvironment.swift    # PaginationType
│   ├── Models/
│   │   └── Post.swift
│   ├── Networking/
│   │   ├── FakeAPI.swift           # Local JSON + delay
│   │   ├── DelaySimulator.swift
│   │   └── JSONLoader.swift
│   ├── Repository/
│   │   ├── FeedRepository.swift    # Protocol + PageResponse
│   │   ├── OffsetRepository.swift
│   │   └── CursorRepository.swift
│   ├── ViewModels/
│   │   └── FeedViewModel.swift
│   ├── Views/
│   │   ├── HomeView.swift          # Lab entry (strategy picker)
│   │   ├── FeedView.swift          # Infinite scroll + refresh
│   │   └── PostRowView.swift
│   ├── Resources/
│   │   └── posts.json
│   └── Utilities/
├── docs/
│   └── part-2-pagination-architecture.md
└── DummydataGenerator/             # Playground to generate posts.json
```

### Suggested reading order

1. `FeedRepository` — the boundary  
2. `OffsetRepository` / `CursorRepository` — strategy + private state  
3. `FeedViewModel` — strategy-agnostic state machine  
4. `AppContainer` / `HomeView` — composition root and runtime switch  
5. `FeedView` — infinite scroll as UX only  

---

## How It Works

1. `HomeView` creates an `AppContainer` with `.offset` or `.cursor`.
2. `FeedView` asks the container for a `FeedViewModel`.
3. The ViewModel calls `loadFirstPage()`, `loadNextPage()`, or `refresh()`.
4. The concrete repository owns page index or cursor state and returns `PageResponse`.
5. The view appends items, shows a footer spinner while `hasMore` is true, and supports pull-to-refresh.

The fake API always returns the full dataset; repositories slice windows locally. In production, those windows would come from server `offset`/`limit` or cursor tokens—the ownership boundary stays the same.

---

## Design Goals

- **Backend can evolve** — replace `FakeAPI` or change cursor encoding inside one repository.
- **Both strategies can coexist** — admin tables use offset; live feeds use cursor; both reuse `FeedViewModel`.
- **Testing stays honest** — inject a fake `FeedRepository` that returns canned `PageResponse`s.
- **Teams stay unblocked** — presentation owns UX; data owns pagination mechanics.

---

## Related Articles

Series by [Habibur Rahman](https://habiburrahmanovie.com):

1. [Part 1 — Theory & trade-offs](https://habiburrahmanovie.com/blog/pagination_isn_t_about_loading_more_data_it_s_about_designing_systems_that_scale_part_1)
2. [Part 2 — Architecture walkthrough](./PaginationDemo/docs/part-2-pagination-architecture.md) (also on the blog)

---

## License

This project is licensed under the [MIT License](LICENSE).
