// MARK: - INTERACTOR
import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    let container: NSPersistentContainer
    let networkManager = NetworkManager()

    init() {
        networkManager.handleNetworkLogic()

        container = NSPersistentContainer(name: "MyFocus")

        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Core Data failed to load => \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Core CRUD Logic
extension DataManager {
    func saveChanges() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    func createTask(title: String, text: String) {
        let task = Task(context: container.viewContext)

        task.id = UUID()
        task.title = title
        task.text = text
        task.completed = false
        task.createdAt = Date()

        saveChanges()
    }

    func readTasks(predicateFormat: String? = nil) -> [Task] {
        var tasks: [Task] = []
        let request = NSFetchRequest<Task>(entityName: "Task")

        if let predicateFormat {
            request.predicate = NSPredicate(format: "title CONTAINS[c] %@", predicateFormat)
        }

        do {
            tasks = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch notes from Core Data.")
        }

        return tasks
    }

    func update(task: Task, title: String? = nil, text: String? = nil, completed: Bool? = nil) {
        var hasChange = false

        if let title {
            task.title = title
            hasChange = true
        }

        if let text {
            task.text = text
            hasChange = true
        }

        if let completed {
            task.completed = completed
        }

        if hasChange {
            saveChanges()
        }
    }

    func delete(task: Task) {
        container.viewContext.delete(task)
        saveChanges()
    }
}

// MARK: - Handle Data Logic
extension DataManager {
    func saveOrUpdateOrDiscardTask(task: Task?, title: String, text: String, completed: Bool) {
        if let task {
            update(task: task,
                   title: title == "" ? "Новая заметка" : title,
                   text: text == "" ? "Нет дополнительного текста" : text,
                   completed: completed
            )
        } else {
            if title != "" || text != "" {
                createTask(title: title == "" ? "Новая заметка" : title,
                           text: text == "" ? "Нет дополнительного текста" : text)
            }
        }
    }
}

// MARK: - Network Logic
class NetworkManager {
    private let api = "https://dummyjson.com/todos"
    var json: Response?

    func handleNetworkLogic() {
        getTasksFromApi()
    }

    private func getTasksFromApi() {
        guard let url = URL(string: api) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            self.decode(data: data)
            self.parseJson()
        }.resume()
    }

    private func decode(data: Data) {
        do {
            json = try JSONDecoder().decode(Response.self, from: data)

        } catch {
            print(String(describing: error))
        }
    }

    private func parseJson() {
        guard let json = json else { return }

        for item in json.todos {
            print(item.todo, item.completed)
        }

    }


}

struct Response: Codable {
    let todos: [Todo]
}

struct Todo: Codable {
    let todo: String
    let completed: Bool
}
