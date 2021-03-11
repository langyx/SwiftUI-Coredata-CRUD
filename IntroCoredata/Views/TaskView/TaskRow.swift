//
//  TaskRow.swift
//  IntroCoredata
//
//  Created by Yannis Lang on 11/03/2021.
//  Copyright © 2021 Yannis Lang. All rights reserved.
//

import SwiftUI

struct TaskRow: View {
    let task: Task
    
    var body: some View {
        HStack{
            Text("\(task.name ?? "Sans nom")")
            Spacer()
            Button(action: {
                task.done.toggle()
            }, label: {
                Image(systemName: task.done ? "checkmark.circle" : "xmark.circle")
                    .foregroundColor(task.done ? .green : .red)
                
            })
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Task(context: context)
        task.name = "Test"
        
        return TaskRow(task: task)
    }
}
