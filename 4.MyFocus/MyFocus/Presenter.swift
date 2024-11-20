import SwiftUI

class Presenter: ObservableObject {
    let dataManager = DataManager.shared
    @Published var tasks: [Task] = []

    init() {
        getAllTasks()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidChange),
            name: .NSManagedObjectContextObjectsDidChange,
            object: dataManager.container.viewContext
        )
    }

    @objc private func contextDidChange(notification: Notification) {
        getAllTasks()
    }
}

// MARK: - Communication with DataManager (Interactor), Closed for Views Interfaces
extension Presenter {
    private func getAllTasks() {
        DispatchQueue.main.async {
            self.tasks = self.dataManager.readTasks()
        }
    }

    private func createTask(title: String, text: String) {
        dataManager.createTask(title: title, text: text)
        getAllTasks()
    }

    private func update(task: Task, title: String, text: String) {
        dataManager.update(task: task, title: title, text: text)
        getAllTasks()
    }

    private func delete(task: Task) {
        dataManager.delete(task: task)
        getAllTasks()
    }
}

// MARK: - Opened for Views Interfaces
extension Presenter {
    func handle(task: Task?, title: String, text: String, completed: Bool = false) {
        DispatchQueue.global().async {
            self.dataManager.saveOrUpdateOrDiscardTask(task: task, title: title, text: text, completed: completed)
        }
    }

    func deleteTask(_ task: Task) {
        DispatchQueue.global().async {
            self.delete(task: task)
        }
    }

    func countTasks() -> String {
        let count = tasks.count

        let textTail = switch count % 10 {
        case 2...4:
            "Задачи"
        case 1:
            "Задача"
        default:
            "Задач"
        }

        return "\(count) \(textTail)"
    }

    func findTasks(by title: String) {
        DispatchQueue.main.async {
            self.tasks = title == ""
            ? self.dataManager.readTasks()
            : self.dataManager.readTasks(predicateFormat: title)
        }
    }

    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let dateString = formatter.string(from: date)
        return dateString
    }
}

