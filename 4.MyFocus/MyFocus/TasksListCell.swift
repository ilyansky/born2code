import SwiftUI

struct TasksListCell: View {
    @State private var done = false
    @State private var isOnNavLink = false
    private let checkboxSize: CGFloat = 30

    var title: String
    var text: String
    var date: String

    var body: some View {
        Button {
            isOnNavLink = true
        } label: {
            VStack {
                Spacer()
                HStack() {
                    // Checkbox
                    VStack {
                        Toggle(isOn: $done) {
                            switch done {
                            case true:
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .frame(width: checkboxSize, height: checkboxSize)
                                    .foregroundColor(.yellow)
                            case false:
                                Image(systemName: "circle")
                                    .resizable()
                                    .frame(width: checkboxSize, height: checkboxSize)
                            }
                        }
                        .toggleStyle(.button)
                        .buttonStyle(PlainButtonStyle())

                        Spacer()
                    }

                    // Title, text, date
                    VStack(alignment: .leading) {
                        Text(title)
                            .frame(alignment: .leading)
                            .lineLimit(1)
                            .font(.title2)
                            .bold()

                        Text(text)
                            .lineLimit(2)

                        Text(date)
                        //                    .font()
                        Spacer()
                    }
                    Spacer()
                }
                NavigationLink("",
                               destination: Router.createTaskView(text: "text"),
                               isActive: $isOnNavLink)
                .navigationTitle("Назад")
//                    .hidden()
                Spacer()
            }

        }
    }





}


#Preview {
    TasksListCell(
        title: "Title Title Title Title Title Title Title Title Title Title",
        text: "Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ",
        date: "09/10/24"
    )
}
