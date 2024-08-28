//
//  CountryListCell.swift
//  Fametale
//
//  Created by Callsoft on 22/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class CountryListCell: UITableViewCell {
    
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet var lblCountryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
