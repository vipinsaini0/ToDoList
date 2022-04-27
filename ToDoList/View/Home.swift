    //
    //  Home.swift
    //  ToDoList
    //
    //  Created by Vipin Saini on 27/04/22.
    //

import SwiftUI
import RealmSwift

struct Home: View {
    
        //Sorting by date
    @ObservedResults(TaskItem.self, sortDescriptor: SortDescriptor.init(keyPath: "taskDate", ascending: false)) var tasksFetched
    @State var lastAddedTaskID: String = ""
    
    var body: some View {
        
        NavigationView {
            ZStack {
                if tasksFetched.isEmpty {
                    Text("Add some new Tasks!")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(tasksFetched) { task in
                            TaskRow(task: task, lastAddedTaskID: $lastAddedTaskID)
                                //Delete data
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        $tasksFetched.remove(task)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .animation(.easeInOut, value: tasksFetched)
                }
            }
            .navigationTitle("Task's")
            .toolbar {
                Button {//Add task
                    let task = TaskItem()
                    lastAddedTaskID = task.id.stringValue
                    $tasksFetched.append(task)
                } label: {
                    Image(systemName: "plus")
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                lastAddedTaskID = ""
                guard let last = tasksFetched.last else { return }
                
                if last.taskTitle.isEmpty {
                    $tasksFetched.remove(last)
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct TaskRow: View {
    @ObservedRealmObject var task: TaskItem
    @Binding var lastAddedTaskID: String
    @FocusState var showKeyboard: Bool //keyboard focus
    
    var body: some View {
        HStack(spacing: 15) {
                //task status menu
            Menu {
                    //update data
                Button("Missed") {
                    $task.taskStatus.wrappedValue = .missed
                }
                Button("Completed") {
                    $task.taskStatus.wrappedValue = .completed
                }
            } label: {
                Circle()
                    .stroke(.gray)
                    .frame(width: 15, height: 15)
                    .overlay(
                        Circle()
                            .fill(task.taskStatus == .missed ? .red : (task.taskStatus == .pending ? .yellow : .green))
                    )
            }
            VStack(alignment: .leading, spacing: 12) {
                    //Task title
                TextField("Add todo name here", text: $task.taskTitle)
                    .focused($showKeyboard)
                    //Task date
                if task.taskTitle != "" {
                    Picker(selection: .constant("")) {
                        DatePicker(selection: $task.taskDate, displayedComponents: .date) {
                            
                        }
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .navigationTitle("Task Date")
                    } label: {
                        Image(systemName: "calendar")
                        
                        Text(task.taskDate.formatted(date: .abbreviated, time: .omitted))
                    }
                }
            }
        }
        .onAppear {
            if lastAddedTaskID == task.id.stringValue {
                showKeyboard.toggle()
            }
        }
    }
}
