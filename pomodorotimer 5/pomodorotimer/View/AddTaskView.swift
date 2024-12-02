import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.modelContext) private var modelContext // Получаем доступ к контексту
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var subtitle = ""
    @State private var isCompleted = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("main").resizable().ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.clear)
                            .background(Color.gray.opacity(0.6))
                            .clipShape(.rect(cornerRadius: 25, style: .continuous))
                            .frame(height: 120)
                        
                        VStack(alignment: .leading) {
                            TextField("Task title", text: $title)
                            TextField("Task SubTitle", text: $subtitle)
                            Toggle("Completed", isOn: $isCompleted)
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("Preview").font(.title2).fontWeight(.semibold)
                        .padding(.top, 50)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.clear)
                            .background(Color.gray.opacity(0.6))
                            .clipShape(.rect(cornerRadius: 25, style: .continuous))
                            .frame(height: 100)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(title)
                                    .font(.title2)
                                    .foregroundStyle(.black)
                                Text(subtitle)
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                                Text(isCompleted ? "Complete" : "Not complete")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            if isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .imageScale(.large)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 50)
                .padding(.horizontal)
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Создаем новую задачу
                        let newTask = Task(title: title, subtitle: subtitle, isCompleted: isCompleted)
                        
                        // Вставляем задачу в модель
                        modelContext.insert(newTask)
                        
                        // Сохраняем контекст для сохранения задачи
                        do {
                            try modelContext.save()
                            print("Task saved successfully.")
                            dismiss() // Закрываем окно после сохранения
                        } catch {
                            // Обрабатываем ошибки при сохранении
                            print("Ошибка при сохранении задачи: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}




#Preview{
    AddTaskView()
}
