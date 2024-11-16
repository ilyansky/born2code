protocol InteractorProtocol {
    func fetchTasks() -> [Task]
}

class Interactor: InteractorProtocol {
    private var tasks: [Task] = [Task(text: "task1"), Task(text: "task2"), Task(text: "task3")]

    func fetchTasks() -> [Task] {
        return tasks
    }
}
