//
//  UsersRepository.swift
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

class UsersRepository {
    let db = Firestore.firestore()
    private var ref: CollectionReference!
    private var user: PublishSubject<[String : Any]?> = PublishSubject<[String : Any]?>()

    init(){
    }
    
    func getUser() -> Observable<[String: Any]?>{        
        db.clearPersistence()
        if let user = Auth.auth().currentUser{
            ref = db.collection("users")
                
            ref.whereField(Constants.MessageFields.id, isEqualTo: user.uid)
            ref.addSnapshotListener({ [weak self] (snapshot, error) in
                guard let strongSelf = self else { return }

                guard let snapshot = snapshot else {
                  print("Error fetching snapshot results: \(error!)")
                  return
                }
                
                if snapshot.documentChanges.count == 0 {
                    print("user not found, creating user")
                    self?.createUser()
                }
                
                let _ = snapshot.documentChanges.map { (document) in
                    if(document.type == .added){
                        strongSelf.user.onNext(document.document.data())
                    }
                }
              })
        }
        
        return user;
    }
    
    func createUser(){
        var mdata = [String:String]()
        mdata[Constants.MessageFields.id] = Auth.auth().currentUser?.uid
        mdata[Constants.MessageFields.name] = Auth.auth().currentUser?.displayName
        if let photoURL = Auth.auth().currentUser?.photoURL {
          mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
        }

        self.ref.addDocument(data: mdata)
    }
}
