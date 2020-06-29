//
//  Archieved+CoreDataProperties.swift
//  todo_ram_c0779370
//
//  Created by rschakar on 6/28/20.
//  Copyright © 2020 ram. All rights reserved.
//
//

import Foundation
import CoreData


extension Archieved {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Archieved> {
        return NSFetchRequest<Archieved>(entityName: "Archieved")
    }

    @NSManaged public var name: String?

}
