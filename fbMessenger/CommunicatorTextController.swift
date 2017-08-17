//
//  CommunicatorTextSectionController.swift
//  Acadia
//
//  Created by Yuchen Nie on 8/2/17.
//  Copyright © 2017 Vibrent. All rights reserved.
//

import UIKit
import IGListKit

class CommunicatorTextSectionController: ListSectionController {
    private var textModel: CommunicatorTextModel?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width,
            let messageText = textModel?.text else { return .zero }
        
        let size = CGSize(width: width * 0.67, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options,
                                                                        attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)],
                                                                        context: nil)
        
        return CGSize(width: width, height: estimatedFrame.height + 20)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if textModel?.sender == nil {
            guard let selfCell = collectionContext?.dequeueReusableCell(of: CommunicatorSelfTextCell.self,
                                                                        for: self,
                                                                        at: index) as? CommunicatorSelfTextCell else {
                                                                            return UICollectionViewCell()}
            selfCell.configure(with: textModel!)
            return selfCell
        } else {
            guard let providerCell = collectionContext?.dequeueReusableCell(of: CommunicatorProviderTextCell.self,
                                                                            for: self,
                                                                            at: index) as? CommunicatorProviderTextCell else {
                                                                                return UICollectionViewCell()}
            providerCell.configure(message: textModel!)
            return providerCell
        }
    }
    
    override func didUpdate(to object: Any) {
        guard let textObject = object as? CommunicatorTextModel else {return}
        self.textModel = textObject
    }
}
