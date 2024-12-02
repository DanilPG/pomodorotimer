import SwiftUI
import SwiftData
import Observation

struct TimerSettingsView: View {
    @EnvironmentObject var timerManager: PomodoroTimerManager
    @Environment(\.dismiss) var dismiss // Для закрытия представления
    
    @Binding var workMinutes: Int
    @Binding var breakMinutes: Int//Привязки для времени работы и отдыха. Эти значения передаются из родительского компонента и позволяют синхронизировать изменения между TimerSettingsView и основным экраном.
    @ObservedObject var timer: PomodoroTimer // Объект таймера, изменения в котором отслеживаются в реальном времени. Через него обновляются параметры длительности работы и отдыха

    var body: some View {
        ZStack{
            Image("main").resizable().ignoresSafeArea()
            VStack {
                Text("Timer settings")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.bottom, 20)
                
                Spacer()
                
                // Настройка времени работы
                VStack(alignment: .leading) {
                    Text("Work time(minutes)")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.bottom, 10)
                    
                    Picker("Work time", selection: $workMinutes) {
                        ForEach(1..<61) { minute in
                            Text("\(minute) min").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }
                .padding(.bottom, 40)
                
                // Настройка времени отдыха
                VStack(alignment: .leading) {
                    Text("Break time (minutes):")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.bottom, 10)
                    
                    Picker("Break time", selection: $breakMinutes) {
                        ForEach(1..<61) { minute in
                            Text("\(minute) min").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }
                
                Spacer()
                
                // Кнопка для сохранения
                Button("Save") {
                    // Обновление таймера с новыми значениями
                    timer.durationWork = TimeInterval(workMinutes * 60) // Преобразование в секунды
                    timer.durationBreak = TimeInterval(breakMinutes * 60) // Преобразование в секунды
                    dismiss() // Закрываем представление
                }
                .padding(.leading,40)
                .padding(.trailing,40)
                .padding(.top,15)
                .padding(.bottom,15)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
                .background(Color("Button"))
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .frame(width: 145, height: 47)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSettingsView(
            workMinutes: .constant(25),
            breakMinutes: .constant(5),
            timer: PomodoroTimer(workInSeconds: 1500, breakInSeconds: 300) // 25 мин и 5 мин
        )
    }
} 
