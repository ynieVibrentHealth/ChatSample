//
//  CommunicatorChatController.swift
//  fbMessenger
//
//  Created by Yuchen Nie on 8/9/17.
//  Copyright © 2017 letsbuildthatapp. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit

class CommunicatorChatController:UIViewController {
    public var messages:[ListDiffable] = [ListDiffable]()
    
    fileprivate lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
}

extension CommunicatorChatController: ListAdapterDataSource {
    /**
     Asks the data source for the objects to display in the list.
     
     @param listAdapter The list adapter requesting this information.
     
     @return An array of objects for the list.
     */
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.messages
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let message = object as? Message {
            
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

    
}
