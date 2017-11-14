//
//  CreateGroupVC.swift
//  breakpoint
//
//  Created by kaiz on 11/11/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import UIKit
import Firebase
class CreateGroupVC: UIViewController {

    @IBOutlet weak var tiltleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailsearchTextField: UITextField!
    
    @IBOutlet weak var donebtn: UIButton!
    
    var emailArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailsearchTextField.delegate =  self
        emailsearchTextField.addTarget(self, action: #selector(TextFieldDidChange), for: .editingChanged)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        donebtn.isHidden =  true
    }
    
    
   @objc func TextFieldDidChange() {
        if emailsearchTextField.text == ""{
             emailArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: emailsearchTextField.text!, handler: { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.tableView.reloadData()
            })
        }
    }

    
    @IBAction func doneBtnWasPressed(_ sender: Any) {
        if tiltleTextField.text != "" && descriptionTextField.text != "" {
            DataService.instance.getIds(forUsernames: chosenUserArray, handler: { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                DataService.instance.createGroup(withTitle: self.tiltleTextField.text!, andDescription: self.descriptionTextField.text!, forUserIds: userIds, handler: { (groupCreated) in
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("Group could not be Created. Please try again")
                    }
                })
                
                
            })
            
            
            
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension CreateGroupVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell ()}
        let profileImage = UIImage(named: "defaultProfileImage")
        
        if chosenUserArray.contains(emailArray[indexPath.row]){
           cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        } else {
        cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: false)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell =  tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !chosenUserArray.contains(cell.emailLbl.text!) {
            chosenUserArray.append(cell.emailLbl.text!)
            groupMemberLbl.text = chosenUserArray.joined(separator: ", ")
            donebtn.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({$0 != cell.emailLbl.text!})
            if chosenUserArray.count >= 1 {
                groupMemberLbl.text = chosenUserArray.joined(separator: ", ")
                
            } else {
                groupMemberLbl.text = "Add people"
                
                donebtn.isHidden = true
                
            }
            
        }
        
        
    }
    
    
}

extension CreateGroupVC: UITextFieldDelegate {
    
}
