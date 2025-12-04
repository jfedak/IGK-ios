//
//  ContentView.swift
//  Zadanie2
//
//  Created by Jakub Fedak on 04/12/2025.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    let imageNumber: Int
    let name: String
}

struct TaskView: View {
    @Binding var task: Task
    
    var body: some View {
        VStack {
            Text(task.name)
                .padding()
            Image(String(task.imageNumber))
                .resizable()
                .frame(width: 300, height: 300)
            Spacer()
        }
    }
}

struct ContentView: View {
    @State private var tasks = [
        Task(imageNumber: 1, name: "Task no 1"),
        Task(imageNumber: 2, name: "Task no 2"),
        Task(imageNumber: 3, name: "Task no 3"),
        Task(imageNumber: 4, name: "Task no 4"),
        Task(imageNumber: 5, name: "Task no 5"),
        Task(imageNumber: 6, name: "Task no 6"),
        Task(imageNumber: 7, name: "Task no 7"),
    ]
        
    var body: some View {
        NavigationStack {
            List($tasks) { $task in
                NavigationLink {
                    TaskView(task: $task)
                } label: {
                    Text(task.name)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        // bez tego apka crashowala bo zminimalizowaniu i powrocie do niej
                        if let idx = tasks.firstIndex(where: {task.id == $0.id}) {
                            tasks.remove(at: idx)
                        }
                        print("Item deleted")
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Tasks")
        }
    }
}

#Preview {
    ContentView()
}
