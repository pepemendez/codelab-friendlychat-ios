//
//  LoginNavigatorProtocol.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation

protocol ChatNavigatorProtocol {
    func goToChat(id: String, chatTitle: String)
    func goToUser()
    func Error()
    func logOut()
}
