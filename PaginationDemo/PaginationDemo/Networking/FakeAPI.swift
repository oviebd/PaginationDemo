//
//  FakeAPI.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation

final class FakeAPI {

    private let posts: [Post]

    init() {

        do {
            posts = try JSONLoader.load(
                "posts",
                as: [Post].self
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchPosts(
        page: Int,
        limit: Int
    ) async throws -> [Post] {

        await DelaySimulator.randomDelay()

        let start = (page - 1) * limit

        guard start < posts.count else {
            return []
        }

        let end = min(start + limit, posts.count)

        return Array(posts[start..<end])
    }
}
