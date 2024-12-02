
import SwiftUI
import SwiftData

@main
struct pomodorotimerApp: App {
    
    @StateObject private var timerManager = PomodoroTimerManager(workInSeconds: 1500, breakInSeconds: 300)
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [TimerSession.self, Task.self])
                .environmentObject(timerManager)
        }
    }
}

