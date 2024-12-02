import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var activeTab: Tab = .settings
    @Namespace private var animation

    @StateObject var timerManager = PomodoroTimerManager(workInSeconds: 1500, breakInSeconds: 300)
    
    @State private var workMinutes: Int = 25
    @State private var breakMinutes: Int = 5

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch activeTab {
                case .timer:
                    SettingsView()
                        .modelContainer(for: [TimerSession.self, Task.self])
                        .environmentObject(timerManager)
                    
                case .settings:
                    HomeView()
                        .modelContainer(for: [TimerSession.self, Task.self])
                        .environmentObject(timerManager)
                    
                case .statistics:
                    StatisticsView()
                        .modelContainer(for: [TimerSession.self, Task.self])
                        .environmentObject(timerManager)
                }

                Spacer()
            }

            VStack {
                Spacer()
                CustomTabBar()
                    .padding(.bottom)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    @ViewBuilder
    func CustomTabBar(_ tint: Color = Color("Button"), _ inactiveTint: Color = Color("Button")) -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                TabItem(tint: tint, inactiveTint: inactiveTint, tab: tab, animation: animation, activeTab: $activeTab)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Color("TabBarBackground").ignoresSafeArea(edges: .bottom))
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}


// Таб для переключения
struct TabItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    var animation: Namespace.ID
    @Binding var activeTab: Tab

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : inactiveTint)
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                activeTab = tab
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PomodoroTimerManager(workInSeconds: 1500, breakInSeconds: 300))
}


