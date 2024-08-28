//
//  ChatListTableViewCell.swift
//  Fametale
//
//  Created by abc on 29/11/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgProfileView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblMessageBody: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
