//
//  Copyright (c) 2015 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

import Firebase
import GoogleSignIn

@objc(SignInViewController)
class SignInViewController: UIViewController {
  @IBOutlet weak var signInButton: GIDSignInButton!
  var handle: AuthStateDidChangeListenerHandle?

  override func viewDidLoad() {
    super.viewDidLoad()
      
    signed()
  }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
    
    deinit {
       if let handle = handle {
         Auth.auth().removeStateDidChangeListener(handle)
       }
     }
    
    func signed(){
        GIDSignIn.sharedInstance.restorePreviousSignIn(){
            result, error in
            
            print("result: \(result)")
            
            if(error != nil){
                print("error")
            }
        }
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
          if user != nil {
            MeasurementHelper.sendLoginEvent()
            self.performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
          }
        }
    }
    
   @objc func signIn(){
        GIDSignIn.sharedInstance.signIn(withPresenting: self){
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
                        self.signed()
                    }
                }
            }
            
            if(error != nil){
                print("error")
            }
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
      let firebaseAuth = Auth.auth()
      do {
        try firebaseAuth.signOut()
        dismiss(animated: true, completion: nil)
      } catch let signOutError as NSError {
        print ("Error signing out: \(signOutError.localizedDescription)")
      }
    }
}
