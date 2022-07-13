//
//  Chat.swift
//  ChatPageUI
//
//  Created by Jinyung Yoon on 2022/07/11.
//

import Foundation
import UIKit

struct Chat {
    
    enum Sender {
        case coach
        case member
    }
    
    var sender: Sender
    var time: String
    var message: String?
    var image: UIImage?
    
    init(sender: Sender, time: String, message: String? = nil, image: UIImage? = nil) {
        self.sender = sender
        self.time = time
        self.message = message
        self.image = image
    }
}

struct ChatLogParser {
    let code, rplAbl: String?
    let prfImg: String?
}


struct List: Codable {
    let boardSeq, boardParentSeq: Int?
    
}
