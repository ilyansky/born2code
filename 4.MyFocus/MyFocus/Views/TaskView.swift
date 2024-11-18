import SwiftUI

struct TaskView: View {


    var title: String
    var text: String
    var date: String

    @State private var titleField: String
    @State private var textField: String

    init(title: String, text: String, date: String) {
        self.title = title
        self.text = text
        self.date = date
        self.titleField = title
        self.textField = text
    }

    var body: some View {

        VStack(alignment: .leading) {
            CustomBackButton()

            TextField("Заголовок", text: $titleField, axis: .vertical)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .padding([.leading, .trailing])
                .padding(.bottom, 5)
                .font(Font.system(size: 40))
                .fontWeight(.bold)

            Text(date)
                .padding([.leading, .trailing])
                .foregroundStyle(Color.cgray2)

            TextField("Текст заметки", text: $textField, axis: .vertical)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .padding()
                .font(Font.system(size: 19))

            Spacer()
        }

    }

}

struct CustomBackButton: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    var body: some View {
        HStack {
            Button  {
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
                Text("Готово")
                    .foregroundStyle(Color.yellow)

            }
            .padding()
        }


    }
}

#Preview {
    TaskView(title: "Заняться спортом", text: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.", date: "19/11/24")
}
