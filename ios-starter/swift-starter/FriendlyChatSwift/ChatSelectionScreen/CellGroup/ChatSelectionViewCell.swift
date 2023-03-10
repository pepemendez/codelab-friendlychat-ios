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
    
    public let lblVisibility: UILabel = {
        let message = UILabel()
        message.text = "🔒"
        message.font = UIFont.systemFont(ofSize: 40)
        message.textAlignment = .center
        message.numberOfLines = 1
        return message
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setView(isPublic: Bool, name: String, aditional: String){
        lblTitle.text = name
        lblMessage.text = aditional
        if !isPublic {
            lblVisibility.text = "🔒"
            lblVisibility.backgroundColor = .purple
        }
        else{
            lblVisibility.text = "✅"
            lblVisibility.backgroundColor = .green
        }
        
    }

    private func setView() {
        self.selectionStyle = UITableViewCell.SelectionStyle.none

        let container = UIView()
        
        container.clipsToBounds = true
        container.backgroundColor = .white
        container.layer.cornerRadius = 6
        container.layer.shadowColor = UIColor.gray.cgColor
        container.layer.shadowOffset = CGSize.zero
        container.layer.shadowRadius = 6.0
        container.layer.shadowOpacity = 0.7
        container.layer.masksToBounds = false
        addSubview(container)
        
//        self.accessoryType = .disclosureIndicator

        container.addSubview(self.lblTitle)
        container.addSubview(self.lblMessage)
        container.addSubview(self.lblVisibility)

        container.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblMessage.translatesAutoresizingMaskIntoConstraints = false
        self.lblVisibility.translatesAutoresizingMaskIntoConstraints = false
        self.lblVisibility.clipsToBounds = true
        self.lblVisibility.layer.cornerRadius = 6
        self.lblVisibility.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        
        let constraints = [
            container.leadingAnchor.constraint(equalTo:   self.leadingAnchor    , constant:  20),
            container.trailingAnchor.constraint(equalTo:  self.trailingAnchor   , constant: -20),
            container.topAnchor.constraint(equalTo:       self.topAnchor        , constant:  10),
            container.bottomAnchor.constraint(equalTo:    self.bottomAnchor     , constant: -10),
            //
            self.lblVisibility.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.lblVisibility.topAnchor.constraint(equalTo: container.topAnchor),
            self.lblVisibility.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            self.lblVisibility.widthAnchor.constraint(equalToConstant: 80),
            //
            self.lblTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            self.lblTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 90),
            self.lblTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            //
            self.lblMessage.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8),
            self.lblMessage.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            self.lblMessage.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor, constant: 1),
            self.lblMessage.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            //
        ]
        self.addConstraints(constraints)
    }
}
