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

class UserScreenView: UIView {
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
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0,right: 16)
        return stackView
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
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
        backgroundColor = UIColor(red: 162/255, green: 191/255, blue: 117/255, alpha: 1.0)
        
        addSubview(self.stackView)
        addSubview(self.imageView)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            //
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.stackView.heightAnchor.constraint(equalToConstant: 60),
            //
            self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ]
        self.addConstraints(constraints)
        bindModel()
    }
    
    public func setUser(data userData: [String: String]){
        if let photoURL = userData[Constants.MessageFields.photoURL], let URL = URL(string: photoURL){
            URLSession.shared.dataTask(with: URL) { (data, response, error) in
               guard let imageData = data else { return }
               DispatchQueue.main.async {
                   
                   self.imageView.image = UIImage(data: imageData)
                   
                   let icon = UIImageView()
                   icon.image = UIImage(data: imageData)
                   icon.layer.masksToBounds = false
                   icon.layer.cornerRadius = 30
                   icon.clipsToBounds = true
                   icon.alpha = 0
                   icon.translatesAutoresizingMaskIntoConstraints = false

                   
                   let label = UILabel()
                   label.text = userData[Constants.MessageFields.name]
                   label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
                   let labeltext = UILabel()
                   labeltext.text = "Editar información del usuario"
                   labeltext.textColor = .white
                   labeltext.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                   
                   let stackView = UIStackView()
                   stackView.axis = .vertical
                   stackView.alignment = .fill
                   stackView.distribution = .fill
                   
                   self.stackView.addArrangedSubview(icon)
                   self.stackView.addArrangedSubview(stackView)
                   
                   stackView.addArrangedSubview(label)
                   stackView.addArrangedSubview(labeltext)
                   

                   let constraints = [
                       //tableView
                       icon.widthAnchor.constraint(equalToConstant: 60),
                       icon.heightAnchor.constraint(equalToConstant: 60),
                   ]
                   self.addConstraints(constraints)

                   UIView.animate(withDuration: 1) {
                       icon.alpha = 1
                   }
               }
             }.resume()
        }
    }
    
    private func bindModel() {
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
