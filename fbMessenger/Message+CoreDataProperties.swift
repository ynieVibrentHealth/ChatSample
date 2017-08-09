//
//  Message+CoreDataProperties.swift
//  fbMessenger
//
//  Created by Brian Voong on 4/19/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import IGListKit

extension Message {

    @NSManaged var date: Date?
    @NSManaged var text: String?
    @NSManaged var isSender: NSNumber?
    @NSManaged var friend: Friend?

}

extension Message: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let msg = object as? Message else {return false}
        if msg.friend == self.friend && msg.text == self.text && msg.date == msg.date {
            return true
        } else {
            return false
        }
    }
}
