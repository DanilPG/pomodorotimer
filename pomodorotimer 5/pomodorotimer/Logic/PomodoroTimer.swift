import SwiftUI
import SwiftData
import Observation

enum PomodoroTimerState: String { //состояния таймера
    case idle         //Таймер не активен
    case running   //Таймер активен
    case paused     //Таймер в режиме паузы
}

enum PomodoroTimerMode: String { //Определяет текущий режим таймера
    case work
    case pause

    var title: String {
        switch self {
        case .work:
            return "work"
        case .pause:
            return "break"
        }
    }
}

@Observable
class PomodoroTimer: ObservableObject {
    public var mode: PomodoroTimerMode = .work              //Текущий режим таймера
    public var state: PomodoroTimerState = .idle          //Тексущие состояние таймера
    public var durationWork: TimeInterval                       //Длительность работы таймера(сек)
    public var durationBreak: TimeInterval                      //Длительность перерыва(сек)
    public var secondsPassed: Int = 0                                   //Сколько сек прошло 
    public var fractionPassed: Double = 0                           //доля завершения текущей сессии
    public var dateStarted: Date = Date.now
    public var secondsPassedBeforePause: Int = 0
    
    public var onSessionComplete: ((TimeInterval, Bool, ModelContext?) -> Void)?   //колбек для завершения сесии
    private var timer: Timer?
    private var audio: PomodoroAudio = PomodoroAudio()
    private var isSessionSaved: Bool = false // Флаг для предотвращения повторного сохранения
    
    private var modelContext: ModelContext?  //используется для сохранения в базу данных

    public var isCompleted: Bool = false
    
    init(workInSeconds: TimeInterval, breakInSeconds: TimeInterval, modelContext: ModelContext? = nil) {
        durationWork = workInSeconds
        durationBreak = breakInSeconds
        self.modelContext = modelContext
    }

    var secondsPassedString: String {
        return _formatSeconds(secondsPassed)
    }

    var secondsLeft: Int { // количество оставшихся секунд в текущей сессии.
        Int(_duration) - secondsPassed
    }

    var secondsLeftString: String {  //форматированное отображение оставшихся секунд.
        return _formatSeconds(secondsLeft)
    }

    var fractionLeft: Double {  //доля оставшегося времени.
        1.0 - fractionPassed
    }

    private var _duration: TimeInterval {  // общее время текущей сессии
        mode == .work ? durationWork : durationBreak
    }

    func start() {  //запуск сессии
        dateStarted = Date.now
        secondsPassed = 0
        fractionPassed = 0
        state = .running
        isSessionSaved = false // Сбрасываем флаг
        _createTimer()
    }

    func resume() {  //возобновить работы после паузы
        dateStarted = Date.now
        state = .running
        _createTimer()
    }

    func pause() {  //ставит таймер на паузу
        secondsPassedBeforePause = secondsPassed
        state = .paused
        _killTimer()
    }

    func reset(modelContext: ModelContext? = nil) {  //сброс таймера
        if secondsPassed > 0, let context = modelContext ?? self.modelContext {
            _saveCompletedSession(modelContext: context)
        }
        secondsPassed = 0
        fractionPassed = 0
        secondsPassedBeforePause = 0
        isCompleted = false // Сбрасываем флаг завершения
        state = .idle
        mode = (mode == .work) ? .pause : .work // Переключаем режим
        _killTimer()
    }





    func skip() {  //скипнуть сессию
        if mode == .work {
            mode = .pause
        } else {
            mode = .work
        }
    }


    private func _createTimer() {  //создание таймера
        PomodoroNotification.scheduleNotification(seconds: TimeInterval(secondsLeft), title: "Timer Done", body: "Your pomodoro timer is finished.")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self._onTick()
        }
    }

    private func _killTimer() { //уничтожает активный таймер
        timer?.invalidate()
        timer = nil
    }

    func _onTick() { //обновление таймера каждую секунду
        let secondsSinceStartDate = Date.now.timeIntervalSince(dateStarted)
        secondsPassed = Int(secondsSinceStartDate) + secondsPassedBeforePause
        fractionPassed = TimeInterval(secondsPassed) / _duration

        if secondsLeft == 0 { 
            _killTimer() // Останавливаем таймер
            isCompleted = true // Отмечаем завершение сессии

            if mode == .work, let context = modelContext {
                // Сохраняем рабочую сессию
                onSessionComplete?(TimeInterval(secondsPassed), true, context)
            }

            // Уведомляем об окончании
            audio.play(.done)
        }
    }








    func _saveCompletedSession(modelContext: ModelContext) {
        guard mode == .work else {
            print("Сессия не сохранена: режим не работа.")
            return
        }
        let completedSession = TimerSession(startTime: dateStarted, duration: TimeInterval(secondsPassed))
        modelContext.insert(completedSession)

        do {
            try modelContext.save()
            print("Рабочая сессия завершена и сохранена: \(completedSession).")
        } catch {
            print("Ошибка при сохранении рабочей сессии: \(error)")
        }
    }


    private func _formatSeconds(_ seconds: Int) -> String {
        if seconds <= 0 {
            return "00:00"
        }
        let hh = seconds / 3600
        let mm = (seconds % 3600) / 60
        let ss = seconds % 60
        if hh > 0 {
            return String(format: "%02d:%02d:%02d", hh, mm, ss)
        } else {
            return String(format: "%02d:%02d", mm, ss)
        }
    }
}
