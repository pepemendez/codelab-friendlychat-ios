//
//  ChatRepository.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 09/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation
import FirebaseFirestore
import RxSwift
import RxCocoa

class ChatRoomsRepository {
    let db = Firestore.firestore()
    private var ref: CollectionReference!
    public var chatRooms: BehaviorRelay<[[String : Any]]> = BehaviorRelay(value: [])
    
    init(){
        self.configureDatabase()
    }

    func configureDatabase() {
        Firestore.firestore().clearPersistence()
        ref = Firestore.firestore().collection("chatlobbies")
        ref.addSnapshotListener({ [weak self] (snapshot, error) in
            guard let snapshot = snapshot else {
              print("Error fetching snapshot results: \(error!)")
              return
            }
            
            // Listen for new messages in the Firebase database
            let _ = snapshot.documentChanges.map { (document) in
                if(document.type == .added){
                    
                    self?.ref.document(document.document.documentID).collection("users").document("userList")
                        .addSnapshotListener({
                            [weak self] (snapshot, error) in
                            guard let strongSelf = self else { return }

                            guard let snapshot = snapshot else {
                              print("Error fetching snapshot results: \(error!)")
                              return
                            }
                            
                            var dictionary: [String: Any] =
                            ["name": document.document.documentID]
                            dictionary["isPublic"] = true
                            dictionary["id"] = document.document.data()["id"]
                            if let active_users = (snapshot.data()?["users"] as? NSArray)?.count {
                                dictionary["active_users"] = "\(active_users) usuarios activos"
                            }
                            else{
                                dictionary["active_users"] = "Público"
                            }
                            print(document.document.data())
                            print(snapshot.data())
                            
                            var newMessages = strongSelf.chatRooms.value
                            newMessages.append(dictionary)
                            strongSelf.chatRooms.accept(newMessages)
                        })
                }
            }
          })
    }
    
}
