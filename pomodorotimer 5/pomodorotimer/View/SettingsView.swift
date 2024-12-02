import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [Task]
    @State private var showAddTaskView = false
    @EnvironmentObject var timerManager: PomodoroTimerManager

    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("main").resizable().ignoresSafeArea()
                List{
                    ForEach(tasks){task in
                        ZStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.clear)
                                .background(Color("circle"))
                                .clipShape(.rect(cornerRadius: 25, style: .continuous))
                                .frame(height: 90)
                            NavigationLink(destination: EditTaskView(task: task)){
                                HStack{
                                    VStack(alignment: .leading){
                                        Text(task.title)
                                            .font(.title2)
                                            .foregroundStyle(.black)
                                        Text(task.subtitle)
                                            .font(.callout)
                                            .foregroundStyle(.black.opacity(0.5))
                                        Text(task.isCompleted ? "Complete" : "Not complete")
                                            .font(.footnote)
                                            .foregroundStyle(.black.opacity(0.5))
                                        
                                    
                                    }
                                    Spacer()
                                    if task.isCompleted{
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .imageScale(.large)
                                    }
                                }
                            }.padding(.horizontal)
                        }
                        
                    }
                    .onDelete(perform: deleteTasks)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .navigationTitle("Tasks")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        NavigationLink(destination: AddTaskView()){
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
    private func deleteTasks(offsets: IndexSet){
        withAnimation{
            for index in offsets{
                let task = tasks[index]
                modelContext.delete(task)
            }
        }
    }
    
}
#Preview {
    SettingsView()
}
