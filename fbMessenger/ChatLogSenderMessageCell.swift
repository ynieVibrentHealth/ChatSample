//
//  ChatLogSenderMessageCell.swift
//  fbMessenger
//
//  Created by Yuchen Nie on 8/8/17.
//  Copyright © 2017 letsbuildthatapp. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CommunicatorProviderTextCell: UICollectionViewCell {
    let InsetConstant:CGFloat = 5
    let imageSize:CGFloat = 30
    static let reuseId = "ChatLogSenderMessageCell"
    
    private lazy var textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        self.contentView.addSubview(view)
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = self.imageSize/2
        imageView.layer.masksToBounds = true
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.dataDetectorTypes = UIDataDetectorTypes.phoneNumber
        textView.text = "True freshman year"
        textView.font = UIFont.systemFont(ofSize: 13.0)
        textView.textColor = UIColor.white
        textView.isScrollEnabled = false
        self.textBubbleView.addSubview(textView)
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        self.textBubbleView.addSubview(imageView)
        return imageView
    }()
    
    func configure(message: CommunicatorTextModel) {
        if let profileImageName = message.senderProfileImage {
            self.profileImageView.image = UIImage(named: profileImageName)
        }
        
        bubbleImageView.image = ChatModel.Images.GRAY_BUBBLE_IMAGE
        messageTextView.text = message.text
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        profileImageView.snp.updateConstraints { (make) in
            make.leading.equalTo(self.contentView).inset(8)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(imageSize)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        messageTextView.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.textBubbleView)
            make.trailing.equalTo(self.textBubbleView).inset(8)
            make.leading.equalTo(self.textBubbleView).inset(20)
            make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.67)
        }
        
        bubbleImageView.snp.updateConstraints { (make) in
            make.top.bottom.equalTo(self.textBubbleView)
            make.leading.trailing.equalTo(self.textBubbleView).offset(0)
        }
        
        textBubbleView.snp.updateConstraints { (make) in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.top.bottom.equalTo(self.contentView)
        }
        
        
        super.updateConstraints()
    }
}
