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
    
    public let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        return imageView
    }()
    
    public let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    public let spinner = UIActivityIndicatorView(style: .large)
    
    init() {
        super.init(frame: .zero)
        self.setView()
        self.addConstraints()
    }
    
    private func setView() {
        backgroundColor = .white


        self.label.text = "Iniciar sesión con Google para comenzar a chatear 🌸"
    }
    
    public func isLoading(){
        self.spinner.startAnimating()
        self.signInButton.isHidden = true
        self.label.isHidden = true
    }
    
    private func addConstraints() {
        backgroundColor = .white
        
        addSubview(self.signInButton)
        addSubview(self.label)
        addSubview(spinner)
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.spinner.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            self.signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.signInButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            //
            self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -80),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            //
            self.spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ]
        self.addConstraints(constraints)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
