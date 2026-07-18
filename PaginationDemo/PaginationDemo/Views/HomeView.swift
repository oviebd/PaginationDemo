//
//  HomeView.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import SwiftUI

struct HomeView: View {

    var body: some View {

        NavigationStack {

            List {

                NavigationLink("Offset Pagination") {

                    FeedView(
                        repository: OffsetRepository()
                    )

                }

                NavigationLink("Cursor Pagination") {

                    FeedView(
                        repository: CursorRepository()
                    )

                }

            }

            .navigationTitle("Pagination Lab")

        }

    }

}
