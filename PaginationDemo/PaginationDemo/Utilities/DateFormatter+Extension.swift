//
//  DateFormatter+Extension.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation

extension JSONDecoder {

    static var paginationDecoder: JSONDecoder {
        let decoder = JSONDecoder()

        let formatter = ISO8601DateFormatter()

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

            guard let date = formatter.date(from: string) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid Date"
                )
            }

            return date
        }

        return decoder
    }
}
