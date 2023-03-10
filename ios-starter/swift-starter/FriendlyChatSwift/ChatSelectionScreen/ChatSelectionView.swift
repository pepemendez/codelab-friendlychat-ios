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

class ChatSelectionView: UIView {
    let label = UILabel()
    let icon = UIImageView()
    let labeltext = UILabel()
    let stackViewHeader = UIStackView()

    public var disposeBag = DisposeBag()
    public var dataModel: BehaviorRelay<[[String : Any]]> = BehaviorRelay(value: [])
    public var userTapped: BehaviorSubject<Void> = BehaviorSubject<Void>(value: ())
    public var selectedTrigger: Driver<ControlEvent<IndexPath>.Element>
    public let tableView: UITableView = {
        let table = UITableView()
        table.clipsToBounds = true
        table.layer.cornerRadius = 20
        table.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        return table
    }()
    
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
    
    init() {
        self.selectedTrigger = self.tableView.rx
            .itemSelected
            .asDriver()
        
        self.stackView
            .rx
            .tapGesture()
            .when(.recognized)
            .mapToVoid()
            .bind(to: userTapped)
            .disposed(by: self.disposeBag)
                
        super.init(frame: .zero)
        self.setView()
    }
    
    private func setView() {
        backgroundColor = UIColor(red: 162/255, green: 191/255, blue: 117/255, alpha: 1.0)
        
        addSubview(self.stackView)
        addSubview(self.tableView)

        self.tableView.register(ChatSelectionViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.tableView.separatorStyle = .none
        self.tableView.bounces = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.tableView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.tableView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        let constraints = [
            //
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.stackView.heightAnchor.constraint(equalToConstant: 60),
            //tableView
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 12),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
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
        self.labeltext.text = "Mis chats"
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
        let _ = self.dataModel
            .bind(to: tableView.rx
                .items(cellIdentifier: "Cell", cellType: ChatSelectionViewCell.self))
            { index, element, cell in
                cell.lblTitle.text = element["name"] as? String
                cell.lblMessage.text = element["active_users"] as? String
            }
            .disposed(by: self.disposeBag)
        
        let _ = self.selectedTrigger
            .drive(onNext: { [weak self] indexPath in
                print(indexPath)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
