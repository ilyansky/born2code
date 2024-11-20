import SwiftUI

@main
struct MyFocusApp: App {
    private var presenter = Presenter()

    var body: some Scene {
        WindowGroup {
            Router.createTasksListView()
        }
    }
}
