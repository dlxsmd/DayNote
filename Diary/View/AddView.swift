import SwiftUI
import PhotosUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) private var context
    private struct EntryData{
        var date: Date
        var title: String
        var detail: String
        var image: Data?
        init(){
            self.date = Date()
            self.title = ""
            self.detail = ""
            self.image = nil
        }
    }
    @State private var entrydata = EntryData()
    @State var selectedItem: PhotosPickerItem?
    @State var showImage: UIImage?
    @FocusState  var isActive:Bool
    @Binding var isShowAdd: Bool
    
    var body: some View {
        
        NavigationStack{
            ScrollView{
                //タイトル
                TextField("タイトル",text:$entrydata.title)
                    .font(.largeTitle)
                    .frame(width: 350,height:50)
                    .padding()
                    .focused($isActive)
                //日付
                DatePicker("日付",selection: $entrydata.date,displayedComponents: [.date])
                    .environment(\.locale, Locale(identifier: "us_US"))
                    .labelsHidden()
                    .scaleEffect(CGSize(width: 1.25, height: 1.25))
                    .padding()
                //画像を表示
                if entrydata.image != nil {
                    PhotosPicker(selection: $selectedItem,matching: .images) {
                        Image(uiImage: showImage!)
                            .resizable(resizingMode: .stretch)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350, height: 250)
                            
                    }
                } else {
                    ZStack{
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width:350,height: 250)
                        PhotosPicker(selection: $selectedItem,matching: .images) {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 60, height: 50)
                                .shadow(radius: 5)
                                .foregroundColor(.white)
                        }
                    }
                }
                //本文
                VStack{
                    TextField("本文",text:$entrydata.detail,axis: .vertical)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .focused($isActive)
                }.padding()
                //
                Spacer()
                //
            }.toolbar{
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("完了") {
                        isActive = false
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .onTapGesture{
                            isShowAdd.toggle()
                        }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        onAdd()
                    }){
                        Text("Save")
                    }
                }
            }
            //uiimageを取得
            .onChange(of: selectedItem) {
                Task {
                    guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
                                    guard let uiImage = UIImage(data: data) else { return }
                    showImage = uiImage
                    entrydata.image = uiImage.pngData()
                    }
                }
        } //VStack
    } //NavigationStack
    //add func
    func onAdd(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd,EEE"
        let dateString = dateFormatter.string(from: entrydata.date)
        if entrydata.title.isEmpty || dateString.isEmpty || entrydata.detail.isEmpty || entrydata.image == nil{
            return
        }
        let newEntry = DiaryIn(title: entrydata.title, date: dateString, detail: entrydata.detail, image: entrydata.image)
        context.insert(newEntry)
        try? context.save()
        isShowAdd.toggle()
   
        
    }//body
}//View

#Preview{
    AddView(isShowAdd: .constant(true))
        .modelContainer(for: DiaryIn.self,inMemory: true)
}
