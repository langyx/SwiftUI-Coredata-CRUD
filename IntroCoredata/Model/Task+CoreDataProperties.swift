//
//  Task+CoreDataProperties.swift
//  IntroCoredata
//
//  Created by Yannis Lang on 15/05/2020.
//  Copyright © 2020 Yannis Lang. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {
    
    @NSManaged public var name: String?
    @NSManaged public var done: Bool

}
