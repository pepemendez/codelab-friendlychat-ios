//
//  SignInViewModel.swift
//  FriendlyChatSwift
//
//  Created by Jose Mendez on 08/03/23.
//  Copyright © 2023 Google Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleSignIn
import Firebase

class SignInViewModel: ViewModelType{
    typealias Input = LoginTypeInput
    
    typealias Output = LoginTypeOutput
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let logged: PublishSubject<Void> =  PublishSubject<Void>()
    private let errorTracker: PublishSubject<String> = PublishSubject<String>()
    private var handle: AuthStateDidChangeListenerHandle?
    private let navigator: LoginNavigatorProtocol
    
    init(navigator: LoginNavigatorProtocol) {
        self.navigator = navigator
    }
    
    deinit {
       if let handle = handle {
         Auth.auth().removeStateDidChangeListener(handle)
       }
     }
    
    func transform(input: LoginTypeInput) -> LoginTypeOutput {
        
        let logged = self.logged
            .observe(on: MainScheduler.instance)
            .do(onNext:{
                _ in
                self.navigator.Logged()
            })
        
        let triggered = input.trigger.do(onNext: {
            GIDSignIn.sharedInstance.restorePreviousSignIn(){
                result, error in
                if(error != nil){
                    print("error")
                }
            }
            self.handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
              if user != nil {
                  MeasurementHelper.sendLoginEvent()
                  self.logged.onNext(())
              }
            }
        })
        
        let buttonActionTapped = input.btnActionTap
            .do(onNext: {
                presenter in
                GIDSignIn.sharedInstance.signIn(withPresenting: presenter){
                    result, error in
                    
                    if(result != nil){
                        guard let authentication = result?.user else { return }
                        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!.tokenString,
                                                                       accessToken: authentication.accessToken.tokenString)
                        Auth.auth().signIn(with: credential) { (user, error) in
                          if let error = error {
                            print("Error \(error)")
                            return
                          }
                            else{
                                self.logged.onNext(())
                            }
                        }
                    }
                    
                    if(error != nil){
                        print("error")
                    }
                }
            })
                
                return Output(triggered: triggered,
                              logged: logged.asDriverOnErrorJustComplete(),
                              btnActionTapped: buttonActionTapped.mapToVoid().asDriver(),
                              error: self.errorTracker.asDriverOnErrorJustComplete())
    }
}
