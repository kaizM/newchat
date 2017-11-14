//
//  AuthVC.swift
//  breakpoint
//
//  Created by Caleb Stultz on 7/24/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn



class AuthVC: UIViewController , GIDSignInUIDelegate , GIDSignInDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = "1098835378078-1ah043s8or3jga4edsrsenuocgqk61ov.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        //  Converted to Swift 4 with Swiftify v1.0.6519 - https://objectivec2swift.com/
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
        
        
            }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
      print(user.authentication)
        loginwithgmail(authentication: user.authentication)
    }
    @IBAction func signInWithEmailBtnWasPressed(_ sender: Any) {
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self as! FBSDKLoginButtonDelegate
        
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
                
                
            }
            
            
            //let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainboard = storyboard.instantiateViewController(withIdentifier: "mainboard")
                    self.present(mainboard, animated: true, completion: nil)
                    
                    return
                }
                
                
                
                
                
            })
            
        }

    }
    
    @IBAction func googleSignInBtnWasPressed(_ sender: Any) {
        
        print("google sign in ")
        GIDSignIn.sharedInstance().signIn()
       // loginwithgmail()
        
       
    }
    func loginwithgmail(authentication : GIDAuthentication){
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user : User?, error : Error?) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }else{
                print(user?.email)
                print(user?.displayName)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainboard = storyboard.instantiateViewController(withIdentifier: "mainboard")
                self.present(mainboard, animated: true, completion: nil)
            }
        }
        
    }

}
