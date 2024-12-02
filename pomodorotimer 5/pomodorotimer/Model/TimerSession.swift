import SwiftData
import Foundation

@Model
class TimerSession {
    var startTime: Date
    var duration: TimeInterval

    
    init(startTime: Date, duration: TimeInterval) {
        self.startTime = startTime
        self.duration = duration
    }
}

