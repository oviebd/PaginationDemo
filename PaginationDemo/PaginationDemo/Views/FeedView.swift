//
//  FeedView.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import SwiftUI

struct FeedView: View {

    @StateObject
    private var viewModel = FeedViewModel(
        repository: OffsetRepository()
    )

    var body: some View {

        List(viewModel.posts) { post in

            PostRowView(post: post)
        }
        .navigationTitle("Offset Pagination")
        .overlay {

            if viewModel.isLoading &&
                viewModel.posts.isEmpty {

                ProgressView()
            }

        }
        .task {

            await viewModel.load()

        }
    }
}
