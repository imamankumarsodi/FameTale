//
//  VideoRateAndCommnetVC.swift
//  Fametale
//
//  Created by Callsoft on 12/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import FloatRatingView

class VideoRateAndCommnetVC: UIViewController {
    
    //MARK:- OUTLETS
    //MARK:
    @IBOutlet weak var lblHeaderRatings: UILabel!
    
    @IBOutlet weak var lblNoThanksRef: UILabel!
    @IBOutlet weak var btnRateVideoRef: UIButton!
    
    @IBOutlet weak var viewRating: FloatRatingView!
    @IBOutlet weak var txtFieldComment: UITextView!
    @IBOutlet weak var fadedView: UIView!
    
    //MARK:- VARIABLES
    //MARK:
    let WebserviceConnection  = AlmofireWrapper()
    var videoId = ""
    var name  = ""
    let gradient = Gradient.singletonGradientObj
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        initialSetup()
        
    }
    //MARK:- METHODS
    //MARK:
    
    
    //TODO:- VALIDATIONS
    
    
    
    
   
    func userVideoRating(){

        let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        print(TemArray!)
        
        let temdict  =  TemArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String
        let token = temdict?.value(forKey: "token") as? String ?? ""
        let rating = String(format: "%.2f", self.viewRating.rating)
        let Passdict = ["video_id": videoId,
                        "feedback":txtFieldComment.text!,
                        "rating_num":rating,
                        "token":token] as [String : Any]
        
        print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("rateVideo/\(userID!)", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
               
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    
                    let  userDict =  responseJson["data"].dictionary!
                    
                    let message  = responseJson["message"].stringValue
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.success)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    
                    Indicator.shared.hideProgressView()
                    
                    let message  = responseJson["message"].stringValue
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
                    
                    
                }
                
                
            },failure: { (Error) in
                
                
                Indicator.shared.hideProgressView()
                _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                 self.dismiss(animated: true, completion: nil)
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    func validationForRateFameTale()->Void{
        //
        //        txtOldPassword: UITextField!
        //
        //        @IBOutlet weak var txtConfirmPassword: UITextField!
        //     @IBOutlet weak var txtNewPassword: UITextField!
        
        
        //        1. Please enter name
        //        2. Please enter phone number
        //        3. Please enter password
        //        4. Please enter confirm password
        //        5. Please select date
        //        6. Please select gender
        //        7. Please accept terms & conditions
        //
        //        Password length message-
        //        Password length should be 6-15 characters
        //
        //        confirm password message-
        //        confirm password must be same
        //
        //        Verification code
        //        Please enter correct verification code
        
        
        
        var message = ""
        
        if (viewRating.rating <= 0.0 ){
            message = "Please rate video"
        }
        else if txtFieldComment.text! == "Write Your Feedback..." || txtFieldComment.text! == ""{
            message = "Please comment on video"
        }
        
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            userVideoRating()
            
        }
        
        
    }
    
    
    @objc func noThahksAction(){
        
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnRateTapped(_ sender: Any) {
        validationForRateFameTale()
    }
    
}


//MARK:- Custom Method
//MARK:-
extension VideoRateAndCommnetVC : UITextViewDelegate{
    
    func initialSetup(){
        lblHeaderRatings.text = "How would you rate \(name)'s video?"
        let btnRateVideoGradient = gradient.createBlueGreenGradient(from: btnRateVideoRef.bounds)
        self.btnRateVideoRef.layer.insertSublayer(btnRateVideoGradient, at: 0)
        btnRateVideoRef.layer.cornerRadius = btnRateVideoRef.frame.size.height/2
        btnRateVideoRef.layer.masksToBounds = true
        
        lblNoThanksRef.isUserInteractionEnabled = true // Remember to do this
        let taplblNoThanksRef: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(noThahksAction))
        lblNoThanksRef.addGestureRecognizer(taplblNoThanksRef)
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
        
        self.txtFieldComment.text = "Write Your Feedback..."
        
        self.txtFieldComment.textColor = UIColor.lightGray
        self.txtFieldComment.delegate = self
        
    }
    
    //MARK: UITextViewDelegate delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(self.txtFieldComment == textView){
            
            self.txtFieldComment.text = nil
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if(self.txtFieldComment == textView){
            
            if self.txtFieldComment.text.isEmpty {
                
                self.txtFieldComment.text = "Write Your Feedback..."
                
                self.txtFieldComment.textColor = UIColor.lightGray
            }
            
            
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (self.txtFieldComment.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 150
    }
    
    
   
}
