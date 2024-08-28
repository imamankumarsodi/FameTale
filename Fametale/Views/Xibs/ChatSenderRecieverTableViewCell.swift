//
//  ChatSenderRecieverTableViewCell.swift
//  Fametale
//
//  Created by abc on 29/11/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class ChatSenderRecieverTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBlue: UIView!
    @IBOutlet weak var lblMessageBodyBlue: UILabel!
    
    @IBOutlet weak var lblTimeStampBlue: UILabel!
    
    @IBOutlet weak var viewGrey: UIView!
    @IBOutlet weak var lblMessageBodyGray: UILabel!
    
    @IBOutlet weak var lblTimeStampGray: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
