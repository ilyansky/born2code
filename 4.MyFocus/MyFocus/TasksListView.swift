import SwiftUI

struct TasksListView: View {
    @ObservedObject var presenter: Presenter

    var body: some View {
        NavigationView {
            List {
                ForEach(presenter.tasks, id: \.id) { task in
                    
                    TasksListCell(title: task.title,
                                  text: task.text,
                                  date: presenter.fetchDateString(for: task))
                }
            }
            .listStyle(.plain)


            .navigationTitle("Задачи")
        }
    }
}

#Preview {
    TasksListView(presenter: Presenter(interactor: Interactor()))
}
