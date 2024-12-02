import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject var timerManager: PomodoroTimerManager //объект, предоставляющий доступ к управлению таймером через PomodoroTimerManager
    @Environment(\.modelContext) private var modelContext: ModelContext //доступ к контексту модели данных, необходимому для сохранения состояния таймера.
    @State private var showTimerSettings = false
    @State private var displayWarning = false
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        ZStack {
            Image("main").resizable().ignoresSafeArea()
            VStack {
                CircleTimer(fraction: timerManager.timer.fractionPassed,
                            primaryText: timerManager.timer.secondsLeftString,
                            secondaryText: timerManager.timer.mode.title)
                    .frame(width: 360)

                HStack(spacing: 30) {
                    if timerManager.timer.isCompleted  {
                        CircleButton(icon: "stop.fill") {
                            timerManager.timer.reset(modelContext: modelContext) // Передаем modelContext здесь
                        }
                    }
                    else{
                        // Кнопка пропуска паузы (показывается только, когда таймер в состоянии idle и в режиме pause)
                        if timerManager.timer.state == .idle && timerManager.timer.mode == .pause {
                            CircleButton(icon: "forward.fill") {
                                timerManager.timer.skip() // Передаем modelContext здесь
                            }
                        }
                        
                        // Кнопка старта рабочего таймера (показывается только, когда таймер в состоянии idle и в режиме work)
                        if timerManager.timer.state == .idle && timerManager.timer.mode == .work {
                            CircleButton(icon: "play.fill") {
                                timerManager.timer.start()
                            }
                        }
                        
                        // Кнопка старта паузы (показывается только, когда таймер в состоянии idle и в режиме pause)
                        if timerManager.timer.state == .idle && timerManager.timer.mode == .pause {
                            CircleButton(icon: "play.fill") {
                                timerManager.timer.start()
                            }
                        }
                        
                        // Кнопка возобновления таймера (показывается, когда таймер на паузе)
                        if timerManager.timer.state == .paused {
                            CircleButton(icon: "play.fill") {
                                timerManager.timer.resume()
                            }
                        }
                        
                        // Кнопка паузы таймера (показывается, когда таймер работает)
                        if timerManager.timer.state == .running {
                            CircleButton(icon: "pause.fill") {
                                timerManager.timer.pause()
                            }
                        }
                        
                        // Кнопка сброса таймера (показывается, когда таймер работает или на паузе)
                        if timerManager.timer.state == .running || timerManager.timer.state == .paused {
                            CircleButton(icon: "stop.fill") {
                                timerManager.timer.reset(modelContext: modelContext) // Передаем modelContext здесь
                            }
                        }}

                    // Кнопка настроек таймера
                    Button(action: {
                        showTimerSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color("Button"))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .frame(width: 60, height: 60)
                    .sheet(isPresented: $showTimerSettings) {
                        TimerSettingsView(
                            workMinutes: Binding(
                                get: { Int(timerManager.timer.durationWork / 60) },
                                set: { timerManager.timer.durationWork = TimeInterval($0 * 60) }
                            ),
                            breakMinutes: Binding(
                                get: { Int(timerManager.timer.durationBreak / 60) },
                                set: { timerManager.timer.durationBreak = TimeInterval($0 * 60) }
                            ),
                            timer: timerManager.timer
                        )
                    }
                }
                .padding(.top, 25)
                .padding(.bottom, 100)

                // Показываем предупреждение, если уведомления отключены
                if displayWarning {
                    NotificationsDisabled()
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    PomodoroNotification.checkAuthorization { authorized in
                        displayWarning = !authorized
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(PomodoroTimerManager(workInSeconds: 1500, breakInSeconds: 300)) // Передаем параметры
}
