//
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture
import Firebase

class UITextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 12,
        bottom: 0,
        right: 12
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}


class UserScreenView: UIView {
    let label = UILabel()
    let icon = UIImageView()
    let labeltext = UILabel()
    let stackViewHeader = UIStackView()
    
    private let disposeBag = DisposeBag()
    public var dataModel: BehaviorRelay<[[String : Any]]> = BehaviorRelay(value: [])
    public var imageTapped: PublishSubject<Void> = PublishSubject()
    public let sendSubject: PublishSubject<String?> = PublishSubject()
    public let closeSubject: PublishSubject<Void> = PublishSubject()

    lazy private var textField: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 18
        textField.layer.masksToBounds = false
        textField.placeholder = "Cambia aquí tú nombre"
        textField.font = UIFont.systemFont(ofSize: 15.0)
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cambiar nombre", for: .normal)
        button.tintColor = UIColor(red: 162/255, green: 191/255, blue: 117/255, alpha: 1.0)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cerrar Sesión", for: .normal)
        button.tintColor = .red
        return button
    }()
    
    
    public let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 0,right: 16)
        return stackView
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        return imageView
    }()
    
    public let lblInstrucciones: UILabel = {
        let label = UILabel()
        label.text = "Presiona la imagen para tomar una nueva foto de perfil"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        self.imageView
            .rx
            .tapGesture()
            .when(.recognized)
            .mapToVoid()
            .bind(to: imageTapped)
            .disposed(by: self.disposeBag)
                    
                
        super.init(frame: .zero)
        self.setView()
        
        self.sendButton
            .rx
            .tap
            .map{  _ in
                return self.textField.text
            }
            .bind(to: sendSubject)
            .disposed(by: self.disposeBag)
        
        self.closeButton
            .rx
            .tap
            .mapToVoid()
            .bind(to: closeSubject)
            .disposed(by: self.disposeBag)
        
        self.sendButton
            .rx
            .isEnabled
            
        
        let loginValidation = textField
            .rx
            .text
            .map({!(($0?.isEmpty ?? true) || ($0 != nil && $0!.count < 5))})



        let buttonvalidation = loginValidation
                                .bind(to: sendButton.rx.isEnabled)
                                .disposed(by: self.disposeBag)
    }
    
    private func setView() {
        backgroundColor = .white
        stackView.backgroundColor = UIColor(red: 162/255, green: 191/255, blue: 117/255, alpha: 1.0)
        
        addSubview(self.stackView)
        addSubview(self.imageView)
        addSubview(self.lblInstrucciones)
        addSubview(self.textField)
        addSubview(self.sendButton)
        addSubview(self.closeButton)

        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.lblInstrucciones.translatesAutoresizingMaskIntoConstraints = false
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            //
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.stackView.heightAnchor.constraint(equalToConstant: 90),
            //
            self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.imageView.widthAnchor.constraint(greaterThanOrEqualTo: self.widthAnchor, multiplier: 0.5),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 350),
            //
            self.lblInstrucciones.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.lblInstrucciones.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.lblInstrucciones.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: -18),
            //
//            self.textField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.textField.heightAnchor.constraint(equalToConstant: 35),
            self.textField.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            self.textField.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            self.textField.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 18),
            //
            self.sendButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            self.sendButton.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 4),
            //
            self.closeButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.closeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        self.addConstraints(constraints)
        bindModel()
    }
    
    public func setUser(data userData: [String: String]){
        if let photoURL = userData[Constants.MessageFields.photoURL], photoURL.hasPrefix("gs://"){
            Storage.storage().reference(forURL: photoURL).getData(maxSize: INT64_MAX) {(data, error) in
                if let error = error {
                    print("Error downloading: \(error)")
                    return
                }
               DispatchQueue.main.async {
                   
                   self.imageView.image = UIImage(data: data!)

                   self.icon.image = UIImage(data: data!)
                   self.icon.layer.masksToBounds = false
                   self.icon.layer.cornerRadius = 30
                   self.icon.clipsToBounds = true
                   self.icon.alpha = 0
                   self.icon.translatesAutoresizingMaskIntoConstraints = false

                   UIView.animate(withDuration: 1) {
                       self.icon.alpha = 1
                   }
               }
             }.resume()
        }
        
        self.textField.placeholder = userData[Constants.MessageFields.name]
        
        self.label.text = userData[Constants.MessageFields.name]
        self.label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        self.labeltext.text = "Modificar información"
        self.labeltext.textColor = .white
        self.labeltext.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        self.stackViewHeader.axis = .vertical
        self.stackViewHeader.alignment = .fill
        self.stackViewHeader.distribution = .fill
        
        self.stackView.addArrangedSubview(self.icon)
        self.stackView.addArrangedSubview(self.stackViewHeader)
        
        self.stackViewHeader.addArrangedSubview(self.label)
        self.stackViewHeader.addArrangedSubview(self.labeltext)
        

        let constraints = [
            //tableView
             self.icon.widthAnchor.constraint(equalToConstant: 60),
             self.icon.heightAnchor.constraint(equalToConstant: 60),
        ]
        self.addConstraints(constraints)

    }
    
    
    private func bindModel() {
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
