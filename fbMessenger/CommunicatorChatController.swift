//
//  CommunicatorViewController.swift
//  Acadia
//
//  Created by Yuchen Nie on 8/2/17.
//  Copyright © 2017 Vibrent. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

protocol CommunicatorChatViewControllerInput {
}

class CommunicatorChatViewController: UIViewController, CommunicatorChatViewControllerInput {
    fileprivate var items:[ListDiffable] = [ListDiffable]()
    
    fileprivate lazy var chatController:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CommunicatorProviderTextCell.self, forCellWithReuseIdentifier: CommunicatorProviderTextCell.reuseId)
        collectionView.register(CommunicatorSelfTextCell.self, forCellWithReuseIdentifier: CommunicatorSelfTextCell.reuseId)
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
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapter.collectionView = self.chatController
        adapter.dataSource = self
        return adapter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(CommunicatorChatViewController.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommunicatorChatViewController.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        guard let lastItem = items.last else {return}
        adapter.scroll(to: lastItem, supplementaryKinds: nil, scrollDirection: .vertical, scrollPosition: UICollectionViewScrollPosition.top, animated: true)
        
    }
}

extension CommunicatorChatViewController : ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is CommunicatorTextModel:
            return CommunicatorTextSectionController()
        default:
            return CommunicatorImageSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension CommunicatorChatViewController: UITextViewDelegate {
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

extension CommunicatorChatViewController: CommunicatorToolbarDelegate {
    func submitPressed(messageText:String) {
        
        scrollToBottom()
        toolbar.clearText()
    }
}
