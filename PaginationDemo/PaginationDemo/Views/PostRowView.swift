//
//  PostRowView.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import SwiftUI

struct PostRowView: View {

    let post: Post

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            AsyncImage(url: URL(string: post.image)) { image in

                image
                    .resizable()
                    .scaledToFill()

            } placeholder: {

                Rectangle()
                    .fill(.gray.opacity(0.2))

            }
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(post.title)
                .font(.headline)

            Text(post.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {

                Text(post.author)

                Spacer()

                Label("\(post.likes)", systemImage: "heart.fill")
                    .foregroundStyle(.red)
            }
            .font(.caption)
        }
    }
}

#Preview {

    PostRowView(
        post: Post(
            id: 1,
            title: "SwiftUI Architecture",
            subtitle: "Repository Pattern",
            author: "Habib",
            image: "https://picsum.photos/id/1/600/400",
            likes: 200,
            createdAt: .now
        )
    )
    .padding()
}
