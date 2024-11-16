import SwiftUI

struct TasksListView: View {
    @ObservedObject var presenter: Presenter

    var body: some View {
        // Custom navigation title
        NavigationStack {
            HStack {
                Text("Задачи")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            List {
                ForEach(presenter.tasks, id: \.id) { task in
                    TasksListCell(title: task.title,
                                  text: task.text,
                                  date: presenter.fetchDateString(for: task))
                }
                .background(.blue)
            }
            .listStyle(.plain)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    TasksListView(presenter: Presenter(interactor: Interactor()))
}
