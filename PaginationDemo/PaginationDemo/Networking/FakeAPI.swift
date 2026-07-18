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
            self.posts = try JSONLoader.load("posts",as: [Post].self)
        } catch {
            fatalError("Failed to load posts.json: \(error)")
        }
    }

    /// Simulates a backend request and returns all posts.
    func fetchPosts() async throws -> [Post] {

        await DelaySimulator.simulate()

        return posts
    }
}
