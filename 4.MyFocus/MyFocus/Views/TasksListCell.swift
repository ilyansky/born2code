import SwiftUI

struct TasksListCell: View {
    @State private var done = false
    @ObservedObject var presenter = Presenter()
    
    var task: Task
    var title: String
    var text: String
    var date: String

    var body: some View {
        VStack {
            HStack() {
                // Checkbox
                VStack {
                    Toggle(isOn: $done) {
                        done
                        ? CheckBox(name: "checkmark.circle", color: Color.cyellow)
                        : CheckBox(name: "circle", color: Color.cstroke)
                    }
                    .toggleStyle(.button)
                    .buttonStyle(PlainButtonStyle())
                    .onChange(of: done) { _, newValue in
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
                    Text(title)
                        .frame(alignment: .leading)
                        .lineLimit(1)
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 1)
                        .foregroundStyle(done ? Color.cgray2 : Color.cwhite)
                        .strikethrough(done ? true : false)

                    Text(text)
                        .lineLimit(2)
                        .foregroundStyle(done ? Color.cgray2 : Color.cwhite)

                    Text(date)
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
    TasksListCell(
        task: Task(), title: "Some title",
        text: "Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum",
        date: "09/10/24"
    )
}
