import SwiftUI

class Presenter: ObservableObject {
    @Published var tasks: [Task] = []

    private let interactor: InteractorProtocol

    init(interactor: InteractorProtocol) {
        self.interactor = interactor
        loadTasks()
    }

    func loadTasks() {
        tasks = interactor.fetchTasks()
    }

    func fetchDateString(for task: Task) -> String {
        return interactor.convertDateToString(for: task)
    }
}
