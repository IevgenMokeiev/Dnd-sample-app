//
//  Spell+CoreDataProperties.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/18/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//
//

import Foundation
import CoreData

extension Spell {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Spell> {
        return NSFetchRequest<Spell>(entityName: "Spell")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var higherlevel: String?
    @NSManaged public var range: String?
    @NSManaged public var components: String?
    @NSManaged public var classes: NSData?
    @NSManaged public var subclasses: NSData?
    @NSManaged public var page: String?
    @NSManaged public var material: String?
    @NSManaged public var ritual: Bool
    @NSManaged public var duration: String?
    @NSManaged public var concentration: Bool
    @NSManaged public var casting_time: String?
    @NSManaged public var level: Int16
    @NSManaged public var school: String?

}
