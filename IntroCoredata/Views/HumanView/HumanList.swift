//
//  HumanList.swift
//  IntroCoredata
//
//  Created by Yannis Lang on 29/04/2020.
//  Copyright © 2020 Yannis Lang. All rights reserved.
//

import SwiftUI

struct HumanList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Human.entity(), sortDescriptors: []) var humans: FetchedResults<Human>
     
    @State private var showAddView = false
    @State private var showEditView = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(self.humans, id: \.self) { human in
                    HumanRow(human: human)
                    .onTapGesture {
                        showEditView.toggle()
                    }
                    .sheet(isPresented: $showEditView, content: {
                        HumanAdd(edit: human)
                    })
                }
                .onDelete(perform: delete)
            }
            .sheet(isPresented: $showAddView, content: {
                HumanAdd().environment(\.managedObjectContext, managedObjectContext)
            })
            .navigationBarItems(trailing: navBarRightItem)
            .navigationBarTitle("Humans")
        }
    }
}

extension HumanList {
    private func delete(offsets: IndexSet) {
        for offset in offsets {
            let humanDeleted = humans[offset]
            managedObjectContext.delete(humanDeleted)
            try? managedObjectContext.save()
        }
    }
}

extension HumanList {
    private var navBarRightItem: some View {
        Button(action: {
            showAddView.toggle()
        }, label: {
            Image(systemName: "plus.circle")
                .font(.system(size: 20))
        })
    }
}

struct HumanList_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
        return HumanList().environment(\.managedObjectContext, context).onAppear{
            
            let humanTest = Human.init(context: context)
            humanTest.firstName = "Yannis"
            humanTest.lastName = "Lang"
        }
    }
}
