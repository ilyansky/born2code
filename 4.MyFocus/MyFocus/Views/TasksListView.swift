import SwiftUI

private struct Sizes {
    static let magnifyingGlassSize: CGFloat = 20
    static let micSize: CGFloat = 13
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
                    .padding([.leading, .trailing], 35)
                    .background(Color.cgray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .disableAutocorrection(true)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: Sizes.magnifyingGlassSize, height: Sizes.magnifyingGlassSize)
                        .padding(.leading, 10)
                        .foregroundStyle(Color.cstroke)
                    Spacer()
                    Image(systemName: "microphone.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: Sizes.micSize, height: Sizes.micSize)
                        .padding(.trailing, 10)
                        .foregroundStyle(Color.cstroke)
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
