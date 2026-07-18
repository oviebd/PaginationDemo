//
//  FeedRepository.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation

struct PageResponse<T> {
    let items: [T]
    let hasMore: Bool
}

protocol FeedRepository {

    func loadFirstPage() async throws -> PageResponse<Post>

    func loadNextPage() async throws -> PageResponse<Post>

    func refresh() async throws -> PageResponse<Post>
}
