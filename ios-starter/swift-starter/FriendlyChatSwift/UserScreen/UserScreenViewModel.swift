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
import Photos

class UserScreenViewModel: ViewModelType{
    typealias Input = UserScreenTypeInput
    
    typealias Output = UserScreenTypeOutput
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let errorTracker: PublishSubject<String> = PublishSubject<String>()
    private let navigator: ChatNavigatorProtocol
    private let repository: ChatRoomsRepository
    private let userRepository: UsersRepository
    var storageRef: StorageReference!

    public var chat: BehaviorRelay<[[String : Any]]> = BehaviorRelay(value: [])
    public var user: PublishSubject<[String: String]> = PublishSubject<[String: String]>()

    init(navigator: ChatNavigatorProtocol) {
        self.navigator = navigator
        self.storageRef = Storage.storage().reference()
        self.repository = ChatRoomsRepository()
        self.userRepository = UsersRepository()
    }
    
    func transform(input: UserScreenTypeInput) -> UserScreenTypeOutput {
        var data = [String:String]()
        
        self.userRepository
            .getUser()
            .do(onNext: { user in
                if let info = user {
                    data[Constants.MessageFields.name] = info[Constants.MessageFields.name] as! String
                    data[Constants.MessageFields.photoURL] = info[Constants.MessageFields.photoURL] as? String
                    
                    self.user.onNext(data)
                }
            })
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
                    
        let nameTriggered = input.nameTrigger
                .do(onNext: { [weak self] name in
                    if let name = name, let strongSelf = self{
                        strongSelf.userRepository.modifyUser(withName: name)
                    }
                })
                .mapToVoid()
                    

        let imageTriggered = input.imageTrigger
                    .map{ parent -> Void in
                        let picker = UIImagePickerController()
                        picker.delegate = (parent as! any UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                          picker.sourceType = UIImagePickerController.SourceType.camera
                        } else {
                          picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                        }

                        parent.present(picker, animated: true, completion:nil)                        
                    }
                    .asDriver()
        
        let imageFetchedTriggered = input.imageFetched
            .map{ data -> UIImage? in
                let info = convertFromUIImagePickerControllerInfoKeyDictionary(data)

                guard let uid = Auth.auth().currentUser?.uid else { return nil }

                // if it's a photo from the library, not an image from the camera
                if let referenceURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.referenceURL)] as? URL {
                    let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceURL], options: nil)
                    let asset = assets.firstObject
                    asset?.requestContentEditingInput(with: nil, completionHandler: { [weak self] (contentEditingInput, info) in
                      let imageFile = contentEditingInput?.fullSizeImageURL
                      let filePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\((referenceURL as AnyObject).lastPathComponent!)"
                        guard let strongSelf = self else { return }
                        strongSelf.storageRef.child(filePath)
                          .putFile(from: imageFile!, metadata: nil) { (metadata, error) in
                            if let error = error {
                              let nsError = error as NSError
                              print("Error uploading: \(nsError.localizedDescription)")
                              return
                            }
                              self?.userRepository.modifyUser(withPhoto: strongSelf.storageRef.child((metadata?.path)!).description)
                          }
                    })
                } else {
                  guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else { return nil }
                  let imageData = image.jpegData(compressionQuality: 0.8)
                  guard let uid = Auth.auth().currentUser?.uid else { return nil }
                  let imagePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                  let metadata = StorageMetadata()
                  metadata.contentType = "image/jpeg"
                  self.storageRef.child(imagePath)
                    .putData(imageData!, metadata: metadata) { [weak self] (metadata, error) in
                      if let error = error {
                        print("Error uploading: \(error)")
                        return
                      }
                      guard let strongSelf = self else { return }
                        self?.userRepository.modifyUser(withPhoto: strongSelf.storageRef.child((metadata?.path)!).description)
                  }
                }
                
                return info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
            }
            .asDriver()
        
        let closeTriggered = input
            .closeTrigger
            .do(onNext: {
                print("closeTriggered")
                self.navigator.logOut()
            })
            .mapToVoid()
            .asDriver()
            
                    
        return Output(triggered: triggered,
                      imageTrigerred: imageTriggered,
                      imageFetchedTrigerred: imageFetchedTriggered,
                      nameTriggered: nameTriggered,
                      user: self.user.asDriverOnErrorJustComplete(),
                      closeTriggered: closeTriggered,
                      error: self.errorTracker.asDriverOnErrorJustComplete())
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
