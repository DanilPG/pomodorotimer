import SwiftUI
import SwiftData

struct StatisticsView: View {
    @EnvironmentObject var timerManager: PomodoroTimerManager
    @Query(sort: \TimerSession.startTime, order: .reverse) var sessions: [TimerSession]
    @State private var selectedDate = Date()
    @State private var dailySessions: [TimerSession] = []
    @State private var totalWorkTime: TimeInterval = 0

    var body: some View {
        NavigationView {
            ZStack{
                Image("main").resizable().ignoresSafeArea()
                VStack {
                    // Календарь для выбора даты
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding()
                    
                    // Статистика по выбранной дате
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Statistics for \(formattedDate(selectedDate))")
                            .font(.title2)
                            .bold()
                        
                        Text("Total Sessions: \(dailySessions.count)")
                            .font(.headline)
                        
                        Text("Total Work Time: \(formattedTime(totalWorkTime))")
                            .font(.headline)
                    }
                    .padding()
                    
                    // Список сессий
                    List(dailySessions) { session in
                        HStack {
                            Text("Session at \(formattedDate(session.startTime))")
                            Spacer()
                            Text("\(formattedTime(session.duration))")
                                .foregroundColor(.gray)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .onChange(of: selectedDate) { _ in
                        updateDailyStatistics(for: selectedDate)
                    }
                }
                .navigationTitle("Timer Statistics")
                .onAppear {
                    updateDailyStatistics(for: selectedDate)
                }
            }
        }
    }

    // Форматирование даты
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // Форматирование времени (TimeInterval)
    private func formattedTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }

    // Обновление статистики для выбранного дня
    private func updateDailyStatistics(for date: Date) {
        // Фильтрация сессий по дате
        dailySessions = sessions.filter { Calendar.current.isDate($0.startTime, inSameDayAs: date) }
        
        // Вычисление общего времени работы
        totalWorkTime = dailySessions.reduce(0) { $0 + $1.duration }
    }
}
