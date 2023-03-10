//
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn
import RxSwift
import RxCocoa

class ChatSelectionViewController: UIViewController {
    
    private var mainView: ChatSelectionView
    private let viewModel: ChatSelectionViewModel
    private let disposeBag = DisposeBag()
    
    init(with viewModel: ChatSelectionViewModel){
        self.viewModel = viewModel
        mainView = ChatSelectionView()
        
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = UIRectEdge()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = self.mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated:true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    private func bindViewModel(){        
        self.viewModel.chat
            .bind(to: mainView.dataModel)
            .disposed(by: self.disposeBag)
        
        let selectionTrigger = self.mainView.selectedTrigger
            .map{
                selection in
                return selection.row
            }
            .asDriver()
        
        let userEditTrigger =  self.mainView.userTapped
            .asDriverOnErrorJustComplete()
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
                            .take(1)
                            .mapToVoid()
                            .asDriverOnErrorJustComplete()
        
        let input = ChatSelectionTypeInput(trigger: viewWillAppear,
                                   selectionTrigger: selectionTrigger,
                                    userEditTrigger: userEditTrigger)
        
        let output = self.viewModel.transform(input: input)
        
        output
            .userEditTriggered
            .drive()
            .disposed(by: self.disposeBag)
        
        output
            .user
            .drive(onNext: { user in
                print("drive \(user)")
                if let user = user{
                    self.mainView.setUser(data: user)
                }
            })
            .disposed(by: self.disposeBag)
        
        output
            .triggered
            .drive()
            .disposed(by: self.disposeBag)
        
        output
            .selectionTriggered
            .drive()
            .disposed(by: self.disposeBag)
    }
}
