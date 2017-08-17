//
//  CommunicatorImageModel.swift
//  Acadia
//
//  Created by Yuchen Nie on 8/7/17.
//  Copyright © 2017 Vibrent. All rights reserved.
//

import Foundation
import IGListKit

class CommunicatorImageModel: NSObject, ListDiffable {
    var id:String
    var thumbnailImage:String
    var fullSizeImage:String
    var sender:String?
    var senderId:String?
    var senderProfileImage:String?
    
    init(id:String, thumbnailImage:String, fullSizeImage:String, sender:String, senderId:String, senderProfileImage:String?) {
        self.id = id
        self.sender = sender
        self.senderId = senderId
        
        self.thumbnailImage = thumbnailImage
        self.fullSizeImage = fullSizeImage
        
        self.senderProfileImage = senderProfileImage
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let imgModel = object as? CommunicatorImageModel else {return false}
        return imgModel.id == self.id ? true : false
    }
}
