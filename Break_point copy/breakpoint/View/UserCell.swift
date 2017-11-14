//
//  UserCell.swift
//  breakpoint
//
//  Created by kaiz on 11/11/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var proflieImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var checkImage: UIImageView!
    
    var showing = false
    
    
    
    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool  ) {
        self.proflieImage.image = image
        self.emailLbl.text = email
        if isSelected {
            self.checkImage.isHidden = false
        } else{
            self.checkImage.isHidden = true
            
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if showing == false {
                 checkImage.isHidden = false
                showing = true
                } else {
                    checkImage.isHidden = true
                showing = false
                }
        
        
    }
    }
}
