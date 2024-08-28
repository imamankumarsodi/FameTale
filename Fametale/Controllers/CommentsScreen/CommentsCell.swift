//
//  CommentsCell.swift
//  Fametale
//
//  Created by Callsoft on 09/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var imgComments: UIImageView!
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
