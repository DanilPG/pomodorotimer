import SwiftUI
import Foundation
import SwiftData

class PomodoroTimerManager: ObservableObject {// Это класс-менеджер, который контролирует объект таймера Он является ObservableObject, что позволяет автоматически обновлять интерфейс, когда свойства этого объекта изменяются.
    @Published var timer: PomodoroTimer //Используется для отслеживания и обновления состояния таймера.

    // Добавление modelContext в инициализацию
    init(workInSeconds: Int = 1500, breakInSeconds: Int = 300, modelContext: ModelContext? = nil) {
        self.timer = PomodoroTimer(workInSeconds: TimeInterval(workInSeconds), breakInSeconds: TimeInterval(breakInSeconds), modelContext: modelContext)
        self.timer.onSessionComplete = handleSessionComplete // Подписываемся на завершение сессии
    }

    // Обработка завершения только рабочих сессий
    func handleSessionComplete(duration: TimeInterval, isWorkSession: Bool, modelContext: ModelContext?) {
        guard isWorkSession else { return } // Игнорируем паузы
        
        // Проверка наличия modelContext перед сохранением
        if let context = modelContext {
            let startTime = Date.now.addingTimeInterval(-duration)
            let newSession = TimerSession(startTime: startTime, duration: duration)
            context.insert(newSession)

            do {
                try context.save()
                print("Рабочая сессия завершена и сохранена.")
            } catch {
                print("Ошибка при сохранении рабочей сессии: \(error)")
            }
        } else {
            print("Ошибка: modelContext равен nil.")
        }
    }
}
//Этот код реализует менеджер для управления таймером Pomodoro, используя модель PomodoroTimer для работы с сессиями. Основная цель класса PomodoroTimerManager — контролировать таймер Pomodoro, а также сохранять завершенные рабочие сессии в базу данных через ModelContext.
