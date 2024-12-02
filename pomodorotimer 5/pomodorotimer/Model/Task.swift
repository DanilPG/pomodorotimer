import SwiftUI
import SwiftData

@Model
class Task{
    var title: String
    var subtitle: String
    var isCompleted: Bool
    


    
    init(title: String, subtitle: String, isCompleted: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.isCompleted = isCompleted

      }

}
