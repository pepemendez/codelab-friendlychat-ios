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
    
    func goToChat(id: String) {
        let navigator = self.navigationController
        let viewController = ChatMessagesViewController(with: ChatMessagesViewModel(navigator: self, chatId: id))
        self.navigationController.navigationBar.isHidden = false
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    
    func goBack(){
        self.navigationController.navigationBar.isHidden = true
    }
    
    func Error() {
        fatalError("Error() has not been implemented")
    }
}
