//
//  HumanRow.swift
//  IntroCoredata
//
//  Created by Yannis Lang on 11/03/2021.
//  Copyright © 2021 Yannis Lang. All rights reserved.
//

import SwiftUI

struct HumanRow: View {
    let human: Human
    var body: some View {
        HStack{
            Text("\(human.fullName)")
            Spacer()
            Image(systemName: "pencil.circle")
                .font(.system(size: 20))
        }
    }
}

struct HumanRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let human = Human(context: context)
        human.firstName = "Yannis"
        human.lastName = "Toto"
        
        return HumanRow(human: human)
    }
}
