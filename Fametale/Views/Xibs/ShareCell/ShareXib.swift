//
//  ShareXib.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class ShareXib: UITableViewCell {

    //MARK:- OUTLETS
    //MARK:
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgShare: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
