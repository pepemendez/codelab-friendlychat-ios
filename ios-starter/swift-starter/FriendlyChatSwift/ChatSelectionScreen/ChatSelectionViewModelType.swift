//
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

struct ChatSelectionTypeInput {
    let trigger: Driver<Void>
    let selectionTrigger: Driver<Int>
    let userEditTrigger: Driver<Void>
}

struct ChatSelectionTypeOutput {
    let triggered: Driver<Void>
    let user: Driver<AppUser?>
    let userEditTriggered: Driver<Void>
    let selectionTriggered: Driver<Void>
    let error: Driver<String>?
}
