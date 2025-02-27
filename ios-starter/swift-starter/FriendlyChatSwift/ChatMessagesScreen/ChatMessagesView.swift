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

class TextFieldWithPadding: UITextView {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 8,
        bottom: 0,
        right: 8
    )
}

class ChatMessagesView: UIView {
    public var dataModel: BehaviorRelay<[ChatMessage]> = BehaviorRelay(value: [])
    public var selectedTrigger: Driver<ControlEvent<IndexPath>.Element>
    private let disposeBag = DisposeBag()
    public let photoSubject: PublishSubject<Void> = PublishSubject()
    public let sendSubject: PublishSubject<Void> = PublishSubject()
    public let messageSubject: PublishSubject<String> = PublishSubject<String>()

    public let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero)
        table.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.02)
        table.clipsToBounds = true
        table.layer.cornerRadius = 20
        table.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        return table
    }()
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 8, bottom: 10,right: 8)
        stackView.spacing = 8
        return stackView
    }()
    
    private let textField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 18
        textField.layer.masksToBounds = false
        textField.isScrollEnabled = false
        textField.font = UIFont.systemFont(ofSize: 15.0)
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enviar", for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_add_a_photo"), for: .normal)
        button.tintColor = .black
        button.isHidden = true
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
        
        self.tableView.automaticallyAdjustsScrollIndicatorInsets = false
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.tableView.separatorStyle = .none
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.allowsSelection = false
        
        self.photoButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.sendButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let constraints = [
            //tableView
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.tableView.bottomAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
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
            .do(onNext: { _ in
                    self.tableView.setContentOffset(CGPoint(x: 0, y : CGFloat.greatestFiniteMagnitude), animated: true)
                 })
            .bind(to: tableView.rx
                .items(cellIdentifier: "Cell", cellType: ChatMessagesViewCell.self))
            { index, element, cell in
                cell.setView(message: element)
                if let imageURL = element.photoURL {
                    if imageURL.hasPrefix("gs://") {
                        Storage.storage().reference(forURL: imageURL).getData(maxSize: INT64_MAX) {(data, error) in
                          if let error = error {
                            print("Error downloading: \(error)")
                            return
                          }
                          DispatchQueue.main.async {
                            cell.icon.image = UIImage.init(data: data!)
                            cell.icon.layer.masksToBounds = false
                            cell.icon.layer.cornerRadius = 20
                            cell.icon.clipsToBounds = true
                            cell.setNeedsLayout()
                          }
                        }
                    }
                }
        }
        
        let _ = self.selectedTrigger
            .drive(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
        
        self.photoButton.rx
            .tap
            .bind(to: self.photoSubject)
            .disposed(by: self.disposeBag)
        
        self.sendButton.rx
            .tap
            .do(onNext: {
                self.textField.text = ""
                self.endEditing(true)
            })
            .bind(to: self.sendSubject)
            .disposed(by: self.disposeBag)
                
        
        self.textField.rx
            .text
            .orEmpty
            .bind(to: self.messageSubject)
            .disposed(by: self.disposeBag)
                
                
        let loginValidation = textField
            .rx
            .text
            .map({!(($0?.isEmpty ?? true) || ($0 != nil && $0!.count < 0))})



        let _ = loginValidation
                                .bind(to: sendButton.rx.isEnabled)
                                .disposed(by: self.disposeBag)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
