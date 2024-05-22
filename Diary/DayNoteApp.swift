import SwiftUI
import SwiftData

@main
struct DayNote: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
                .modelContainer(for: DiaryIn.self)
           
        }
    }
}

@Model
class DiaryIn: Identifiable {
    var id = UUID()
    var title: String
    var date: String
    var detail: String
    var image:Data?
    init(id: UUID = UUID(), title: String, date: String, detail: String, image: Data? = nil) {
        self.id = id
        self.title = title
        self.date = date
        self.detail = detail
        self.image = image
    }
}




