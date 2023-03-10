//
//  ChatRoom.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 09/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation

struct ChatRoom: Identifiable, Codable {
    var id: String
    var isPublic: Bool
    var active_users: String?
}
