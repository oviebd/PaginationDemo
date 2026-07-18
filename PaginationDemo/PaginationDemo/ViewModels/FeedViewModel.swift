//
//  FeedViewModel.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation
import Combine

@MainActor
final class FeedViewModel: ObservableObject {

    @Published private(set) var posts: [Post] = []

    @Published private(set) var isLoading = false

    @Published private(set) var hasMore = true

    @Published var errorMessage: String?

    private var isLoadingNextPage = false

    private let repository: FeedRepository

    init(repository: FeedRepository) {

        self.repository = repository

    }

    func load() async {

        guard posts.isEmpty else { return }

        isLoading = true

        defer {

            isLoading = false

        }

        do {

            let response = try await repository.loadFirstPage()

            posts = response.items

            hasMore = response.hasMore

        } catch {

            errorMessage = error.localizedDescription

        }

    }

    func loadNextPage() async {

        guard hasMore else { return }

        guard !isLoadingNextPage else { return }

        isLoadingNextPage = true

        defer {

            isLoadingNextPage = false

        }

        do {

            let response = try await repository.loadNextPage()

            posts.append(contentsOf: response.items)

            hasMore = response.hasMore

        } catch {

            errorMessage = error.localizedDescription

        }

    }

    func refresh() async {

        do {

            let response = try await repository.refresh()

            posts = response.items

            hasMore = response.hasMore

        } catch {

            errorMessage = error.localizedDescription

        }

    }

}
