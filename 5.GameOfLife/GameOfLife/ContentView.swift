import SwiftUI


struct ContentView: View {
    @State private var cells: [Bool] = []
    @State private var showPush = false
    private var model = Model()
    
    var body: some View {
        VStack {
            Text("Клеточное наполнение")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.background)
                .padding()
            
            ScrollViewReader { svreader in
                VStack {
                    List(0..<cells.count, id: \.self) { i in
                        Cell(live: cells[i])
                            .listRowBackground(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .id(i)
                    }
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .onChange(of: cells) {
                        withAnimation {
                            svreader.scrollTo(cells.count - 1, anchor: .bottom)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            cells.append(model.nextCell())
                            (showPush, cells) = model.checkStreak(cells: cells)
                        }
                    } label: {
                        Text("СОТВОРИТЬ")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemPurple))
                            .foregroundStyle(.background)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding()
                    .alert(isPresented: $showPush) {
                        Alert(
                            title: Text(model.pushType == .newLife ? "Зародилось 2 новых жизни!" : "Жизни в мире Шамбамбукли больше нет..."),
                            dismissButton: .default(Text(model.pushType == .newLife ? "Отлично!" : "..."))
                        )
                    }
                }
            }
            
        }
        .background(Gradient(colors: model.backgroundColor))
    }
}

struct Cell: View {
    let live: Bool
    
    var body: some View {
        HStack {
            Image(live ? "live" : "dead")
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .background(.white)
                .padding([.leading, .top, .bottom])
            VStack {
                Text(live ? "Живая" : "Мёртвая")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(live ? "и шевелится!" : "или прикидывается")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .background(Color.white)
    }
    
}

#Preview {
    ContentView()
}
