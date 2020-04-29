//
//  HumanAdd.swift
//  IntroCoredata
//
//  Created by Yannis Lang on 29/04/2020.
//  Copyright © 2020 Yannis Lang. All rights reserved.
//

import SwiftUI

struct HumanAdd: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    
    @State private var newFirstName: String = ""
    @State private var newLastName: String = ""
    
    @State private var stateMsg = ""
    
    private var human: Human?
    
    init(edit human: Human? = nil) {
        self.human = human
        
        if let human = self.human {
            self._newLastName = State(initialValue: human.lastName)
            self._newFirstName = State(initialValue: human.firstName)
        }
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("FirstName", text: $newFirstName)
                    TextField("LastName", text: $newLastName)
                }
                
                
                Section(footer: Text(self.stateMsg), content: {
                    Group{
                        Button(action: {
                        self.stateMsg = ""
                        
                        if self.newFirstName.isEmpty || self.newLastName.isEmpty {
                            self.stateMsg = "Veuillez remplir tous les champs"
                        }else{
                            if let editedHuman = self.human {
                                editedHuman.firstName = self.newFirstName
                                editedHuman.lastName = self.newLastName
                            }else{
                                let newHuman = Human.init(context: self.managedObjectContext)
                                newHuman.firstName = self.newFirstName
                                newHuman.lastName = self.newLastName
                            }
                            
                            
                            do {
                                try self.managedObjectContext.save()
                            }catch{
                                print(error)
                            }
                            
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text(self.human != nil ? "Modifier" : "Valider")
                    })
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Annuler")
                                .foregroundColor(.red)
                        })
                    }
                })
            }
            .navigationBarTitle(self.human != nil ? "Modifier \(self.human!.firstName)" : "Ajouter un human")
        }
    }
}

struct HumanAdd_Previews: PreviewProvider {
    static var previews: some View {
        HumanAdd()
    }
}
