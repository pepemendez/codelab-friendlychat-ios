//
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn
import RxSwift
import RxCocoa

class UserScreenViewController: UIViewController {
    
    private var mainView: UserScreenView
    private let viewModel: UserScreenViewModel
    private let disposeBag = DisposeBag()
    
    init(with viewModel: UserScreenViewModel){
        self.viewModel = viewModel
        mainView = UserScreenView()
        
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = UIRectEdge()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = self.mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.title = "Mis chats"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    private func bindViewModel(){
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
                            .take(1)
                            .mapToVoid()
                            .asDriverOnErrorJustComplete()
        
        let mediaResponded = rx.sentMessage(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) -> [UIImagePickerController.InfoKey : Any] in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
            })
            .asDriverOnErrorJustComplete()
        
        let imageTrigger = self.mainView.imageTapped
            .map{ _ in
                return self as UIViewController
            }
            .asDriverOnErrorJustComplete()
        
        let nameTrigger = self.mainView.sendSubject
            .asDriverOnErrorJustComplete()
        
        
        let input = UserScreenTypeInput(trigger: viewWillAppear,
                                        imageTrigger: imageTrigger,
                                        imageFetched: mediaResponded,
                                        nameTrigger: nameTrigger)
        
        let output = self.viewModel.transform(input: input)
        
        output
            .nameTriggered
            .drive()
            .disposed(by: self.disposeBag)
        
        output
            .imageFetchedTrigerred
            .drive()
            .disposed(by: self.disposeBag)
        
        output
            .user
            .drive(onNext: { user in
                self.mainView.setUser(data: user)
            })
            .disposed(by: self.disposeBag)
        
        output
            .triggered
            .drive()
            .disposed(by: self.disposeBag)
        
        output
            .imageTrigerred
            .drive()
            .disposed(by: self.disposeBag)
    }
}

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}


extension UserScreenViewController :  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true, completion:nil)
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
