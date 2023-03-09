//
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChatSelectionView: UIView {
    public var dataModel: BehaviorRelay<[[String : Any]]> = BehaviorRelay(value: [])
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
        if let photoURL = userData[Constants.MessageFields.photoURL], let URL = URL(string: photoURL){
            URLSession.shared.dataTask(with: URL) { (data, response, error) in
               guard let imageData = data else { return }
               DispatchQueue.main.async {
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
                   labeltext.text = "Mis chats"
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
        let _ = self.dataModel
            .bind(to: tableView.rx
                .items(cellIdentifier: "Cell", cellType: ChatSelectionViewCell.self))
            { index, element, cell in
                cell.lblTitle.text = element["name"] as? String
                cell.lblMessage.text = element["active_users"] as? String
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
