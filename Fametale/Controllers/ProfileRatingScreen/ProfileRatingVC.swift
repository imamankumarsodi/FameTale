//
//  ProfileRatingVC.swift
//  Fametale
//
//  Created by Callsoft on 12/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import FloatRatingView

class ProfileRatingVC: UIViewController {

    //MARK:- OUTLETS
    //MARK:
    @IBOutlet weak var lblOverAllRating: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var viewRating: FloatRatingView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var fadedView: UIView!
    //MARK:- VARIABLES
    //MARK:
    var imgUser = ""
    var userName = ""
    var ratingNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUserName.text = userName
        lblOverAllRating.text = "\(ratingNumber)/5"
        viewRating.rating = Float(ratingNumber) as? Float ?? 0.0
        imgProfilePic.sd_setImage(with: URL(string: imgUser as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
        imgProfilePic.layer.masksToBounds = false
        imgProfilePic.clipsToBounds = true
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- METHODS
    //MARK:
    func initialMethod(){
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            fadedView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.fadedView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            fadedView.addSubview(blurEffectView)
            
        }else{
            view.backgroundColor = .black
        }
        
    }
    
    @IBAction func btnActionTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}



