import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var task: Task
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack{
            Image("main").resizable().ignoresSafeArea()
            VStack(alignment: .leading){
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.clear)
                        .background(Color.gray.opacity(0.6))
                        .clipShape(.rect(cornerRadius: 25, style: .continuous))
                        .frame(height: 120)
                    VStack(alignment: .leading){
                        TextField("Task Title", text: $task.title)
                        TextField("Task Subtitle", text: $task.subtitle)
                        Toggle("Completed", isOn: $task.isCompleted)
                    }.padding(.horizontal)
                }
                
                Text("Preview").font(.title2).fontWeight(.semibold)
                    .padding(.top, 50)
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.clear)
                        .background(Color.gray.opacity(0.6))
                        .clipShape(.rect(cornerRadius: 25, style: .continuous))
                        .frame(height: 100)
                    HStack{
                        VStack(alignment: .leading){
                            Text(task.title)
                                .font(.title2)
                                .foregroundStyle(.black)
                            Text(task.subtitle)
                                .font(.callout)
                                .foregroundStyle(.gray)
                            Text(task.isCompleted ? "Complete" : "Not complete")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                            
                            
                        }
                        Spacer()
                        if task.isCompleted{
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                        
                    }.padding(.horizontal)
                }
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview{
    EditTaskView(task: Task.init(title: "" , subtitle: "", isCompleted: true))
}
