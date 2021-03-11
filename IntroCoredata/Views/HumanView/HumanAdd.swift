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
                
                Section(footer: Text(stateMsg), content: {
                    actionSection
                })
            }
            .navigationBarTitle(human != nil ? "Modifier \(human!.firstName)" : "Ajouter un human")
        }
    }
}

extension HumanAdd {
    private func add(human: Human) {
        human.firstName = newFirstName
        human.lastName =  newLastName
        
        do {
            try managedObjectContext.save()
        }catch{
            print(error)
        }
    }
    
    private func hide() {
        presentationMode.wrappedValue.dismiss()
    }
}

extension HumanAdd {
    private var actionSection: some View {
        Group{
            Button(action: {
                stateMsg = ""
                
                if newFirstName.isEmpty || newLastName.isEmpty {
                    self.stateMsg = "Veuillez remplir tous les champs"
                }else{
                    var editedHuman: Human
                    if let human = human {
                        editedHuman = human
                    }else{
                        editedHuman = Human.init(context: managedObjectContext)
                    }
                    add(human: editedHuman)
                    
                    hide()
                }
            }, label: {
                Text(human != nil ? "Modifier" : "Valider")
            })
            Button(action: hide, label: {
                Text("Annuler")
                    .foregroundColor(.red)
            })
        }
    }
}

struct HumanAdd_Previews: PreviewProvider {
    static var previews: some View {
        HumanAdd()
    }
}
