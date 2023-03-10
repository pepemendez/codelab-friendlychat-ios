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
}

struct UserScreenTypeOutput {
    let triggered: Driver<Void>
    let imageTrigerred: Driver<Void>
    let imageFetchedTrigerred: Driver<UIImage?>
    let user: Driver<[String: String]>
    let error: Driver<String>?
}
