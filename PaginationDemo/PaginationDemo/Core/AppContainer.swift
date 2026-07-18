//
//  AppContainer.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation

final class AppContainer {

    private let paginationType: PaginationType

    init(
        paginationType: PaginationType
    ) {

        self.paginationType = paginationType

    }

    func makeFeedRepository() -> FeedRepository {

        switch paginationType {

        case .offset:

            return OffsetRepository()

        case .cursor:

            return CursorRepository()

        }

    }

    func makeFeedViewModel() -> FeedViewModel {

        FeedViewModel(
            repository: makeFeedRepository()
        )

    }

}
