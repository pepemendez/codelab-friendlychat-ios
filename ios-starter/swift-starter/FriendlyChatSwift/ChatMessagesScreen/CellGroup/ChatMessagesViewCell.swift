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
    
    private var isMine = false

    private let container = UIView()

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
    
    public let lbltimestamp: UILabel = {
        let title = UILabel()
        title.text = "hola"
        title.isEnabled = false
        title.font = UIFont.systemFont(ofSize: 12)
        title.numberOfLines = 1
        title.textAlignment = .right
        return title
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setView()
        self.constraintView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func dateFromNow(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: "es_MX")
        let distance = Calendar.current.numberOfDaysBetween(date, and: Date())
        if(distance < 1){
            dateFormatter.dateFormat = "hh:mm a"
        } else if (distance < 2) {
            return "ayer"
        }
        else if (distance < 7) {
            dateFormatter.dateFormat = "EEEE"
        }
        else{
            dateFormatter.dateFormat = "MMMM dd"

        }
        
        return dateFormatter.string(from: date)
    }
    
    public func setView(message: ChatMessage){
        let name = message.name ?? ""
        let timestamp = message.timestamp
        lbltimestamp.text = dateFromNow(date: timestamp)
        
        self.isMine = false
        self.isMine = message.isMine


        if let imageURL = message.imageURL {
          if imageURL.hasPrefix("gs://") {
            
          } else if let URL = URL(string: imageURL){//, let data = try? Data(contentsOf: URL) {
              URLSession.shared.dataTask(with: URL) { [weak self](data, response, error) in
                 guard let imageData = data else { return }
                 DispatchQueue.main.async {
                     self?.icon.image = UIImage.init(data: imageData)
                     self?.icon.layer.masksToBounds = false
                     self?.icon.layer.cornerRadius = 20
                     self?.icon.clipsToBounds = true
                 }
               }.resume()
          }
          lblMessage.text = "sent by: \(name)"
        } else {
            let text = message.text ?? ""
            lblTitle.text = "\(name):"
            lblMessage.text = text
            icon.image = UIImage(named: "ic_account_circle")
            if let photoURL = message.photoURL, let URL = URL(string: photoURL){
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
        
        constraintView()
    }
    
    private func setView() {
        self.backgroundColor = .clear
        container.clipsToBounds = true
        container.layer.masksToBounds = false
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        addSubview(container)
        addSubview(self.lbltimestamp)
        
        container.addSubview(self.icon)
        container.addSubview(self.lblTitle)
        container.addSubview(self.lblMessage)
    }
    

    private func constraintView() {
        self.container.backgroundColor = self.isMine ? UIColor(red: 162/255, green: 191/255, blue: 117/255, alpha: 1)
                                                        :  UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        for _view in [self, self.container, self.icon, self.lbltimestamp, lblTitle, lblMessage] {
            for constraint in _view.constraints {
                if let first = constraint.firstItem as? UIView, first == self {
                    _view.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    _view.removeConstraint(constraint)
                }
            }
        }
        
        self.container.translatesAutoresizingMaskIntoConstraints = false
        self.icon.translatesAutoresizingMaskIntoConstraints = false
        self.lbltimestamp.translatesAutoresizingMaskIntoConstraints = false
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = false
        self.lblMessage.translatesAutoresizingMaskIntoConstraints = false
        self.lblMessage.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.lblTitle.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        let constraints = [
            //
            self.container.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            self.container.leadingAnchor.constraint(equalTo:   self.leadingAnchor    , constant: self.isMine ? 90 : 20),
            self.container.trailingAnchor.constraint(equalTo:  self.trailingAnchor   , constant: self.isMine ? -20 : -90),
            self.container.topAnchor.constraint(equalTo:       self.topAnchor        , constant: 10),
            self.container.bottomAnchor.constraint(equalTo:    self.bottomAnchor     , constant: -20),
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
            self.lblMessage.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            //
            self.lbltimestamp.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 2),
            self.lbltimestamp.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.lbltimestamp.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ]
        self.addConstraints(constraints)
    }
}
