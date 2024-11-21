import SwiftUI


struct TaskView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
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
            // Custom Head Bar
            HStack {
                Button  {
                    presenter.handle(task: task,
                                     title: titleField.description,
                                     text: textField.description)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.compact.left")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color.yellow)
                        Text("Назад")
                            .foregroundStyle(Color.yellow)
                        Spacer()
                    }
                }
                .padding()

                Spacer()

                Button  {
                    UIApplication.shared.endEditing()
                } label: {
                    if keyboardObserver.isKeyboardVisible {
                        Text("Готово")
                            .foregroundStyle(Color.yellow)
                    }
                }
                .padding()
            }

            // Body
            TextField("Заголовок", text: $titleField, axis: .vertical)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .padding([.leading, .trailing])
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
        }
    }

}

#Preview {
    TaskView(presenter: Presenter(),
             task: nil)
}
