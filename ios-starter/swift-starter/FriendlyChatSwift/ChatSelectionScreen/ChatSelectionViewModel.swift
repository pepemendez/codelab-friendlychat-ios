//
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleSignIn
import Firebase
import FirebaseFirestore

class ChatSelectionViewModel: ViewModelType{
    typealias Input = ChatSelectionTypeInput
    
    typealias Output = ChatSelectionTypeOutput
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let errorTracker: PublishSubject<String> = PublishSubject<String>()
    private let navigator: ChatNavigatorProtocol
    private let repository: ChatRoomsRepository
    
    public var chat: BehaviorRelay<[[String : Any]]> = BehaviorRelay(value: [])

    init(navigator: ChatNavigatorProtocol) {
        self.navigator = navigator
        self.repository = ChatRoomsRepository()
    }
    
    func transform(input: ChatSelectionTypeInput) -> ChatSelectionTypeOutput {
        let triggered = input.trigger
                .map{
                    self.repository.chatRooms
                        .bind(to: self.chat)
                        .disposed(by: self.disposeBag)
                }
                .mapToVoid()
        
        let buttonActionTapped =
                input.selectionTrigger
                .do(onNext:{ index in
                    print("buttonActionTapped \(index) \(self.chat.value[index])")
                    self.navigator.goToChat(id: self.chat.value[index]["id"] as! String)
                })
                .mapToVoid()
                .asDriver()
                    
                return Output(triggered: triggered,
                              selectionTriggered: buttonActionTapped,
                              error: self.errorTracker.asDriverOnErrorJustComplete())
    }
}
