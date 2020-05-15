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
    @State private var viewMode: Int = 0 //0->All, 1->Done
    
    var body: some View {
        NavigationView{
            VStack{
                Picker(selection: $viewMode, label: Text("")) {
                    Text("A faire").tag(0)
                    Text("Fait").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List{
                    Section(header: VStack(spacing: 0){
                        if self.viewMode == 0 {
                            TextField("Nouvelle tache", text: self.$newTaskName)
                                .padding(.top)
                            Button(action: {
                                let newTask = Task.init(context: self.managedObjectContext)
                                newTask.name = self.newTaskName
                                
                                try? self.managedObjectContext.save()
                                
                                self.newTaskName = ""
                            }, label: {
                                Text("Ajouter")
                            })
                                .padding()
                        }
                    }) {
                        ForEach(self.data(), id: \.self) { oneTask in
                            HStack{
                                Text("\(oneTask.name ?? "Sans nom")")
                                Spacer()
                                Button(action: {
                                    oneTask.done.toggle()
                                }, label: {
                                    Image(systemName: oneTask.done ? "checkmark.circle" : "xmark.circle")
                                    .foregroundColor(oneTask.done ? .green : .red)
                                        
                                })
                            }
                        }
                        .onDelete(perform: { offsets in
                            for offset in offsets {
                                let taskToDelete = self.tasks[offset]
                                
                                self.managedObjectContext.delete(taskToDelete)
                                try? self.managedObjectContext.save()
                            }
                        })
                    }
                }
            }
            
            .navigationBarTitle("Tasks")
        }
    }
    
    private func data() -> [Task] {
        if self.viewMode == 0{
            return self.tasks.filter({ !$0.done })
        }
        return self.tasks.filter({ $0.done })
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return TaskList().environment(\.managedObjectContext, context)
    }
}
