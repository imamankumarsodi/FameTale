//
//  ResetPasswordVC.swift
//  Fametale
//
//  Created by Callsoft on 06/07/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtFeildPassword: UITextField!
    @IBOutlet weak var btnProceedRef: UIButton!
    
    
    //MARK:- VARIABLES
    //MARK:
    let alert = SweetAlert()
    let WebserviceConnection  = AlmofireWrapper()
    let gradient = Gradient.singletonGradientObj
    var btnPasswordState = false
    var btnConfirmPasswordState = false
    let validation:Validation = Validation.validationManager() as! Validation
    var fameTaleUserID = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
        // Do any additional setup after loading the view.
    }
    
    
    func initialMethod(){
        
        let btnProceedRefButtonGradient = gradient.createBlueGreenGradient(from: btnProceedRef.bounds)
        self.btnProceedRef.layer.insertSublayer(btnProceedRefButtonGradient, at: 0)
        btnProceedRef.layer.cornerRadius = 5
        btnProceedRef.layer.masksToBounds = true
    }
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPasswordEyeTapped(_ sender: Any) {
        if (sender as AnyObject).tag == 1{
            if btnPasswordState == false{
                // btnPasswordRef.setImage(, for: .normal)
                txtFeildPassword.isSecureTextEntry = false
                btnPasswordState = !btnPasswordState
            }
            else{
                // btnPasswordRef.setImage(, for: .normal)
                txtFeildPassword.isSecureTextEntry = true
                btnPasswordState = !btnPasswordState
            }
            
        }
        else if (sender as AnyObject).tag == 2{
            if btnConfirmPasswordState == false{
                // btnConfirmPasswordRef.setImage(, for: .normal)
                txtConfirmPassword.isSecureTextEntry = false
                btnConfirmPasswordState = !btnConfirmPasswordState
            }
            else{
                // btnConfirmPasswordRef.setImage(, for: .normal)
                txtConfirmPassword.isSecureTextEntry = true
                btnConfirmPasswordState = !btnConfirmPasswordState
            }
        }
    }
    
    @IBAction func btnProceedTapped(_ sender: Any) {
        
        validationForChangePassword()
        
        
    }
    
    func validationForChangePassword()->Void{
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
        
        if !validation.validateBlankField(txtFeildPassword.text!){
            message = "Please enter new password"
        }
        else if (txtFeildPassword.text!.characters.count < 6 ){
            message = "Password length should be 6-15 characters"
        }
            
        else if !validation.validateBlankField(txtConfirmPassword.text!){
            message = "Please enter confirm password"
        }
        else if (txtConfirmPassword.text!.characters.count < 6 ){
            message = "Password length should be 6-15 characters"
        }
            
        else if txtConfirmPassword.text! != txtFeildPassword.text!{
            
            message = "confirm password must be same"
            
        }
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            callChangePassword()
            
        }
        
        
    }
    
    
    
    
    
    func callChangePassword(){
        
        
        
        let Passdict = ["password": txtFeildPassword.text!,
                        "password_confirmation":txtConfirmPassword.text!] as [String : Any]
        
        print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("resetpass/\(self.fameTaleUserID)", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                    let navController = UINavigationController(rootViewController: vc)
                    navController.navigationBar.isHidden = true
                    self.appDelegate.window?.rootViewController = navController
                    self.appDelegate.window?.makeKeyAndVisible()
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: "Password changed successfully", style: AlertStyle.success)
                    
                    
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
}
