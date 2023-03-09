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
    
    init() {
        self.selectedTrigger = self.tableView.rx
            .itemSelected
            .asDriver()
                
        super.init(frame: .zero)
        self.setView()
    }
    
    private func setView() {
        backgroundColor = .lightGray
        
        addSubview(self.tableView)
        
        self.tableView.register(ChatMessagesViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        self.tableView.separatorStyle = .none
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            //tableView
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
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
