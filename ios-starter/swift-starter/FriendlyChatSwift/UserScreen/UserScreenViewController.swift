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
        
        let closeTrigger = self.mainView.closeSubject
            .asDriverOnErrorJustComplete()
        
        
        let input = UserScreenTypeInput(trigger: viewWillAppear,
                                        imageTrigger: imageTrigger,
                                        imageFetched: mediaResponded,
                                        nameTrigger: nameTrigger,
                                        closeTrigger: closeTrigger)
        
        let output = self.viewModel.transform(input: input)
        
        output
            .closeTriggered
            .drive()
            .disposed(by: self.disposeBag)
        
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
                if let user = user {
                    self.mainView.setUser(data: user)
                }
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

        picker.dismiss(animated: true, completion:nil)
    }
}
