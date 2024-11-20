import SwiftUI

@main
struct MyFocusApp: App {
//    @StateObject private var dataController = DataManager()
    private var presenter = Presenter()

    var body: some Scene {
        WindowGroup {
            Router.createTasksListView()
//                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
