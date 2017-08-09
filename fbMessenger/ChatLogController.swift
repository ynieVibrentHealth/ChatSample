//
//  ChatLogController.swift
//  fbMessenger
//
//  Created by Brian Voong on 4/8/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import SnapKit

class ChatLogController: UIViewController {
    
    fileprivate lazy var chatController:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ChatLogSelfMessageCell.self, forCellWithReuseIdentifier: ChatLogSelfMessageCell.reuseId)
        collectionView.register(ChatLogSenderMessageCell.self, forCellWithReuseIdentifier: ChatLogSenderMessageCell.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.contentView.addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var contentView:UIView = {
        let view = UIView()
        self.scrollContainer.addSubview(view)
        return view
    }()
    
    private lazy var scrollContainer:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var toolBar:UIToolbar = {
        let toolBar = UIToolbar()
        
        self.contentView.addSubview(toolBar)
        return toolBar
    }()
    
    private lazy var textField:UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    var friend: Friend? {
        didSet {
            messages = friend?.messages?.allObjects as? [Message]
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        }
    }
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
    }
    
    override func updateViewConstraints() {
        scrollContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        contentView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        toolBar.snp.updateConstraints { (make) in
            make.bottom.leading.trailing.equalTo(self.contentView)
            make.height.equalTo(44)
        }
        
        chatController.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalTo(self.contentView)
            //make.bottom.equalTo(self.contentView)
            make.bottom.equalTo(self.toolBar.snp.top)
        }
        
        super.updateViewConstraints()
    }
    
}

extension ChatLogController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let message = messages?[indexPath.item] {
            
            if message.isSender == nil || !message.isSender!.boolValue {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLogSenderMessageCell.reuseId, for: indexPath) as! ChatLogSenderMessageCell
                cell.configure(message: message)
                return cell
            } else {
                //outgoing sending message
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLogSelfMessageCell.reuseId, for: indexPath) as! ChatLogSelfMessageCell
                cell.configure(with: message)
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            let size = CGSize(width: view.frame.width * 0.6, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
}
