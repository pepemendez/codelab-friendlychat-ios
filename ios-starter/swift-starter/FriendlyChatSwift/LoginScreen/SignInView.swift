//
//  SignInView.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation
import GoogleSignIn
import RxSwift
import RxCocoa

class SignInView: UIView {
    
    public let signInButton: GIDSignInButton = {
        let btn = GIDSignInButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        self.setView()
    }
    
    private func setView() {
        backgroundColor = .white
        
        addSubview(self.signInButton)
        
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.signInButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        self.addConstraints(constraints)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
