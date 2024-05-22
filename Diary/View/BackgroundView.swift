import SwiftUI

struct BackgroundView: View {
    @Binding var colorset:Int
    var body: some View {
       ZStack{
           switch colorset{
           case 1:
               Color.orange.opacity(0.6)
                   .edgesIgnoringSafeArea(.all)
           case 2:
               Color.blue.opacity(0.6)
                   .edgesIgnoringSafeArea(.all)
           case 3:
               Color.purple.opacity(0.6)
                   .edgesIgnoringSafeArea(.all)
           case 4:
               Color.red.opacity(0.6)
                   .edgesIgnoringSafeArea(.all)
           case 5:
               Color.green.opacity(0.6)
                   .edgesIgnoringSafeArea(.all)
           case 6:
               Color.gray.opacity(0.6)
                   .edgesIgnoringSafeArea(.all)
           case 7:
               Color.black.opacity(0.6)
                   .edgesIgnoringSafeArea(.all)
           default:
               Color(red:0.2,green:0.8,blue:0.8,opacity: 0.5)
                    .edgesIgnoringSafeArea(.all)
           }
           Circle()
               .fill(.white.opacity(0.7))
               .frame(width: 350)
               .offset(x:-160,y:-400)
           Circle()
               .fill(.white.opacity(0.7))
               .frame(width: 350)
               .offset(x:160,y:400)
       }
    }
}

#Preview {
    BackgroundView(colorset: .constant(1))
        .modelContainer(for: DiaryIn.self,inMemory: true)
}
