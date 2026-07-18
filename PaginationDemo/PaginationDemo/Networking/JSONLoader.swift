//
//  JSONLoader.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation

enum JSONLoader {

    static func load<T: Decodable>(
        _ filename: String,
        as type: T.Type
    ) throws -> T {

        guard let url = Bundle.main.url(
            forResource: filename,
            withExtension: "json"
        ) else {

            throw NSError(
                domain: "JSONLoader",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "File not found."]
            )
        }

        let data = try Data(contentsOf: url)

        return try JSONDecoder.paginationDecoder.decode(
            T.self,
            from: data
        )
    }
}
