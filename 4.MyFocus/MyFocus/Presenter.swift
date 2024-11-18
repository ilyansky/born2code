import SwiftUI

class Presenter: ObservableObject {
    private let interactor: InteractorProtocol
    var tasks: [Task] = []

    init(interactor: InteractorProtocol) {
        self.interactor = interactor
        loadTasks()
    }

    func loadTasks() {
        tasks = interactor.fetchTasks()
    }

    func fetchTasks() -> [Task] {
        print(1)
        return interactor.fetchTasks()
    }

    func fetchDateString(for task: Task) -> String {
        return interactor.convertDateToString(for: task)
    }
}
