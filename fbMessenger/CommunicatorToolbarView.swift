//
//  CommunicatorToolbarView.swift
//  fbMessenger
//
//  Created by Yuchen Nie on 8/9/17.
//  Copyright © 2017 letsbuildthatapp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol CommunicatorToolbarDelegate {
    func submitPressed(messageText:String)
}

class CommunicatorToolbarView:UIView {
    fileprivate var delegate:CommunicatorToolbarDelegate?
    
    fileprivate lazy var inputTextView:UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = true;
        textView.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(textView)
        return textView
    }()
    
    fileprivate lazy var submitButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = true;
        button.setTitle("Send", for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(CommunicatorToolbarView.submitPressed), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    public func configure(delegate:UITextViewDelegate, toolbarDelegate:CommunicatorToolbarDelegate) {
        self.backgroundColor = UIColor.lightGray
        inputTextView.delegate = delegate
        self.delegate = toolbarDelegate
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        inputTextView.snp.updateConstraints { (make) in
            make.leading.top.bottom.equalTo(self).inset(3)
            make.trailing.equalTo(self.submitButton.snp.leading).offset(-3)
        }
        
        submitButton.snp.updateConstraints { (make) in
            make.trailing.bottom.equalTo(self).inset(3)
            make.width.equalTo(55)
        }
        
        super.updateConstraints()
    }
    
}

extension CommunicatorToolbarView {
    @objc fileprivate func submitPressed() {
        inputTextView.resignFirstResponder()
        delegate?.submitPressed(messageText: inputTextView.text)
    }
    
    public func clearText() {
        inputTextView.text = ""
    }
}
