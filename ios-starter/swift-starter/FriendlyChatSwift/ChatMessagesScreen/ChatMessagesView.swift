//
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class ChatMessagesView: UIView {
    public var dataModel: BehaviorRelay<[[String : Any]]> = BehaviorRelay(value: [])
    public var selectedTrigger: Driver<ControlEvent<IndexPath>.Element>
    public let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero)
        return table
    }()
    
    public let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0,right: 8)
        stackView.spacing = 8
        return stackView
    }()
    
    public let textField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 6
        textField.layer.masksToBounds = false
        return textField
    }()
    
    public let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enviar", for: .normal)
        return button
    }()
    
    public let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_add_a_photo"), for: .normal)
        return button
    }()
    
    init() {
        self.selectedTrigger = self.tableView.rx
            .itemSelected
            .asDriver()
                
        super.init(frame: .zero)
        self.setView()
    }
    
    private func setView() {
        backgroundColor = .white
        
        addSubview(self.tableView)
        addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.photoButton)
        self.stackView.addArrangedSubview(self.textField)
        self.stackView.addArrangedSubview(self.sendButton)
        
        self.tableView.register(ChatMessagesViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.tableView.separatorStyle = .none
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.photoButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.sendButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let constraints = [
            //tableView
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.tableView.bottomAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            //
            //self.textField.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -80),
            self.photoButton.widthAnchor.constraint(equalToConstant: 30),
            self.sendButton.widthAnchor.constraint(equalToConstant: 60)
        ]
        self.addConstraints(constraints)
        bindModel()
    }
    
    private func bindModel() {
        let _ = self.dataModel
            .bind(to: tableView.rx
                .items(cellIdentifier: "Cell", cellType: ChatMessagesViewCell.self))
            { index, element, cell in

                guard let message = element as? [String:String] else { return }
                cell.setView(message: message)
                if let imageURL = message[Constants.MessageFields.imageURL] {
                    if imageURL.hasPrefix("gs://") {
                        Storage.storage().reference(forURL: imageURL).getData(maxSize: INT64_MAX) {(data, error) in
                          if let error = error {
                            print("Error downloading: \(error)")
                            return
                          }
                          DispatchQueue.main.async {
                            cell.imageView?.image = UIImage.init(data: data!)
                            cell.imageView?.layer.masksToBounds = false
                            cell.imageView?.layer.cornerRadius = 0
                            cell.imageView?.clipsToBounds = true
                            cell.setNeedsLayout()
                          }
                        }
                    }
                }
        }
        
        let _ = self.selectedTrigger
            .drive(onNext: { [weak self] indexPath in
                print(indexPath)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
