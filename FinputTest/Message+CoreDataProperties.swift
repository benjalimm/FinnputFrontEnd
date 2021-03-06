//
//  Message+CoreDataProperties.swift
//  FinputTest
//
//  Created by Benjamin Lim on 25/07/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var text: String?
    @NSManaged var date: NSDate?
    @NSManaged var isSender: NSNumber?

}
