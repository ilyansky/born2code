import Foundation

protocol InteractorProtocol {
    func fetchTasks() -> [Task]
//    func convertDateToString(for task: Task) -> String
}

class Interactor: InteractorProtocol {
    private var tasks: [Task] = [Task(title: "Title1",
                                      text: "Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 Text1 ",
                                      date: "18/11/24"),
                                 Task(title: "Title2 Title2 Title2 Title2 Title2 Title2 Title2 Title2 ",
                                      text: "Text2",
                                      date: "18/11/24"),
                                 Task(title: "Title3",
                                      text: "Text3",
                                      date: "18/11/24"),
                                 Task(title: "Title3",
                                      text: "Text3",
                                      date: "18/11/24"),
                                 Task(title: "Title3",
                                      text: "Text3",
                                      date: "18/11/24"),
                                 Task(title: "Title3",
                                      text: "Text3",
                                      date: "18/11/24"),
    ]

    func fetchTasks() -> [Task] {
        return tasks
    }

//    func convertTasksAmountToString() -> String {
//        
//    }
//
//    func convertDateToString(for task: Task) -> String {
//        let date = task.date
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yy"
//        let dateString = formatter.string(from: date)
//        return dateString
//    }
}
