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

    @Published var posts: [Post] = []

    @Published var isLoading = false

    @Published var errorMessage: String?

    private let repository: FeedRepository

    init(repository: FeedRepository) {
        self.repository = repository
    }

    func load() async {

        guard posts.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            posts = try await repository.loadFirstPage()

        } catch {

            errorMessage = error.localizedDescription

        }
    }

    func loadNextPage() async {

        guard !isLoading else { return }

        isLoading = true

        defer {
            isLoading = false
        }

        do {

            let newPosts = try await repository.loadNextPage()

            posts.append(contentsOf: newPosts)

        } catch {

            errorMessage = error.localizedDescription

        }
    }

    func refresh() async {

        do {

            posts = try await repository.refresh()

        } catch {

            errorMessage = error.localizedDescription

        }
    }
}
