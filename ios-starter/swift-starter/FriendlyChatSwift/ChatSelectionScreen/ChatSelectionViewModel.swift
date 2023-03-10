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
    private let userRepository: UsersRepository
    public var chat: BehaviorRelay<[[String : Any]]> = BehaviorRelay(value: [])
    public var user: PublishSubject<AppUser?> = PublishSubject<AppUser?>()

    init(navigator: ChatNavigatorProtocol) {
        self.navigator = navigator
        self.repository = ChatRoomsRepository()
        self.userRepository = UsersRepository()
    }
    
    func transform(input: ChatSelectionTypeInput) -> ChatSelectionTypeOutput {
        
        var data: AppUser? = nil
        
        self.userRepository
            .getUser()
            .do(onNext: { user in
                if let info = user {
//                    data[Constants.MessageFields.name] = info[Constants.MessageFields.name] as! String
//                    data[Constants.MessageFields.photoURL] = info[Constants.MessageFields.photoURL] as? String
                    data = info
                    self.user.onNext(info)
                }
            })
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: self.disposeBag)
        
        let triggered = input.trigger
                .do(onNext: {
                    self.repository.chatRooms
                        .bind(to: self.chat)
                        .disposed(by: self.disposeBag)
                    
                    self.user.onNext(data)
                })
                .mapToVoid()
        
        let buttonActionTapped =
                input.selectionTrigger
                .do(onNext:{ index in
                    print("buttonActionTapped \(index) \(self.chat.value[index])")
                    self.navigator.goToChat(id: self.chat.value[index]["id"] as! String, chatTitle: "\(self.chat.value[index]["name"] ?? "")")
                })
                .mapToVoid()
                .asDriver()
                    
        let userEditTriggered = input.userEditTrigger
                .skip(1)
                .do(onNext: { index in
                    self.navigator.goToUser()
                })
                .mapToVoid()
                .asDriver()
                        
        return Output(triggered: triggered,
                      user: self.user.asDriverOnErrorJustComplete(),
                      userEditTriggered: userEditTriggered,
                      selectionTriggered: buttonActionTapped,
                      error: self.errorTracker.asDriverOnErrorJustComplete())
    }
}
