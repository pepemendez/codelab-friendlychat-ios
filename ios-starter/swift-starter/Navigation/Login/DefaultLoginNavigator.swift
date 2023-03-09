//
//  LoginNavigatorDefault.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation
import UIKit

class LoginNavigatorDefault: LoginNavigatorProtocol{
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func Logged() {
//        self.navigationController
//            .topViewController?
//            .performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
        let navigator = ChatNavigatorDefault(navigationController: self.navigationController)
        let viewController = ChatSelectionViewController(with: ChatSelectionViewModel(navigator: navigator))
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func Error() {
        fatalError("Error() has not been implemented")
    }
}
