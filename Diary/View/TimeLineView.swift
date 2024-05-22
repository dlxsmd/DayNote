import SwiftUI
import SwiftData

struct TimeLineView: View {
    @Environment(\.modelContext) private var context
    @State var isShowAdd = false
    @State var isShowAlert = false
    @Query(sort: \DiaryIn.date) var diaryData: [DiaryIn]
    @State var selectedIndex: Int?
    @State var isColorSet = false
    @AppStorage("colorset") var colorset = 1

    
    //↓body
    var body: some View {
        //↓VStack
        ZStack{
            //↓NavigationStack
            NavigationStack{
                //↓List
                List{
                    //↓ForEach
                    ForEach(diaryData) { entry in
                        //↓NavigationLink
                        NavigationLink(destination:DetailView(entry: entry,colorset: $colorset)) {
                            //↓HStack
                            HStack{
                                VStack{
                                    Text(entry.date)
                                        .font(.system(.title2,design: .rounded))
                                        .font(.system(size: 20))
                                        .multilineTextAlignment(.center)

                                    Text(entry.title)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))
                                        .multilineTextAlignment(.center)

                                }.padding(.leading,15)
                                //VStack
                                    

                                Spacer()
                                if let image = entry.image, let uiImage = UIImage(data: image){
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                            }
                            //↑HStack
                        }
                        //↑NavigationLink
                        .padding(.all,10)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    //↑Foreach
                    .onDelete(perform: deleteItem)
                }
                //↑List
                .listStyle(.plain)
                .background(BackgroundView(colorset: $colorset))
                .navigationBarTitle("timeline")
                .safeAreaInset(edge: .bottom, alignment: .center){
                    ZStack{
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(.black.opacity(0.7))
                            .frame(width: 80,height: 80)
                            .onTapGesture{
                                    isShowAdd.toggle()
                    }
                        }.fullScreenCover(isPresented: $isShowAdd){
                            AddView(isShowAdd: $isShowAdd)
                        }
                    
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isColorSet.toggle()
                            }
                        }){
                            Image(systemName: "c.circle")
                                .foregroundColor(.white)
                                .scaleEffect(1.25)
                        }
                    }
                }
            }
            //↑NavigationStack
            .alert(isPresented: $isShowAlert) {
                if let selectedIndex = selectedIndex, selectedIndex < diaryData.count {
                    let entry = diaryData[selectedIndex]
                    return Alert(
                        title: Text("削除の確認"),
                        message: Text("「\(entry.title)」を削除しますか？"),
                        primaryButton: .destructive(Text("削除"), action: deleteConfirmed),
                        secondaryButton: .cancel(Text("キャンセル"))
                        
                    )
                }else {
                    return Alert(title: Text("エラー"), message: Text("日記が見つかりませんでした"), dismissButton: .default(Text("OK")))
                }
            }
            ColorSetView(colorset: $colorset, isColorSet: $isColorSet)
        }
        //↑ZStack
    }
    //↑body
    //↓func
    func deleteItem(offsets: IndexSet) {
        for index in offsets {
            selectedIndex = index
        }
        isShowAlert = true
    }
    func deleteConfirmed() {
        if let selectedIndex = selectedIndex {
            let entry = diaryData[selectedIndex]
            context.delete(entry)
            do {
                try context.save()
            } catch {
                print("エラー")
            }
        }
    }
    //↑func
}
//↑TimeLineView




                                       
                            

#Preview {
    TimeLineView()
        .modelContainer(for: DiaryIn.self,inMemory: true)
}
