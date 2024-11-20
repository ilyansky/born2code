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

// MARK: - Communication with DataManager
extension Presenter {
    private func getAllTasks() {
        DispatchQueue.main.async {
            self.tasks = self.dataManager.readTasks()
        }
    }

    private func delete(task: Task) {
        self.dataManager.delete(task: task)
        self.getAllTasks()
    }
}

// MARK: - Interfaces for Views
extension Presenter {
    func handle(task: Task?, title: String, text: String, completed: Bool = false) {
        DispatchQueue.main.async {
            self.dataManager.saveOrUpdateOrDiscardTask(task: task,
                                                       title: title,
                                                       text: text,
                                                       completed: completed)
        }
    }

    func deleteTask(_ task: Task) {
        DispatchQueue.main.async {
            self.delete(task: task)
        }
    }

    func findTasks(by title: String) {
        DispatchQueue.main.async {
            self.tasks = title == ""
            ? self.dataManager.readTasks()
            : self.dataManager.readTasks(predicateFormat: title)
        }
    }
}

// MARK: - Support
extension Presenter {
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

    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let dateString = formatter.string(from: date)
        return dateString
    }
}

