//
//  ChatMessage.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 09/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    var id: String
    var name: String?
    var photoURL: String?
    var imageURL: String?
    var text: String?
    var timestamp: Date
    var user_id: String
    var isMine: Bool = false
}
