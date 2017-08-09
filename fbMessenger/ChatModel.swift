//
//  ChatModel.swift
//  fbMessenger
//
//  Created by Yuchen Nie on 8/8/17.
//  Copyright © 2017 letsbuildthatapp. All rights reserved.
//

import Foundation
import UIKit

struct ChatModel {
    struct Images {
        static let GRAY_BUBBLE_IMAGE = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
        static let BLUE_BUBBLE_IMAGE = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    }
}
