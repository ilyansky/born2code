import SwiftUI

struct TasksListView: View {
    @ObservedObject var presenter: Presenter

    var body: some View {
        NavigationStack {
            HeaderView()
            BodyView()
            BottomView()
        }


    }

}

struct HeaderView: View {
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
    var tasks = [Task(title: "Title1",
                      text: "Text1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\nText1 Text1 Text1 Text1\n",
                      date: "18/11/24"),
                 Task(title: "Title2 Title2 Title2 Title2 Title2 Title2 \nTitle2 Title2 ",
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
                      date: "18/11/24")
    ]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(tasks) { task in
                    NavigationLink {
                        Router.createTaskView(title: task.title,
                                              text: task.text,
                                              date: task.date)
                    } label: {
                        TasksListCell(title: task.title,
                                      text: task.text,
                                      date: task.date)
                    }
                    .contextMenu {
                        ContextMenu()
                    } preview: {
                        PreviewContextMenu(title: task.title,
                                           text: task.text,
                                           date: task.date)
                    }
                }
            }
            .padding([.leading, .trailing])
        }
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
    var body: some View {
        VStack {
            Button(action: {}) {
                HStack {
                    Text("Редактировать")
                    Image(systemName: "square.and.pencil")
                }
            }
            .background(Color.cwhite2)

            Button(action: {}) {
                HStack {
                    Text("Поделиться")
                    Image(systemName: "square.and.arrow.up")
                }
            }

            Button(role: .destructive) {
                // some action
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

struct BottomView: View {
    private let squarePenSize: CGFloat = 30

    var body: some View {
        ZStack {
            Text("3 Задачи")
            HStack {
                Spacer()
                Button {
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: squarePenSize, height: squarePenSize)
                        .foregroundStyle(Color.cyellow)
                        .padding(.trailing, 25)
                }
                .padding(.trailing, 5)
            }
        }
        .padding(.top)
        .background(Color.cgray)
    }
}

#Preview {
    TasksListView(presenter: Presenter(interactor: Interactor()))
}
