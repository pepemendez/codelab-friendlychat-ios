//
//  ChatSelectionViewCell.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//
import UIKit
import RxCocoa
import RxSwift

class ChatSelectionViewCell: UITableViewCell {

    public let icon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "checked_icon"))
        icon.backgroundColor = .green
//        icon.backgroundColor = .clear
        return icon
    }()

    public let lblTitle: UILabel = {
        let title = UILabel()
        title.text = "hola"
        title.isEnabled = false
        title.numberOfLines = 0
        title.textAlignment = .left
        return title
    }()

    public let lblMessage: UILabel = {
        let message = UILabel()
        message.text = "mundo"
        message.isEnabled = false
        message.textAlignment = .left
        message.numberOfLines = 0
        return message
    }()

    private let divider: UIView = {
        let view = UIView()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setView() {
        let container = UIView()
        container.clipsToBounds = true
        addSubview(container)
        

        container.addSubview(self.icon)
        container.addSubview(self.lblTitle)
        container.addSubview(self.lblMessage)
        container.addSubview(self.divider)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        self.icon.translatesAutoresizingMaskIntoConstraints = false
        self.divider.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblMessage.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            //
            container.heightAnchor.constraint(equalToConstant: 80),
            container.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor),

            container.leadingAnchor.constraint(equalTo:   self.leadingAnchor    , constant: 20),
            container.trailingAnchor.constraint(equalTo:  self.trailingAnchor   , constant: -20),
            container.topAnchor.constraint(equalTo:       self.topAnchor        , constant: 20),
            container.bottomAnchor.constraint(equalTo:    self.bottomAnchor     , constant: -20),
            //
            self.divider.heightAnchor.constraint(equalToConstant: 1),
            self.divider.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 13),
            self.divider.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -13),
            self.divider.topAnchor.constraint(equalTo: container.topAnchor, constant: 1),
            //
            self.icon.heightAnchor.constraint(equalToConstant: 40),
            self.icon.widthAnchor.constraint(equalToConstant: 40),
            self.icon.topAnchor.constraint(equalTo: container.topAnchor, constant: 18),
            self.icon.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            //
            self.lblTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 0.5),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.icon.trailingAnchor, constant: 10),
            self.lblTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            //
            self.lblMessage.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 1),
            self.lblMessage.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            self.lblMessage.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor, constant: 1),
        ]
        self.addConstraints(constraints)
    }
}
