import SwiftUI

@main
struct MyFocusApp: App {
    var body: some Scene {
        WindowGroup {
            Router.createTasksListView()
        }
    }
}
