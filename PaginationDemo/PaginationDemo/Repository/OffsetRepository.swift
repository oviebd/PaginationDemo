//
//  OffsetRepository.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation

final class OffsetRepository: FeedRepository {

    private let api: FakeAPI

    private let pageSize = 10

    private var currentPage = 1

    init(api: FakeAPI = FakeAPI()) {
        self.api = api
    }

    func loadFirstPage() async throws -> [Post] {

        currentPage = 1

        return try await api.fetchPosts(
            page: currentPage,
            limit: pageSize
        )
    }

    func loadNextPage() async throws -> [Post] {

        currentPage += 1

        return try await api.fetchPosts(
            page: currentPage,
            limit: pageSize
        )
    }

    func refresh() async throws -> [Post] {

        currentPage = 1

        return try await api.fetchPosts(
            page: currentPage,
            limit: pageSize
        )
    }
}
