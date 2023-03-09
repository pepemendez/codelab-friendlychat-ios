//
//  Copyright (c) 2015 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

import Firebase
import GoogleSignIn
import RxSwift
import RxCocoa

@objc(SignInViewController)
class SignInViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var mainView: SignInView?
    private var viewModel: SignInViewModel?
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let navigator = LoginNavigatorDefault(navigationController:
                            self.navigationController!)

        mainView = SignInView()
        viewModel = SignInViewModel(navigator: navigator)
        view = mainView
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
                            .take(1)
                            .mapToVoid()
                            .asDriverOnErrorJustComplete()
                                            
        let buttonAction = self.mainView!.signInButton
                            .rx
                            .controlEvent(.touchUpInside)
                            .map{
                                return self as UIViewController
                            }
                            .asDriverOnErrorJustComplete()
                                            
        let input = LoginTypeInput(trigger: viewWillAppear,
                                   btnActionTap: buttonAction)
        
        if let output = self.viewModel?.transform(input: input){
            output
                .triggered
                .drive()
                .disposed(by: self.disposeBag)
            
            output
                .logged
                .drive()
                .disposed(by: self.disposeBag)
            
            output
                .btnActionTapped
                .drive()
                .disposed(by: self.disposeBag)
        }
  }
}
