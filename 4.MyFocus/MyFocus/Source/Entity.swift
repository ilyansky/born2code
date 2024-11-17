import Foundation

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let text: String
    let date: Date
}

