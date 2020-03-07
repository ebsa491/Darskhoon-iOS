//
//  Person+CoreDataProperties.swift
//  Darskhoon
//
//  Created by Saman on 3/19/18.
//  GNU General Public License (GPL) v3.0.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var password: String?
    @NSManaged var username: String?

}
