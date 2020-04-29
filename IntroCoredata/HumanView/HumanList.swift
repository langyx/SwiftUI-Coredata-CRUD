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
                ForEach(self.humans, id: \.self) { oneHuman in
                    HStack{
                        Text("\(oneHuman.firstName) \(oneHuman.lastName)")
                        Spacer()
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 20))
                            .onTapGesture {
                                self.showEditView.toggle()
                        }
                        
                    }.sheet(isPresented: self.$showEditView, content: {
                        HumanAdd(edit: oneHuman)
                    })
                }
                .onDelete(perform: { offsets in
                    for offset in offsets {
                        let humanDeleted = self.humans[offset]
                        
                        self.managedObjectContext.delete(humanDeleted)
                        try? self.managedObjectContext.save()
                    }
                })
            }
            .sheet(isPresented: $showAddView, content: {
                HumanAdd().environment(\.managedObjectContext, self.managedObjectContext)
            })
            .navigationBarItems(trailing: Button(action: {
                self.showAddView.toggle()
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 20))
            }))
                .navigationBarTitle("Humans")
        }
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
