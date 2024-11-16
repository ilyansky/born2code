import SwiftUI

struct TasksListView: View {
    @ObservedObject var presenter: Presenter

    var body: some View {
        NavigationView {
            List {
                ForEach(presenter.tasks, id: \.id) { task in
                    NavigationLink(destination: Router.createTaskView(text: task.text)) {
                        Text(task.text)
                    }

                }
            }

                .navigationTitle("Задачи")
        }
    }
}

#Preview {
    TasksListView(presenter: Presenter(interactor: Interactor()))
}
