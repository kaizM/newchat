//
//  MeVC.swift
//  breakpoint
//
//  Created by Caleb Stultz on 7/24/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import UIKit
import Firebase
class MeVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.emailLbl.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func signOutBtnWasPressed(_ sender: Any) {

        let logoutPopup = UIAlertController(title: "Logout?", message: "Are u sure u want to log out?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            do {
                try  Auth.auth().signOut()
                let AuthVc = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(AuthVc!, animated: true, completion: nil)
            } catch {
                print(error)
            }
            
            
            
        }
        
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
}
