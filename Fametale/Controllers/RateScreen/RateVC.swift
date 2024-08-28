//
//  RateVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import FloatRatingView

class RateVC: UIViewController,UITextViewDelegate {

    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btnRateRef: UIButton!
    
    
    
    //MARK:- VARIABLE
    //MARK:
    
    let WebserviceConnection  = AlmofireWrapper()
     var token = ""
    let validation:Validation = Validation.validationManager() as! Validation
    override func viewDidLoad() {
        super.viewDidLoad()
         initialMethod()

        // Do any additional setup after loading the view.
    }
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialMethod(){
        self.textView.text = "Write Your Feedback..."
        
        self.textView.textColor = UIColor.lightGray
        textView.delegate = self
        
        
        
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
        
        if (floatRatingView.rating <= 0.0 ){
            message = "Please rate FameTale"
        }
        
        
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            callRatingAPI()
            
        }
        
        
    }
    
    
    
    func callRatingAPI(){

        let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        print(TemArray!)
        
        let temdict  =  TemArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String
        
        print(userID!)
        print("USERID AAGAYAI ")
        token = temdict?.value(forKey: "token") as? String ?? ""
        
         let rating = String(format: "%.2f", self.floatRatingView.rating)
        
        
        let Passdict = ["rating": rating,
                        "feedback":textView.text!,
                        "token":token] as [String : Any]
        
        print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("feedback/\(userID!)", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
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
                
                
            })
            
            
        }else{
            Indicator.shared.hideProgressView()
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    @IBAction func btnNavigationTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnRateTapped(_ sender: Any) {
       validationForRateFameTale()
        
    }
    
    
    //MARK: UITextViewDelegate delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(self.textView == textView){
            
            self.textView.text = nil
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if(self.textView == textView){
            
            if self.textView.text.isEmpty {
                
                self.textView.text = "Write Your Feedback..."
                
                self.textView.textColor = UIColor.lightGray
            }
            
            
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (self.textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 150
    }
    
    
    

}
