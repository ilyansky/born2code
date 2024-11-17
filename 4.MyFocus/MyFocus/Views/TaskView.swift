import SwiftUI

struct TaskView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    var text: String

    var body: some View {
        VStack {
            // Custom bar back button
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

            // Main content
            Text(text)

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }

}

#Preview {
    TaskView(text: "Some text")
}
