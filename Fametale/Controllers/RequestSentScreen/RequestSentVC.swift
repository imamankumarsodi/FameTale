//
//  RequestSentVC.swift
//  Fametale
//
//  Created by Callsoft on 12/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class RequestSentVC: UIViewController {

    //MARK:- OUTLETS
    
    @IBOutlet weak var fadedView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK:- METHODS
    //MARK:
    func initialSetup()
    {
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
  
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnCancelledTapped(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
}
