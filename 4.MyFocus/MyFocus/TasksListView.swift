import SwiftUI

struct TasksListView: View {
    @ObservedObject var presenter: Presenter

    var body: some View {
        NavigationStack {
            // Custom navigation title
            HStack {
                Text("Задачи")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            List(presenter.tasks) { task in
                NavigationLink {
                    Router.createTaskView(text: task.text)
                } label: {
                    TasksListCell(title: task.title,
                                  text: task.text,
                                  date: presenter.fetchDateString(for: task))
                }
            }
            .listStyle(.plain)
            .navigationBarHidden(true)
            .foregroundStyle(.white, .white, .black)
        }


    }

}

#Preview {
    TasksListView(presenter: Presenter(interactor: Interactor()))
}
