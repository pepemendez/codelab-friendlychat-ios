//
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

struct UserScreenTypeInput {
    let trigger: Driver<Void>
    let imageTrigger: Driver<UIViewController>
    let imageFetched: Driver<[UIImagePickerController.InfoKey : Any]>
    let nameTrigger: Driver<String?>
    let closeTrigger: Driver<Void>
}

struct UserScreenTypeOutput {
    let triggered: Driver<Void>
    let imageTrigerred: Driver<Void>
    let imageFetchedTrigerred: Driver<UIImage?>
    let nameTriggered: Driver<Void>
    let user: Driver<AppUser?>
    let closeTriggered: Driver<Void>
    let error: Driver<String>?
}
