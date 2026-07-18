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

    init(container: AppContainer) {

        _viewModel = StateObject(
            wrappedValue: container.makeFeedViewModel()
        )

    }

    var body: some View {

        List {

            ForEach(viewModel.posts) { post in

                PostRowView(post: post)
                    .onAppear {

                        guard post.id == viewModel.posts.last?.id else {

                            return

                        }

                        Task {

                            await viewModel.loadNextPage()

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
