//
//  ChatLogSelfMessageCell.swift
//  fbMessenger
//
//  Created by Yuchen Nie on 8/8/17.
//  Copyright © 2017 letsbuildthatapp. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class CommunicatorSelfTextCell: UICollectionViewCell {
    let InsetConstant:CGFloat = 5
    static let reuseId = "ChatLogSelfMessageCell"
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.dataDetectorTypes = UIDataDetectorTypes.phoneNumber
        textView.text = "True freshman year"
        textView.font = UIFont.systemFont(ofSize: 13.0)
        textView.textColor = UIColor.black
        textView.isScrollEnabled = false
        self.textBubbleView.addSubview(textView)
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    private lazy var textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        self.contentView.addSubview(view)
        return view
    }()
    
    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        self.textBubbleView.addSubview(imageView)
        return imageView
    }()
    
    func configure(with message:CommunicatorTextModel) {
        bubbleImageView.image = ChatModel.Images.BLUE_BUBBLE_IMAGE
        messageTextView.text = message.text
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        messageTextView.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.textBubbleView)
            make.trailing.equalTo(self.textBubbleView).inset(17)
            make.leading.equalTo(self.textBubbleView).inset(10)
            make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.67)
        }
        
        bubbleImageView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.textBubbleView)
        }
        
        textBubbleView.snp.updateConstraints { (make) in
            make.trailing.equalTo(self.contentView).inset(10)
            make.top.bottom.equalTo(self.contentView)
        }
        super.updateConstraints()
    }
}
