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

class UserScreenView: UIView {
    let label = UILabel()
    let icon = UIImageView()
    let labeltext = UILabel()
    let stackViewHeader = UIStackView()
    
    private let disposeBag = DisposeBag()
    public var dataModel: BehaviorRelay<[[String : Any]]> = BehaviorRelay(value: [])
    public var imageTapped: BehaviorSubject<Void> = BehaviorSubject<Void>(value: ())

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
    }
    
    private func setView() {
        backgroundColor = .white
        stackView.backgroundColor = UIColor(red: 162/255, green: 191/255, blue: 117/255, alpha: 1.0)
        
        addSubview(self.stackView)
        addSubview(self.imageView)
        addSubview(self.lblInstrucciones)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.lblInstrucciones.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            //
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.stackView.heightAnchor.constraint(equalToConstant: 90),
            //
            self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            //
            self.lblInstrucciones.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.lblInstrucciones.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.lblInstrucciones.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: -18)
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
