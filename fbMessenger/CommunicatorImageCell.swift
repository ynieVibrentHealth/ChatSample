//
//  CommunicatorImageCell.swift
//  Acadia
//
//  Created by Yuchen Nie on 8/7/17.
//  Copyright © 2017 Vibrent. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import IGListKit
import Kingfisher

class CommunicatorImageCell:UICollectionViewCell {
    private lazy var imageContainer:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.contentView.addSubview(view)
        return view
    }()
    
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        self.imageContainer.addSubview(imageView)
        return imageView
    }()
    
    public func configure(model:CommunicatorImageModel) {
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        imageContainer.snp.updateConstraints { (make) in
            make.leading.equalTo(self.contentView).inset(5)
            make.top.bottom.equalTo(self.contentView).inset(10)
            make.width.equalTo(self.contentView).multipliedBy(0.45)
            make.height.equalTo(imageContainer.snp.width)
        }
        
        imageView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.imageContainer)
        }
        
        super.updateConstraints()
    }
}
