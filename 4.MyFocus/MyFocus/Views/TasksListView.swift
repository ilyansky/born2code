import SwiftUI

struct TasksListView: View {
    @StateObject var presenter = Presenter()

    var body: some View {
        NavigationStack {
            HeaderView(presenter: presenter)
            BodyView(presenter: presenter)
            BottomView(presenter: presenter)
        }
    }
}

struct HeaderView: View {
    @ObservedObject var presenter: Presenter
    @State private var searchString: String = ""

    private let magnifyingGlassSize: CGFloat = 20
    private let micSize: CGFloat = 15

    var body: some View {
        // Custom navigation title
        HStack {
            Text("Задачи")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding()

        // Searching text field
        ZStack {
            TextField("Search", text: $searchString)
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing], 37)
                .background(Color.cgray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disableAutocorrection(true)
                .font(.title2)
                .fontWeight(.semibold)
                .onChange(of: searchString) { _, newValue in
                    presenter.findTasks(by: newValue)
                }

            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: magnifyingGlassSize, height: magnifyingGlassSize)
                    .padding(.leading, 10)
                    .foregroundStyle(Color.cgray2)
                Spacer()
                Image(systemName: "microphone.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: micSize, height: micSize)
                    .padding(.trailing, 15)
                    .foregroundStyle(Color.cgray2)
            }
        }
        .padding([.leading, .trailing])
    }
}

struct BodyView: View {
    @ObservedObject var presenter: Presenter

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(presenter.tasks.reversed()) { task in
                    NavigationLink {
                        Router.openTaskView(
                            presenter: presenter,
                            task: task)
                    } label: {
                        TasksListCell(task: task,
                                      title: task.title ?? "",
                                      text: task.text ?? "",
                                      date: "date")
                    }
                    .contextMenu {
                        ContextMenu(
                            presenter: presenter,
                            task: task)
                    } preview: {
                        PreviewContextMenu(title: task.title ?? "",
                                           text: task.text ?? "",
                                           date: "date")
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }

}

struct BottomView: View {
    @ObservedObject var presenter: Presenter

    private let squarePenSize: CGFloat = 30

    var body: some View {
        ZStack {
            Text(presenter.countTasks())
            HStack {
                Spacer()
                NavigationLink {
                    Router.openTaskView(presenter: presenter)
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: squarePenSize, height: squarePenSize)
                        .foregroundStyle(Color.cyellow)
                        .padding(.trailing, 30)
                }
            }
        }
        .padding(.top)
        .background(Color.cgray)
    }
}

struct PreviewContextMenu: View {
    var title: String
    var text: String
    var date: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.bottom, 1)
                .foregroundStyle(Color.cwhite)

            Text(text)
                .foregroundStyle(Color.cwhite)

            Text(date)
                .foregroundStyle(Color.cstroke)
                .padding(.top, 1)

            Spacer()
        }
        .frame(
            minWidth: UIScreen.screenWidth * 0.3,
            maxWidth: UIScreen.screenWidth * 0.9,
            minHeight: UIScreen.screenHeight * 0.1,
            maxHeight: UIScreen.screenHeight * 0.5
        )
        .padding(.top, 20)
        .padding(.bottom, 15)
        .padding([.leading, .trailing], 20)
    }
}

struct ContextMenu: View {
    @ObservedObject var presenter: Presenter
    var task: Task

    var body: some View {
        VStack {
            NavigationLink {
                Router.openTaskView(presenter: presenter,
                                    task: task)
            } label: {
                HStack {
                    Text("Редактировать")
                    Image(systemName: "square.and.pencil")
                }
            }

            Button(action: {}) {
                HStack {
                    Text("Поделиться")
                    Image(systemName: "square.and.arrow.up")
                }
            }

            Button(role: .destructive) {
                presenter.deleteTask(task)
            } label: {
                HStack {
                    Text("Удалить")
                    Image(systemName: "trash")
                }
            }
            .background(Color.cwhite2)
        }
    }
}



#Preview {
    TasksListView()
}
