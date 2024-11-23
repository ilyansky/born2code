// MARK: - INTERACTOR
import Foundation
import CoreData

// MARK: - Data Module
class DataManager {
    static let shared = DataManager()
    let container: NSPersistentContainer
    let networkManager = NetworkManager()

    init() {
        container = NSPersistentContainer(name: "MyFocus")
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Core Data failed to load => \(error.localizedDescription)")
            }
        }

        if isFirstLoad() {
            DispatchQueue.main.async {
                self.networkManager.handleNetworkLogic() {
                    self.fetchDataFromApi()
                }
            }
        }
    }

    private func isFirstLoad() -> Bool {
        return !UserDefaults.standard.bool(forKey: NetworkManager.firstLoadKey)
    }

    private func fetchDataFromApi() {
        if let data = self.networkManager.json?.todos {
            for item in data {
                self.createTask(title: item.todo,
                                text: "",
                                completed: item.completed)
            }
        }
    }

}

// MARK: - CRUD Implementation
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

    func createTask(title: String, text: String, completed: Bool = false) {
        let task = Task(context: container.viewContext)

        task.id = UUID()
        task.title = title
        task.text = text
        task.completed = completed
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

    func saveOrUpdateOrDiscardTask(task: Task?, title: String, text: String, completed: Bool) {
        if let task {
            update(task: task,
                   title: title,
                   text: text,
                   completed: completed)
        } else {
            if title != "" || text != "" {
                createTask(title: title,
                           text: text)
            }
        }
    }
}

// MARK: - Network Module
class NetworkManager {
    static let firstLoadKey = "hasLoadedBefore"
    private let api = "https://dummyjson.com/todos"
    var json: Response?

    func handleNetworkLogic(clos: @escaping () -> Void) {
        getTasksFromApi() {
            self.markAsLoaded()
            clos()
        }
    }

    private func markAsLoaded() {
        UserDefaults.standard.set(true, forKey: NetworkManager.firstLoadKey)
    }

    private func getTasksFromApi(clos: @escaping () -> Void) {
        guard let url = URL(string: api) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            self.decode(data: data)
            clos()
        }.resume()
    }

    private func decode(data: Data) {
        do {
            json = try JSONDecoder().decode(Response.self, from: data)

        } catch {
            print(String(describing: error))
        }
    }
}
