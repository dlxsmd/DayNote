import SwiftUI
import Zoomable

struct DetailView: View {
    var entry: DiaryIn
    @Binding var colorset: Int
    private let maxWidth = UIScreen.main.bounds.width
    @State var isShowDetailPhoto = false
    
    var body: some View {
        //↓NavigationStack
        NavigationStack{
            //↓ScrollView
            ScrollView{
                //↓VStack
                VStack{
                    Text(entry.date)
                        .font(.title)
                        .padding()
                    
                    if let image = entry.image, let uiImage = UIImage(data: image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                            .cornerRadius(10)
                            .padding(10)
                            .shadow(radius: 25)
                            .onTapGesture {
                                isShowDetailPhoto.toggle()
                            }
                            .fullScreenCover(isPresented: $isShowDetailPhoto) {
                                Detail_photo(uiImage: uiImage,isShowDetailPhoto: $isShowDetailPhoto)
                                
                            }
                    }else{
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 350)
                    }
                    Text(entry.detail)
                        .multilineTextAlignment(.center)
                        .textSelection(.enabled)
                        .padding()
                        .font(.title2)
                    
                    Spacer()
                }
                //↑VStack
            }
          //↑ScrollView
            .frame(width: maxWidth)
            .background(BackgroundView(colorset: $colorset))
            .navigationTitle(entry.title)
        }
        //↑NavigationStack
    }
    //↑body
}
//↑DetailView

struct Detail_photo: View{
    var uiImage: UIImage
    @Binding var isShowDetailPhoto:Bool
    var body: some View{
        ZStack{
            Color.black
                .ignoresSafeArea()
            Image(uiImage: uiImage)
                    .resizable()
                    .padding(20)
                    .scaledToFit()
                    .zoomable(outOfBoundsColor: .black)
        }.onTapGesture {
            isShowDetailPhoto.toggle()
        }//↑ZStack
        }//↑body
    }//↑Detail_photo

#Preview{
    DetailView(entry: DiaryIn(title: "title", date: "2022/02/02", detail: "detail", image: nil),colorset: .constant(1))
        .modelContainer(for: DiaryIn.self,inMemory: true)
}

