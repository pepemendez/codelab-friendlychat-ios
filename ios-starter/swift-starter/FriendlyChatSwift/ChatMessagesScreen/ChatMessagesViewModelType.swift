//
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

struct ChatMessagesTypeInput {
    let trigger: Driver<Void>
    let sendTrigger: Driver<Void>
    let photoTrigger: Driver<Void>
    let messageTrigger: Driver<String>
}

struct ChatMessagesTypeOutput {
    let triggered: Driver<Void>
    let sendTriggered: Driver<Void>
    let photoTriggered: Driver<Void>
    let messageTriggered: Driver<Void>
    let error: Driver<String>?
}
