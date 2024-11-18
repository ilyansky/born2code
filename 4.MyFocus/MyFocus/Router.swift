import SwiftUI

final class Router {
    static func createTasksListView() -> some View {
        let interactor = Interactor()
        let presenter = Presenter(interactor: interactor)
        return TasksListView(presenter: presenter)
    }

    static func createTaskView(title: String, text: String, date: String) -> some View {
        return TaskView(title: title, text: text, date: date)
    }
}
