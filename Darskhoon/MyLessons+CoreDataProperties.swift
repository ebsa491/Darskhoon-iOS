//
//  MyLessons+CoreDataProperties.swift
//  Darskhoon
//
//  Created by Saman on 4/2/18.
//  GNU General Public License (GPL) v3.0.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MyLessons {

    @NSManaged var desc: String?
    @NSManaged var id: String?
    @NSManaged var image: String?
    @NSManaged var teacher: String?
    @NSManaged var time: String?
    @NSManaged var title: String?
    @NSManaged var video: String?

}
