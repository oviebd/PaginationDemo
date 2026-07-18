//
//  Post.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation

struct Post: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let subtitle: String
    let author: String
    let image: String
    let likes: Int
    let createdAt: Date
}

