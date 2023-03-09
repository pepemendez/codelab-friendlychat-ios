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

class ChatMessagesViewController: UIViewController {
    
    private var mainView: ChatMessagesView
    private let viewModel: ChatMessagesViewModel
    private let disposeBag = DisposeBag()
    
    init(with viewModel: ChatMessagesViewModel){
        self.viewModel = viewModel
        mainView = ChatMessagesView()
        
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = []
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = self.mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    
    private func bindViewModel(){
        self.mainView.dataModel
            .asDriver()
            .drive(onNext:{ _ in
                print("self.mainView.dataModel")
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.messages.asObservable()
            .bind(to: mainView.dataModel)
            .disposed(by: self.disposeBag)
        
        let selectionTrigger = self.mainView.selectedTrigger
            .map{
                selection in
                return selection.row
            }
            .asDriver()
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
                            .take(1)
                            .mapToVoid()
                            .asDriverOnErrorJustComplete()
        
        let input = ChatMessagesTypeInput(trigger: viewWillAppear,
                                   selectionTrigger: selectionTrigger)
        
        let output = self.viewModel.transform(input: input)
        
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
