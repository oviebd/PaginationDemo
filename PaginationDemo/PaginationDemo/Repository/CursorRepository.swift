//
//  CursorRepository.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation

final class CursorRepository: FeedRepository {

    private let api = FakeAPI()

    private let pageSize = 20

    private var nextCursor: Int = 0

    func loadFirstPage() async throws -> PageResponse<Post> {

        nextCursor = 0

        return try await load()

    }

    func loadNextPage() async throws -> PageResponse<Post> {

        return try await load()

    }

    func refresh() async throws -> PageResponse<Post> {

        return try await loadFirstPage()

    }

    private func load() async throws -> PageResponse<Post> {

        let posts = try await api.fetchPosts()

        guard nextCursor < posts.count else {

            return PageResponse(
                items: [],
                hasMore: false
            )

        }

        let end = min(
            nextCursor + pageSize,
            posts.count
        )

        let page = Array(posts[nextCursor..<end])

        nextCursor = end

        return PageResponse(
            items: page,
            hasMore: end < posts.count
        )

    }

}
