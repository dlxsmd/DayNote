import SwiftUI

struct ColorSetView: View {
    @Binding var colorset:Int
    @Binding var isColorSet: Bool
    private let maxWidth = UIScreen.main.bounds.width
    let colorList = ["Orange","Blue","Purple","Red","Green","Gray","Black"]
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(isColorSet ? 0.7 : 0)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isColorSet.toggle()
                    }
                }
            List {
                ForEach(1..<8) { i in
                    Button(action: {
                        colorset = i
                        UserDefaults.standard.set(colorset, forKey: "colorset")
                        isColorSet.toggle()
                    }) {
                        Text(colorList[i-1])
                            .frame(width: 120,height: 40)
                        .foregroundColor(i == colorset ? Color.white : Color.black)                        }
                    .padding(.all,10)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .background(i == colorset ? Color.blue.opacity(0.7) : Color.white)
                    .cornerRadius(10)
                }
            }
            .cornerRadius(10)
            .padding(.leading, maxWidth/2)
            .offset(x: isColorSet ? 0 : maxWidth)
        }
    }
}
