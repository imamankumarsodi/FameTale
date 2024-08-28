//
//  MoreTableViewCell.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgTap: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
