//
//  Human+CoreDataProperties.swift
//  IntroCoredata
//
//  Created by Yannis Lang on 29/04/2020.
//  Copyright © 2020 Yannis Lang. All rights reserved.
//
//

import Foundation
import CoreData


extension Human {
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String

    var fullName : String {
        "\(firstName) \(lastName)"
    }
    
}
