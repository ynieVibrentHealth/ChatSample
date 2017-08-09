//
//  ChatContainerController.swift
//  fbMessenger
//
//  Created by Yuchen Nie on 8/9/17.
//  Copyright © 2017 letsbuildthatapp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ChatContainerController:UIViewController {
    public var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            
        }
    }
    
    private lazy var chatController:ChatLogController = {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController()
        controller.friend = self.friend
        self.scrollContainer.addSubview(controller.view)
        return controller
    }()
    
    private lazy var scrollContainer:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var toolBar:UIToolbar = {
        let toolBar = UIToolbar()
        
        self.scrollContainer.addSubview(toolBar)
        return toolBar
    }()
    
    private lazy var textField:UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
    }
    
    override func updateViewConstraints() {
        scrollContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        toolBar.snp.updateConstraints { (make) in
            make.bottom.leading.trailing.equalTo(self.scrollContainer)
            make.height.equalTo(40)
        }
        
        chatController.view.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalTo(self.scrollContainer)
            make.bottom.equalTo(self.toolBar.snp.top)
        }
        
        super.updateViewConstraints()
    }
}
