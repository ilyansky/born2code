import SwiftUI

final class Router {
    static func createTasksListView() -> some View {
        let interactor = Interactor()
        let presenter = Presenter(interactor: interactor)
        return TasksListView(presenter: presenter)
    }

    static func createTaskView(text: String) -> some View {
        return TaskView(text: text)
    }
}