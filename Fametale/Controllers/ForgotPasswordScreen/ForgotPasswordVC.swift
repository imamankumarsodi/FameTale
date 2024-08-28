//
//  ForgotPasswordVC.swift
//  Fametale
//
//  Created by Callsoft on 09/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordVC: UIViewController {

    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var btnSendRef: UIButton!
    
    @IBOutlet weak var txt_fieldPhoneNumber: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    //MARK:- VARIABLE
    //MARK:
    let gradient = Gradient.singletonGradientObj
    var arrayFromPlist:NSMutableArray = NSMutableArray()
    let validation:Validation = Validation.validationManager() as! Validation
    let WebserviceConnection  = AlmofireWrapper()
    var user_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()

        // Do any additional setup after loading the view.
    }
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialMethod(){
        let signUpButtonGradient = gradient.createBlueGreenGradient(from: btnSendRef.bounds)
        self.btnSendRef.layer.insertSublayer(signUpButtonGradient, at: 0)
        btnSendRef.layer.cornerRadius = 5
        btnSendRef.layer.masksToBounds = true
    }
    
    
    //TODO:- VALIDATIONS
    
    
    func validationSetup()->Void{
        
        var message = ""
        
        if !validation.validateBlankField(txtCountryCode.text!){
            message = "Enter your Country code"
        }
       
        else if !validation.validateBlankField(txt_fieldPhoneNumber.text!){
            message = "Enter your Phone number"
        }
        if message != "" {
            
            
            _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            
            getUserIDByNumber()
           
            
        }
        
   
    }
    
    func sendOtpUsingFirebase(){
        
        let phoneNumber = "\(txtCountryCode.text!)\(txt_fieldPhoneNumber.text!)"
        
        Indicator.shared.showProgressView(self.view)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil ) { (verificationID, error) in
            if let error = error {
                
                Indicator.shared.hideProgressView()
                _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong!", style: AlertStyle.error)
                print(error)
                
                return
                
            }else{
                Indicator.shared.hideProgressView()
                print(verificationID!)
                UserDefaults.standard.set("\(verificationID!)", forKey: "OTPVerification")
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VarificationVC") as! VarificationVC
                vc.mobileNumberString = phoneNumber
                vc.isComingFrom = "FORGOTPASSWORD"
                vc.user_id = self.user_id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    
    
    
    
    
    func getUserIDByNumber() {
        
        
        
        let passDict = ["phone":txt_fieldPhoneNumber.text!,
                        "country_code":txtCountryCode.text!] as! [String : AnyObject]
        
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("getuseridbynumber", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    let dataDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    self.user_id = dataDict.value(forKey: "user_id") as? String ?? ""
                    
                    self.sendOtpUsingFirebase()
                    
                    
                    
        
                    
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
    
    
    
    
    
    
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSendTapped(_ sender: Any) {
        
        validationSetup()
        
    }
    
    @IBAction func btnCountryCodeTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListTablVc") as! CityListTablVc
        vc.objeCountryListDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
}



//MARK:- EXTENTION COUNTRY CODE
//MARK:
extension ForgotPasswordVC:selectedCountry{
    
    func loadPlistDataatLoadTime() {
        
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("countryList.plist")
        let fileManager = FileManager.default
        //check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: "countryList", ofType: "plist") {
                let rootArray = NSMutableArray(contentsOfFile: bundlePath)
                print("Bundle RecentSearch.plist file is --> \(rootArray?.description)")
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }
                catch _ {
                    print("Fail to copy")
                }
                print("copy")
            } else {
                print("RecentSearch.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("RecentSearch.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        let rootarray = NSMutableArray(contentsOfFile: path)
        print("Loaded RecentSearch.plist file is --> \(rootarray?.description)")
        let array = NSMutableArray(contentsOfFile: path)
        print(array as Any) // Array of country code ,name
        if let dict = array {
            
            
            let tempArray = array!
            self.arrayFromPlist = tempArray
            var i = 0
            for index in tempArray{
                
                let dic = tempArray.object(at: i) as? NSDictionary
                i = i+1
                let code = dic?.object(forKey: "country_dialing_code") as? String
                
                let trimSring:String = code!.replacingOccurrences(of: " ", with: "")
                print(trimSring) // country code
                let countryName = dic?.object(forKey: "country_name") as? String
                let codeString = trimSring+" "+countryName!
                
                //   self.countryCodeArray.add(codeString)
                
            }
            
            //  print(self.countryCodeArray)
            
        } else {
            print("WARNING: Couldn't create dictionary from RecentSearch.plist! Default values will be used!")
        }
    }
    
    
    
    
    func countryInformation(info: NSDictionary) {
        
        print(info)
        let code = info.object(forKey: "country_dailing_code") as? String ?? ""
                txtCountryCode.text = code
                txtCountryCode.textColor = UIColor.black
                txtCountryCode.textAlignment = .center
        print(code)
        
    }
    
    
    
}

