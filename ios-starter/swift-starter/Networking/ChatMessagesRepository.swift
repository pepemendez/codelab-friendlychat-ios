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
    private var messages: PublishSubject<[ChatMessage]> = PublishSubject<[ChatMessage]>()
    
    init(){
    }
    
    func getMessages(byRoomId room: String) -> Observable<[ChatMessage]>{
        ref = db.collection("messages").document(room).collection("messages")
        
        let preferences = UserDefaults.standard

        let currentLevelKey = "user_id"
        var currentLevel = ""

        if preferences.object(forKey: currentLevelKey) == nil {
            //  Doesn't exist
        } else {
            currentLevel = preferences.string(forKey: currentLevelKey)!
        }
        
        ref.addSnapshotListener({ [weak self] (snapshot, error) in
            guard let strongSelf = self else { return }

            guard let snapshot = snapshot else {
              print("Error fetching snapshot results: \(error!)")
              return
            }
            
            var mapped = snapshot.documents.compactMap { document -> ChatMessage? in
                do{
                    let timestamp = Date(timeIntervalSince1970: Double((document.data()[Constants.MessageFields.timestamp] as? String) ?? "0")!)
                    let user_id = (document.data()[Constants.MessageFields.id] as? String)
                    return ChatMessage(id: "\(UUID())",
                                       name: document.data()[Constants.MessageFields.name] as? String,
                                       photoURL: document.data()[Constants.MessageFields.photoURL] as? String,
                                       imageURL: document.data()[Constants.MessageFields.imageURL] as? String,
                                       text: document.data()[Constants.MessageFields.text] as? String,
                                       timestamp: timestamp,
                                       user_id: document.data()[Constants.MessageFields.id] as! String,
                                       isMine: currentLevel == (document.data()[Constants.MessageFields.id] as! String))
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }
            
            mapped.sort{ $0.timestamp < $1.timestamp }
            
            strongSelf.messages.onNext(mapped)
          })
        
        return messages;
    }
    
    func setMesssage(toRoomId room: String, withData data: [String: String]){
        var mdata = data
        mdata[Constants.MessageFields.name] = Auth.auth().currentUser?.displayName
        if let photoURL = Auth.auth().currentUser?.photoURL {
          mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
        }
        
        let preferences = UserDefaults.standard

        let currentLevelKey = "user_id"
        if preferences.object(forKey: currentLevelKey) == nil {
            //  Doesn't exist
        } else {
            let currentLevel = preferences.string(forKey: currentLevelKey)
            mdata[Constants.MessageFields.id] = currentLevel
        }
        
        mdata[Constants.MessageFields.timestamp] = "\(Int(Date().timeIntervalSince1970))"


        self.ref.addDocument(data: mdata)
    }
    
}
