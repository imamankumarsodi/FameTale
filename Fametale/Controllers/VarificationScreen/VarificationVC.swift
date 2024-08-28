//
//  VarificationVC.swift
//  Fametale
//
//  Created by Callsoft on 08/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class VarificationVC: UIViewController {
    
    
    @IBOutlet weak var lblSendToNumber: UILabel!
    
    @IBOutlet weak var otpView: VPMOTPView!
    
    
    
    let WebserviceConnection  = AlmofireWrapper()
    var UserDataArray :NSMutableArray =  NSMutableArray()
    var OTPentered = Bool()
    var enteredOtp: String = ""
    var isComingFrom = ""
    var mobileNumberString = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var user_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- USER DEFINED METHODS
    //MARK:
    
    //TODO:- INITIAL METHOD
    func initialMethod(){
        
        //UserDefaults.standard.set(Passdict, forKey: "PASSDICT")
        
        let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        print(TemArray)
        
        let temdict  = UserDefaults.standard.value(forKey: "PASSDICT") as? NSDictionary ?? [:]
        print(temdict)
        
        lblSendToNumber.text = "Send to \(mobileNumberString)"
        
        
        
        otpView.otpFieldsCount = 6
        
        //        otpView.otpFieldEnteredBorderColor = UIColor(red: 200.0/255, green: 233.0/255, blue: 122.0/255, alpha: 1.0)
        //        otpView.otpFieldErrorBorderColor = UIColor(red: 200.0/255, green: 233.0/255, blue: 122.0/255, alpha: 1.0)
        
        otpView.otpFieldDefaultBorderColor = UIColor(red: 200.0/255, green: 233.0/255, blue: 122.0/255, alpha: 1.0)
        otpView.otpFieldBorderWidth = 0
        otpView.delegate = self
        
        // Create the UI
        otpView.initalizeUI()
        
        
        
    }
    
    
    func chekingForOTPConfirmation(OTPString:String){
        
        let verificationID = UserDefaults.standard.value(forKey: "OTPVerification") as! String
        let verificationCode = OTPString
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        Indicator.shared.showProgressView(self.view)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork(){
            
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    
                    
                    Indicator.shared.hideProgressView()
                    print("error: \(String(describing: error.localizedDescription))")
                    _ = SweetAlert().showAlert("FameTale", subTitle: "You have entred wrong code", style: AlertStyle.error)
                    return
                }
                // User is signed in
                // ...
                Indicator.shared.hideProgressView()
                print("Phone Number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                
                
                if self.isComingFrom == "SIGNUP"{
                    
                    self.signUpAPI()
                    
                }else if self.isComingFrom == "FORGOTPASSWORD"{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                    
                    vc.fameTaleUserID = self.user_id
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            
        }
        else{
            
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    
    func sendOtpUsingFirebase(){
        
        let phoneNumber = mobileNumberString
        
        Indicator.shared.showProgressView(self.view)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil ) { (verificationID, error) in
            if let error = error {
                
                Indicator.shared.hideProgressView()
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong!", style: AlertStyle.error)
                print(error)
                
                return
                
            }else{
                Indicator.shared.hideProgressView()
                print(verificationID!)
                UserDefaults.standard.set("\(verificationID!)", forKey: "OTPVerification")
            }
            
        }
    }
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    
    @IBAction func btnResendTapped(_ sender: UIButton) {
        
        sendOtpUsingFirebase()
        
    }
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        
        if isComingFrom == "EDTPROFILE"{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}




//MARK:- EXTENSION OTP
//MARK:

extension VarificationVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        
        if hasEntered ==  true{
            
            OTPentered =  true
            
        }else{
            
            OTPentered =  false
            
        }
        
        return OTPentered
        
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        
        print("OTPString: \(otpString)")
        
        
        
        chekingForOTPConfirmation(OTPString: "\(otpString)")
        
        
        
        //        }else if isComingFrom == "EDTPROFILE"{
        //
        //             self.dismiss(animated: true, completion: nil)
        //
        //        }else{
        //
        //
        //        }
        //
        //
        //
        //        if otpString == "1234" {
        //
        //
        //            if isComingFrom == "SIGNUP"{
        //
        //
        //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        //                self.navigationController?.pushViewController(vc, animated: true)
        //            }
        //            else if isComingFrom == "EDTPROFILE"{
        //
        //
        //            }
        //            else{
        //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        //                self.navigationController?.pushViewController(vc, animated: true)
        //            }
        //            //VerifyMobileCode()
        //
        //        }else{
        //
        //            _ = SweetAlert().showAlert("FameTale", subTitle: "OTP is incorect", style: AlertStyle.error)
        //        }
        //
        //
    }
}

//MARK:- EXTENSION WEB SERVICES
//MARK:

extension VarificationVC{
    
    
    //MARK: WEBSERVICE IMPLEMENTATION
    
    func signUpAPI(){
        
        if UserDefaults.standard.value(forKey: "imageData") != nil {
            
            let temPassdict  = UserDefaults.standard.value(forKey: "PASSDICT")
            
            let imagedata  =  UserDefaults.standard.value(forKey: "imageData") as! NSData
            
            let Passdict = temPassdict as! [String : Any]
            
            print(Passdict)
            
            if InternetConnection.internetshared.isConnectedToNetwork() {
                
                Indicator.shared.showProgressView(self.view)
                
                WebserviceConnection.requWithFile(imageData: imagedata, fileName: "image.jpg", imageparam: "image", urlString:"users", parameters: Passdict as [String : AnyObject], headers: nil, success: { (responseJson) in
                    
                    
                    if responseJson["status"].stringValue == "SUCCESS" {
                        
                        print("SUCCESS")
                        
                        /// SEND TO HOME
                        
                        Indicator.shared.hideProgressView()
                        
                        
                        
                        let UserData  =  SignupModel(json: responseJson)
                        let userDict =  responseJson["data"].dictionary!
                        
                        print(userDict)
                        
                        
                        
                        UserData.name =  userDict["name"]?.string ?? ""
                        UserData.phone = userDict["phone"]?.string ?? ""
                        UserData.dob = userDict["dob"]?.string ?? ""
                        UserData.username = userDict["username"]?.string ?? ""
                        UserData.gender = userDict["gender"]?.string ?? ""
                        UserData.image = userDict["image"]?.string ?? ""
                        UserData.is_admin = userDict["is_admin"]?.string ?? ""
                        //UserData.confirmpassword = userDict["confirmpassword"]?.string
                        UserData.bio = userDict["bio"]?.string
                        UserData.created_at = userDict["created_at"]?.string ?? ""
                        UserData.updated_at = userDict["updated_at"]?.string ?? ""
                        UserData.user_id = userDict["user_id"]?.string ?? ""
                        UserData.token = userDict["token"]?.string ?? ""
                        UserData.country_code = userDict["country_code"]?.string ?? ""
                        
                        let Dict = ["name":UserData.name!,
                                    "phone": UserData.phone!,
                                    "dob":UserData.dob!,
                                    "username":UserData.username!,
                                    "gender":UserData.gender! ,
                                    "image":UserData.image!,
                                    "is_admin":UserData.is_admin!,
                                    //"confirmpassword":UserData.confirmpassword!,
                            "bio":UserData.bio!,
                            "created_at":UserData.created_at!,
                            "updated_at":UserData.updated_at!,
                            "user_id":UserData.user_id!,
                            "country_code":UserData.country_code!,
                            "token":UserData.token!] as [String : Any]
                        
                        
                        self.UserDataArray.add(Dict)
                        
                        print(self.UserDataArray)
                        
                        UserDefaults.standard.set(self.UserDataArray, forKey: "USERINFO")
                        
                        UserDefaults.standard.set(true, forKey: "isLoginSuccessfully")
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                        
                        
                    }else{
                        
                        print("FAILURE")
                        
                        Indicator.shared.hideProgressView()
                        
                        let message  = responseJson["message"].stringValue
                        
                        _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
                        
                        
                    }
                    
                    
                }, failure: { (Error) in
                    
                    print("failure")
                    Indicator.shared.hideProgressView()
                    _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                    
                    
                })
                
                
            }else{
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
                
            }
            
            
            
        }else{
            
            // WHEN No Image Updated
            
            let temPassdict  = UserDefaults.standard.value(forKey: "PASSDICT")
            
            print(temPassdict!)
            
            if InternetConnection.internetshared.isConnectedToNetwork() {
                
                Indicator.shared.showProgressView(self.view)
                
                WebserviceConnection.requestPOSTURL("users", params: temPassdict! as? [String : AnyObject], headers:nil, success: { (responseJson) in
                    
                    if responseJson["status"].stringValue == "SUCCESS" {
                        
                        Indicator.shared.hideProgressView()
                        let UserData  =  SignupModel(json: responseJson)
                        let  userDict =  responseJson["data"].dictionary!
                        
                        print(userDict)
                        
                        UserData.name =  userDict["name"]?.string
                        UserData.phone = userDict["phone"]?.string
                        UserData.dob = userDict["dob"]?.string
                        UserData.username = userDict["username"]?.string
                        UserData.gender = userDict["gender"]?.string
                        UserData.image = userDict["image"]?.string ?? ""
                        UserData.is_admin = userDict["is_admin"]?.string
                        //UserData.confirmpassword = userDict["confirmpassword"]?.string
                        UserData.bio = userDict["bio"]?.string
                        UserData.created_at = userDict["created_at"]?.string
                        UserData.updated_at = userDict["updated_at"]?.string
                        UserData.user_id = userDict["user_id"]?.string
                        UserData.token = userDict["token"]?.string
                        UserData.country_code = userDict["country_code"]?.string
                        
                        let Dict = ["name":UserData.name!,
                                    "phone": UserData.phone!,
                                    "dob":UserData.dob!,
                                    "username":UserData.username!,
                                    "gender":UserData.gender! ,
                                    "image":UserData.image!,
                                    "is_admin":UserData.is_admin!,
                                    //"confirmpassword":UserData.confirmpassword!,
                            "bio":UserData.bio!,
                            "created_at":UserData.created_at!,
                            "updated_at":UserData.updated_at!,
                            "user_id":UserData.user_id!,
                            "country_code":UserData.country_code!,
                            "token":UserData.token!] as [String : Any]
                        
                        self.UserDataArray.add(Dict)
                        
                        print(self.UserDataArray)
                        
                        UserDefaults.standard.set(self.UserDataArray, forKey: "USERINFO")
                        Indicator.shared.hideProgressView()
                        /// SEND TO HOME
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }else{
                        let message  = responseJson["message"].stringValue
                        
                        Indicator.shared.hideProgressView()
                        
                        
                        _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
                        
                    }
                    
                    
                },failure: { (Error) in
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                    
                    Indicator.shared.hideProgressView()
                })
                
                
            }else{
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
                
                Indicator.shared.hideProgressView()
            }
            
            
            
            
        }
        
        
    }
    
    
}
