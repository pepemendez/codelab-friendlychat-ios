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

class ChatMessagesViewModel: ViewModelType{
    typealias Input = ChatMessagesTypeInput
    
    typealias Output = ChatMessagesTypeOutput
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let errorTracker: PublishSubject<String> = PublishSubject<String>()
    private let navigator: ChatNavigatorProtocol
    private let repository: ChatMessagesRepository
    private let chatId: String
    private var chatMessage: String = ""
    
    public var messages: BehaviorRelay<[ChatMessage]> = BehaviorRelay(value: [])

    init(navigator: ChatNavigatorProtocol, chatId: String) {
        self.chatId = chatId
        self.navigator = navigator
        self.repository = ChatMessagesRepository()
    }
    
    func transform(input: ChatMessagesTypeInput) -> ChatMessagesTypeOutput {
        let triggered = input.trigger
                .map{
                    self.repository
                        .getMessages(byRoomId: self.chatId)
                        .do(onNext: { message in
                            self.messages.accept(message)
                        })
                        .asObservable()
                        .asDriverOnErrorJustComplete()
                        .drive()
                        .disposed(by: self.disposeBag)
                }
                .mapToVoid()
                
        let sendTriggered =    input
            .sendTrigger
            .do(onNext:{
                print("sendTriggered")
                let data = [Constants.MessageFields.text:self.chatMessage]

                self.repository
                    .setMesssage(toRoomId: self.chatId, withData: data)
            })
            .asDriver()
                
        let photoTriggered = input
            .photoTrigger
            .do(onNext:{
                print("photoTrigger")
            })
            .asDriver()
                    
        let messageTriggered =  input
            .messageTrigger
            .do(onNext:{ msg in
                print("messageTrigger \(msg)")
                self.chatMessage = msg
            })
            .mapToVoid()
            .asDriver()
                    
                    
            return Output(triggered: triggered,
                  sendTriggered: sendTriggered,
                  photoTriggered: photoTriggered,
                  messageTriggered: messageTriggered,
                  error: self.errorTracker.asDriverOnErrorJustComplete())
    }
}
