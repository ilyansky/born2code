import SwiftUI

private struct Sizes {
    static let magnifyingGlassSize: CGFloat = 20
    static let micSize: CGFloat = 15
    static let squarePenSize: CGFloat = 30
}

struct TasksListView: View {
    @ObservedObject var presenter: Presenter
    @State private var searchString: String = ""

    var body: some View {
        NavigationStack {
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
                        .frame(width: Sizes.magnifyingGlassSize, height: Sizes.magnifyingGlassSize)
                        .padding(.leading, 10)
                        .foregroundStyle(Color.cgray2)
                    Spacer()
                    Image(systemName: "microphone.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: Sizes.micSize, height: Sizes.micSize)
                        .padding(.trailing, 15)
                        .foregroundStyle(Color.cgray2)
                }
            }
            .padding([.leading, .trailing])

            // Notes
            ScrollView {
                LazyVStack {
                    ForEach(presenter.tasks) { task in
                        NavigationLink {
                            Router.createTaskView(text: task.text)
                        } label: {
                            TasksListCell(title: task.title,
                                          text: task.text,
                                          date: presenter.fetchDateString(for: task))
                        }


                        /*
                        .contextMenu {
                            VStack {
                                HStack {
                                    Button(action: {}) {
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
                                        // some action
                                    } label: {
                                        HStack {
                                            Text("Удалить")
                                            Image(systemName: "trash")
                                        }
                                    }
                                }


                            }
                        } preview: {
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .frame(alignment: .leading)
                                    .lineLimit(1)
                                    .font(.title2)
                                    .bold()
                                    .padding(.bottom, 1)
                                    .foregroundStyle(Color.cwhite)

                                Text(task.text)
                                    .lineLimit(2)
                                    .foregroundStyle(Color.cwhite)

                                Text(task.date)
                                    .foregroundStyle(Color.cstroke)
                                    .padding(.top, 1)

                                Spacer()
                            }
                            .padding(.top)
                            .multilineTextAlignment(.leading)
                        }
                         */
                    }


                }
                .padding([.leading, .trailing])
            }

            // Bottom bar
            ZStack {
                Text("3 Задачи")
                HStack {
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: Sizes.squarePenSize, height: Sizes.squarePenSize)
                            .foregroundStyle(Color.cyellow)
                            .padding(.trailing, 25)
                    }
                    .padding(.trailing, 5)
                }
            }
            .padding(.top)
            .background(Color.cgray)
            .frame(maxWidth: .infinity)
        }


    }

}

#Preview {
    TasksListView(presenter: Presenter(interactor: Interactor()))
}
