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
    public let lblTitle: UILabel = {
        let title = UILabel()
        title.text = "hola"
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
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.layer.borderWidth = 1.0
        container.layer.cornerRadius = 6
        container.layer.masksToBounds = false
        addSubview(container)
        
        self.accessoryType = .disclosureIndicator

        container.addSubview(self.lblTitle)
        container.addSubview(self.lblMessage)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblMessage.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
//            container.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor),

            container.leadingAnchor.constraint(equalTo:   self.leadingAnchor    , constant:  10),
            container.trailingAnchor.constraint(equalTo:  self.trailingAnchor   , constant: -10),
            container.topAnchor.constraint(equalTo:       self.topAnchor        , constant:  10),
            container.bottomAnchor.constraint(equalTo:    self.bottomAnchor     , constant: -10),
            //
            self.lblTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            self.lblTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            self.lblTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            //
            self.lblMessage.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8),
            self.lblMessage.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            self.lblMessage.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor, constant: 1),
            self.lblMessage.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
        ]
        self.addConstraints(constraints)
    }
}
