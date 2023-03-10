//
//  AppUser.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 09/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation

struct AppUser: Identifiable, Codable {
    var id: String
    var name: String?
    var photoURL: String?
    var user_id: String
}
