//
//  FeedView.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import SwiftUI

struct FeedView: View {

    @StateObject
    private var viewModel: FeedViewModel

    init(repository: FeedRepository) {

        _viewModel = StateObject(
            wrappedValue: FeedViewModel(
                repository: repository
            )
        )

    }

    var body: some View {

        List {

            ForEach(viewModel.posts) { post in

                PostRowView(post: post)

                    .onAppear {

                        if post.id == viewModel.posts.last?.id {

                            Task {

                                await viewModel.loadNextPage()

                            }

                        }

                    }

            }

            if viewModel.hasMore {

                HStack {

                    Spacer()

                    ProgressView()

                    Spacer()

                }

                .listRowSeparator(.hidden)

            }

        }

        .navigationTitle("Posts")

        .task {

            await viewModel.load()

        }

        .refreshable {

            await viewModel.refresh()

        }

    }

}
