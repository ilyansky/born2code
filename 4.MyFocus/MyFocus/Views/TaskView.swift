import SwiftUI

struct TaskView: View {


    var title: String
    var text: String
    var date: String

    @State private var titleField: String = ""
    @State private var textField: String = ""


    var body: some View {

        VStack(alignment: .leading) {
            CustomBackButton()

            TextField(text, text: $titleField)
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing], 37)
                .background(Color.cgray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disableAutocorrection(true)
                .font(.title2)
                .fontWeight(.semibold)

//            TextField(title)
////                .font(.largeTitle)
//                .padding(.leading, 15)
//                .font(Font.system(size: 40))
//                .fontWeight(.bold)


            // Main content
            Text(text)

            Spacer()
        }
//        .padding()
    }

}

struct CustomBackButton: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    var body: some View {
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
    }
}

#Preview {
    TaskView(title: "Заняться спортом", text: "Some text", date: "19/11/24")
}
