//
//  ChatLogController.swift
//  fbMessenger
//
//  Created by Brian Voong on 4/8/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class ChatLogController: UIViewController {
    
    fileprivate lazy var chatController:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
//        collectionView.register(ChatLogSelfMessageCell.self, forCellWithReuseIdentifier: ChatLogSelfMessageCell.reuseId)
//        collectionView.register(ChatLogSenderMessageCell.self, forCellWithReuseIdentifier: ChatLogSenderMessageCell.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.contentView.addSubview(collectionView)
        return collectionView
    }()
    
    fileprivate lazy var contentView:UIView = {
        let view = UIView()
        self.scrollContainer.addSubview(view)
        return view
    }()
    
    fileprivate lazy var scrollContainer:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        return scrollView
    }()

    fileprivate lazy var toolbar:CommunicatorToolbarView = {
        let toolbar = CommunicatorToolbarView()
        toolbar.configure(delegate: self, toolbarDelegate: self)
        self.view.addSubview(toolbar)
        return toolbar
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatLogController.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatLogController.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
    }
    
    override func updateViewConstraints() {
        scrollContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        contentView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        toolbar.snp.updateConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.contentView)
            make.height.greaterThanOrEqualTo(44)
        }
        
        chatController.snp.updateConstraints { (make) in
            make.top.leading.trailing.equalTo(self.contentView)
            make.bottom.equalTo(self.toolbar.snp.top)
        }
        
        super.updateViewConstraints()
    }
    
    fileprivate func scrollToBottom() {
        if let messages = messages {
            let lastItemIndex = IndexPath(item: messages.count - 1, section: 0)
            chatController.scrollToItem(at: lastItemIndex, at: .bottom, animated: true)
        }
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
        
//        if let message = messages?[indexPath.item] {
//            
//            if message.isSender == nil || !message.isSender!.boolValue {
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLogSenderMessageCell.reuseId, for: indexPath) as! ChatLogSenderMessageCell
//                cell.configure(message: message)
//                return cell
//            } else {
//                //outgoing sending message
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLogSelfMessageCell.reuseId, for: indexPath) as! ChatLogSelfMessageCell
//                cell.configure(with: message)
//                return cell
//            }
//        }
        
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

extension ChatLogController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        self.contentView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view).inset(keyboardFrame.size.height)
        }
        
        UIView.animate(withDuration: 0.4, animations: { 
            self.view.layoutIfNeeded()
        }) { [weak self] (finished) in
            guard let _self = self else {return}
            _self.scrollToBottom()
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        self.contentView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view)
        }
        UIView.animate(withDuration: 0.4) { 
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatLogController: CommunicatorToolbarDelegate {
    func submitPressed(messageText:String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate

        guard let friend = messages?.first?.friend,
        let context = delegate?.managedObjectContext else {return}
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = messageText
        message.date = Date()
        message.isSender = NSNumber(value: true as Bool)
        
        messages?.append(message)
        let indexPath = IndexPath(item: (messages?.count)!-1, section: 0)
        let indexPaths = [indexPath]
        chatController.insertItems(at: indexPaths)
        scrollToBottom()
        toolbar.clearText()
    }
}
