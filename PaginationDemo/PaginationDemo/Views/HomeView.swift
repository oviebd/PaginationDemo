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
                        container: AppContainer(
                            paginationType: .offset
                        )
                    )

                }

                NavigationLink("Cursor Pagination") {

                    FeedView(
                        container: AppContainer(
                            paginationType: .cursor
                        )
                    )

                }

            }

            .navigationTitle("Pagination Lab")

        }

    }

}
