//
//  CommunicatorTextModel.swift
//  Acadia
//
//  Created by Yuchen Nie on 8/7/17.
//  Copyright © 2017 Vibrent. All rights reserved.
//

import Foundation
import IGListKit

class CommunicatorTextModel: NSObject, ListDiffable {
    var id:String
    var text:String
    var sender:String?
    var senderId:String?
    var senderProfileImage:String?
    
    init(id:String, text:String, sender:String?, senderId:String?, senderProfileImage:String?) {
        self.id = id
        self.sender = sender
        self.senderId = senderId
        self.text = text
        self.senderProfileImage = senderProfileImage
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let textModel = object as? CommunicatorTextModel else {return false}
        return textModel.id == self.id ? true : false
    }
}
