import Foundation

struct GeneratedPost: Codable {
    let id: Int
    let title: String
    let subtitle: String
    let author: String
    let image: String
    let likes: Int
    let createdAt: String
}

let authors = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Emma",
    "Sophia",
    "Olivia",
    "Noah"
]

var posts: [GeneratedPost] = []

let formatter = ISO8601DateFormatter()

for id in 1...200 {

    let date = Date().addingTimeInterval(Double(-id * 3600))

    posts.append(
        GeneratedPost(
            id: id,
            title: "Building Scalable SwiftUI Apps #\(id)",
            subtitle: "Learn pagination architecture with SwiftUI. Example post \(id).",
            author: authors.randomElement()!,
            image: "https://picsum.photos/id/\(id % 100)/600/400",
            likes: Int.random(in: 10...5000),
            createdAt: formatter.string(from: date)
        )
    )
}

let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

let data = try encoder.encode(posts)

let json = String(data: data, encoding: .utf8)!

print(json)
