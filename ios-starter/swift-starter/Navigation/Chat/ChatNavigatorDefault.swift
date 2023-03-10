//
//  ChatNavigatorDefault.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 09/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation
import UIKit

class ChatNavigatorDefault: ChatNavigatorProtocol{
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func goToUser() {
        let viewController = UserScreenViewController(with: UserScreenViewModel(navigator: self))
        self.navigationController.navigationBar.isHidden = false
        self.navigationController.present(viewController, animated: true)
    }
    
    func goToChat(id: String, chatTitle: String) {
        let viewController = ChatMessagesViewController(with: ChatMessagesViewModel(navigator: self, chatId: id), chatTitle: chatTitle)
        self.navigationController.navigationBar.isHidden = false
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    
    func goBack(){
        self.navigationController.navigationBar.isHidden = true
    }
    
    func Error() {
        fatalError("Error() has not been implemented")
    }
    
    func logOut(){
        self.navigationController.dismiss(animated: true){
            self.navigationController.popToRootViewController(animated: true)
        }
    }
}
