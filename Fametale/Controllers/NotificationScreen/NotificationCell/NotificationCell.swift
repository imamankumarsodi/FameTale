//
//  NotificationCell.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    //MARK:- OUTLETS
    //MARK:
    @IBOutlet weak var imgNotification: UIImageView!
    
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var lblComments: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
