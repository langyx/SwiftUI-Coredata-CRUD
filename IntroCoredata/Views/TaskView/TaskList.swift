//
//  TaskList.swift
//  IntroCoredata
//
//  Created by Yannis Lang on 15/05/2020.
//  Copyright © 2020 Yannis Lang. All rights reserved.
//

import SwiftUI

struct TaskList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasks: FetchedResults<Task>
    
    @State private var newTaskName: String = ""
    @State private var viewMode: ViewMode = .toDo
    
    var body: some View {
        NavigationView{
            VStack{
                viewModePicker
                List{
                    Section(header: taskSectionHeader) {
                        ForEach(self.data(), id: \.self) { task in
                            TaskRow(task: task)
                        }
                        .onDelete(perform: delete)
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle("Tasks")
        }
    }
    
    private func data() -> [Task] {
        switch viewMode {
        case .toDo:
            return tasks.filter({ !$0.done })
        default:
            return tasks.filter({ $0.done })
        }
    }
}

extension TaskList {
    private func delete(offsets: IndexSet) {
        for offset in offsets {
            let taskToDelete = tasks[offset]
            managedObjectContext.delete(taskToDelete)
            try? managedObjectContext.save()
        }
    }
    
    private func add() {
        let newTask = Task.init(context: managedObjectContext)
        newTask.name = newTaskName
        try? managedObjectContext.save()
        newTaskName = ""
    }
}

extension TaskList {
    private var viewModePicker: some View {
        Picker(selection: $viewMode, label: EmptyView()) {
            ForEach(ViewMode.allCases, id: \.self) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    private var taskSectionHeader: some View {
        VStack(spacing: 0){
            if self.viewMode == .toDo {
                TextField("Nouvelle tache", text: self.$newTaskName)
                    .padding(.top)
                Button(action: {
                    add()
                }, label: {
                    Text("Ajouter")
                })
                .padding()
            }
        }
    }
}

extension TaskList {
    enum ViewMode: String, CaseIterable {
        case toDo = "A faire"
        case done = "Fait"
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return TaskList().environment(\.managedObjectContext, context)
    }
}
