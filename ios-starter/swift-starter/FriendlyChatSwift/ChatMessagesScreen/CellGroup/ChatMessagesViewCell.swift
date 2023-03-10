//
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//
import UIKit
import RxCocoa
import RxSwift

class ChatMessagesViewCell: UITableViewCell {

    public let icon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "checked_icon"))
        icon.backgroundColor = .green
//        icon.backgroundColor = .clear
        return icon
    }()

    public let lblTitle: UILabel = {
        let title = UILabel()
        title.text = "hola"
        title.numberOfLines = 1
        title.textAlignment = .left
        return title
    }()

    public let lblMessage: UILabel = {
        let message = UILabel()
        message.text = "mundo"
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
    
    public func setView(message: [String: String]){
        let name = message[Constants.MessageFields.name] ?? ""
        if let imageURL = message[Constants.MessageFields.imageURL] {
          if imageURL.hasPrefix("gs://") {
            
          } else if let URL = URL(string: imageURL), let data = try? Data(contentsOf: URL) {
            icon.image = UIImage.init(data: data)
          }
          lblMessage.text = "sent by: \(name)"
        } else {
          let text = message[Constants.MessageFields.text] ?? ""
            lblTitle.text = "\(name):"
            lblMessage.text = text
            icon.image = UIImage(named: "ic_account_circle")
            if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL){
                URLSession.shared.dataTask(with: URL) { [weak self](data, response, error) in
                   guard let imageData = data else { return }
                   DispatchQueue.main.async {
                       self?.icon.image = UIImage(data: imageData)
                       self?.icon.layer.masksToBounds = false
                       self?.icon.layer.cornerRadius = 20
                       self?.icon.clipsToBounds = true
                   }
                 }.resume()
            }
          }
    }

    private func setView() {
        self.backgroundColor = .clear
        let container = UIView()
        container.clipsToBounds = true
        container.backgroundColor = UIColor(red: 162/255, green: 191/255, blue: 117/255, alpha: 1)
        container.layer.masksToBounds = false
        container.layer.cornerRadius = 20
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
        self.lblMessage.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.lblTitle.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        let constraints = [
            //
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            container.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor),

            container.leadingAnchor.constraint(equalTo:   self.leadingAnchor    , constant: 20),
            container.trailingAnchor.constraint(equalTo:  self.trailingAnchor   , constant: -20),
            container.topAnchor.constraint(equalTo:       self.topAnchor        , constant: 10),
            container.bottomAnchor.constraint(equalTo:    self.bottomAnchor     , constant: -10),
            //
            self.icon.heightAnchor.constraint(equalToConstant: 40),
            self.icon.widthAnchor.constraint(equalToConstant: 40),
            self.icon.topAnchor.constraint(equalTo: container.topAnchor, constant: 18),
            self.icon.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            //
            self.lblTitle.heightAnchor.constraint(equalToConstant: 25),
            self.lblTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            self.lblTitle.leadingAnchor.constraint(equalTo: self.icon.trailingAnchor, constant: 10),
            self.lblTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            //
            self.lblMessage.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 1),
            self.lblMessage.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            self.lblMessage.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor, constant: 1),
            self.lblMessage.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ]
        self.addConstraints(constraints)
    }
}
