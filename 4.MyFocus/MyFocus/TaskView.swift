import SwiftUI

struct TaskView: View {
    var text: String

    var body: some View {
        Text(text)
    }
}

#Preview {
    TaskView(text: "Some text")
}
