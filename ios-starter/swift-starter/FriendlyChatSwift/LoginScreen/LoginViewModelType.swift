//
//  LoginViewModelType.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

struct LoginTypeInput {
    let trigger: Driver<Void>
    let btnActionTap: Driver<UIViewController>
}

struct LoginTypeOutput {
    let triggered: Driver<Void>
    let logged: Driver<Void>
    let btnActionTapped: Driver<Void>
    let error: Driver<String>?
}
