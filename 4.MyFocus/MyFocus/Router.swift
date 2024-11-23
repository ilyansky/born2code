import SwiftUI

final class Router {
    static func createTasksListView() -> some View {
        return TasksListView()
    }
    
    static func openTaskView(presenter: Presenter, task: Task? = nil) -> some View {
        return TaskView(presenter: presenter, task: task)
    }
}
