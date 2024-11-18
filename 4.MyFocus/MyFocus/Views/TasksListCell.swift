import SwiftUI

struct TasksListCell: View {
    @State private var done = false
    private let checkboxSize: CGFloat = 30

    var title: String
    var text: String
    var date: String

    var body: some View {

        VStack {
            HStack() {
                // Checkbox
                VStack {
                    Toggle(isOn: $done) {
                        switch done {
                        case true:
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: checkboxSize, height: checkboxSize)
                                .foregroundColor(Color.cyellow)
                                .fontWeight(.thin)
                        case false:
                            Image(systemName: "circle")
                                .resizable()
                                .frame(width: checkboxSize, height: checkboxSize)
                                .foregroundColor(Color.cstroke)
                                .fontWeight(.thin)
                        }
                    }
                    .toggleStyle(.button)
                    .buttonStyle(PlainButtonStyle())

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

#Preview {
    TasksListCell(
        title: "Some title",
        text: "Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum",
        date: "09/10/24"
    )
}
