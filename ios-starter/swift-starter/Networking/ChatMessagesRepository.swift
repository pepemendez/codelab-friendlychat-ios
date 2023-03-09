//
//  ChatRepository.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 09/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import RxSwift
import RxCocoa

class ChatMessagesRepository {
    let db = Firestore.firestore()
    private var ref: CollectionReference!
    private var messages: PublishSubject<[String : Any]> = PublishSubject<[String : Any]>()
    
    init(){
    }
    
    func getMessages(byRoomId room: String) -> Observable<[String: Any]>{
        db.clearPersistence()
        ref = db.collection("messages").document(room).collection("messages")
        ref.addSnapshotListener({ [weak self] (snapshot, error) in
            guard let strongSelf = self else { return }

            guard let snapshot = snapshot else {
              print("Error fetching snapshot results: \(error!)")
              return
            }
            
            let _ = snapshot.documentChanges.map { (document) in
                if(document.type == .added){
                    strongSelf.messages.onNext(document.document.data())
                }
            }
          })
        
        return messages;
    }
    
    func setMesssage(toRoomId room: String, withData data: [String: String]){
        var mdata = data
        mdata[Constants.MessageFields.name] = Auth.auth().currentUser?.displayName
        if let photoURL = Auth.auth().currentUser?.photoURL {
          mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
        }

        self.ref.addDocument(data: mdata)
    }
    
}
