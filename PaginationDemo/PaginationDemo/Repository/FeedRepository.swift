//
//  FeedRepository.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation

protocol FeedRepository {

    func loadFirstPage() async throws -> [Post]

    func loadNextPage() async throws -> [Post]

    func refresh() async throws -> [Post]
}
