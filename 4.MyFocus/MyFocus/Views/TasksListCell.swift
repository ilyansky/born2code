import SwiftUI

struct TasksListCell: View {
    @State private var completed: Bool = false
    @ObservedObject var presenter = Presenter()

    var task: Task

    init(task: Task) {
        self.task = task
        self._completed = State(initialValue: task.completed)
    }

    var body: some View {
        VStack {
            HStack() {
                // Checkbox
                VStack {
                    Toggle(isOn: $completed) {
                        completed
                        ? CheckBox(name: "checkmark.circle", color: Color.cyellow)
                        : CheckBox(name: "circle", color: Color.cstroke)
                    }
                    .toggleStyle(.button)
                    .buttonStyle(PlainButtonStyle())
                    .onChange(of: completed) { _, newValue in
                        presenter.handle(task: task,
                                         title: task.title ?? "",
                                         text: task.text ?? "",
                                         completed: newValue)
                    }

                    Spacer()
                }
                .padding(.top, 15)

                // Title, text, date
                VStack(alignment: .leading) {
                    Text(task.title ?? "")
                        .frame(alignment: .leading)
                        .lineLimit(1)
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 1)
                        .foregroundStyle(completed ? Color.cgray2 : Color.cwhite)
                        .strikethrough(completed ? true : false)

                    Text(task.text ?? "")
                        .lineLimit(2)
                        .foregroundStyle(completed ? Color.cgray2 : Color.cwhite)

                    Text(presenter.dateToString(date: task.createdAt ?? Date()))
                        .foregroundStyle(Color.cgray2)
                        .padding(.top, 1)

                    Spacer()
                }
                .padding(.top)
                .multilineTextAlignment(.leading)

                Spacer()
            }

            Rectangle()
                .fill(Color.cstroke)
                .frame(maxWidth: .infinity, maxHeight: 1)
                .padding(.top)
        }
    }
}

struct CheckBox: View {
    var name: String
    var color: Color

    private let checkboxSize: CGFloat = 30

    var body: some View {
        Image(systemName: name)
            .resizable()
            .frame(width: checkboxSize, height: checkboxSize)
            .foregroundColor(color)
            .fontWeight(.thin)
    }
}

#Preview {
    TasksListCell(task: Task())
}
