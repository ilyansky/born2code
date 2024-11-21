import SwiftUI

struct TaskView: View {
    @ObservedObject var presenter: Presenter
    @ObservedObject private var keyboardObserver = KeyboardObserver()
    @State private var titleField: String
    @State private var textField: String

    var createdAt: String
    var task: Task?

    init(presenter: Presenter, task: Task?) {
        self.presenter = presenter

        if let task {
            titleField = task.title ?? ""
            textField = task.text ?? ""
            createdAt = presenter.dateToString(date: task.createdAt ?? Date())
            self.task = task
        } else {
            titleField = ""
            textField = ""
            createdAt = presenter.dateToString(date: Date())
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Body
            TextField("Заголовок", text: $titleField, axis: .vertical)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .padding([.leading, .trailing, .top])
                .padding(.bottom, 5)
                .font(Font.system(size: 40))
                .fontWeight(.bold)
                .tint(Color.cyellow)

            Text(createdAt)
                .padding([.leading, .trailing])
                .foregroundStyle(Color.cgray2)

            TextField("Текст заметки", text: $textField, axis: .vertical)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .padding()
                .font(Font.system(size: 19))
                .tint(Color.cyellow)

            Spacer()
            HStack {
                Spacer()
                Button  {
                    UIApplication.shared.endEditing()
                } label: {
                    if keyboardObserver.isKeyboardVisible {
                        Image(systemName: "chevron.down.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(15)
                            .foregroundStyle(Color.cyellow)

                    }
                }
            }
            .padding()
        }
    }

}

#Preview {
    TaskView(presenter: Presenter(),
             task: nil)
}
