//
//  SignUpVC.swift
//  Fametale
//
//  Created by Callsoft on 08/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import DropDown
import SDWebImage
import FirebaseAuth

class SignUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK:- OUTLETS
    //MARK:
    
    
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblTermsAndCondtions: UILabel!
    @IBOutlet weak var txtConfirmPasswordRef: UITextField!
    @IBOutlet weak var txtPasswordRef: UITextField!
    @IBOutlet weak var btnConfirmPasswordRef: UIButton!
    @IBOutlet weak var btnPasswordRef: UIButton!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var btnTermsAndConditionsRef: UIButton!
    @IBOutlet weak var btnSignUpRef: UIButton!
    @IBOutlet weak var lblAlreadyHaveAccount: UILabel!
    @IBOutlet weak var viewGender: UIView!
    
    @IBOutlet weak var txtUserFameTale: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txt_fieldDateOfBirth: UITextField!
    
    @IBOutlet weak var txt_fieldPhoneNumber: UITextField!
    
    //MARK:- VARIABLE
    //MARK:
    let WebserviceConnection  = AlmofireWrapper()
    let gradient = Gradient.singletonGradientObj
    var btnAcceptTermsAndConditionState = false
    let genderDropDown = DropDown()
    var btnPasswordState = false
    var btnConfirmPasswordState = false
    var arrayFromPlist:NSMutableArray = NSMutableArray()
    let validation:Validation = Validation.validationManager() as! Validation
    let datePicker = UIDatePicker()
    var UserDataArray :NSMutableArray =  NSMutableArray()
    
    var socialid = ""
    
    var mobileString = ""
    
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
        
        
        // Do any additional setup after loading the view.
    }
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialMethod(){
        
        showDatePicker()
        let signUpButtonGradient = gradient.createBlueGreenGradient(from: btnSignUpRef.bounds)
        self.btnSignUpRef.layer.insertSublayer(signUpButtonGradient, at: 0)
        btnSignUpRef.layer.cornerRadius = 5
        btnSignUpRef.layer.masksToBounds = true
        let text = lblAlreadyHaveAccount.text
        let textRange = NSRange(location: 25, length: 7)
        var attributedText = NSMutableAttributedString(string: text!)
        attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 74.0/255, green: 192.0/255, blue: 194.0/255, alpha: 1.0), range: textRange)
        lblAlreadyHaveAccount.attributedText = attributedText
        
        lblAlreadyHaveAccount.isUserInteractionEnabled = true // Remember to do this
        let tapLblAlreadyHaveAccount: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(lblAlreadyHaveAccountTapped))
        lblAlreadyHaveAccount.addGestureRecognizer(tapLblAlreadyHaveAccount)
        
        
        //        func resendBtnText()->NSAttributedString{
        //
        //            let myMutableString11 = NSMutableAttributedString()
        //            let myMutableString1 = NSAttributedString(string: "Don't receive your code? ", attributes:
        //                [.font:UIFont(name: App.Fonts.Roboto.Regular, size: 15.0)!, .foregroundColor :UIColor.black])
        //            let title = NSAttributedString(string: "Resend Code", attributes:
        //                [.foregroundColor :UIColor(red:0.45, green:0.57, blue:0.90, alpha:1.0),.font:UIFont(name: App.Fonts.Roboto.Medium, size: 15.0)!])
        //            myMutableString11.append(myMutableString1)
        //            myMutableString11.append(title)
        //
        //            return myMutableString11
        //        }
        
        
        
        //++++++++++++++++++++???
        
        
        let myMutableString1 = NSMutableAttributedString()
        let myMutableString2 = NSAttributedString(string: "I accept all the ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        let myMutableString3 = NSAttributedString(string: "Terms and Conditions ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Bold, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        let myMutableString4 = NSAttributedString(string: "and ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        myMutableString1.append(myMutableString4)
        
        
        lblTermsAndCondtions.attributedText = myMutableString1
        
        lblTermsAndCondtions.isUserInteractionEnabled = true // Remember to do this
        let lblAlreadyHaveAccountTap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(lblTermsAndCondtionsTapped))
        lblTermsAndCondtions.addGestureRecognizer(lblAlreadyHaveAccountTap)
        
        
        let myAttributedStringP = NSMutableAttributedString()
        
        let myMutableString5 = NSAttributedString(string: "Privacy Policies ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Bold, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        let myMutableString6 = NSAttributedString(string: "of FameTale ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        
        myAttributedStringP.append(myMutableString5)
        myAttributedStringP.append(myMutableString6)
        
        lblPrivacyPolicy.attributedText = myAttributedStringP
        
        lblPrivacyPolicy.isUserInteractionEnabled = true // Remember to do this
        let lblPrivacyPolicyTap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(lblPrivacyPolicyTapped))
        lblPrivacyPolicy.addGestureRecognizer(lblPrivacyPolicyTap)
        
        
        imagePicker.allowsEditing =  true
        
        if btnAcceptTermsAndConditionState == false{
            btnTermsAndConditionsRef.setImage(#imageLiteral(resourceName: "remember_unselected"), for: .normal)
        }
        else{
            btnTermsAndConditionsRef.setImage(#imageLiteral(resourceName: "remember_selected"), for: .normal)
        }
        
        
    }
    
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = NSDate() as Date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txt_fieldDateOfBirth.inputAccessoryView = toolbar
        // add datepicker to textField
        txt_fieldDateOfBirth.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txt_fieldDateOfBirth.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    
    // MARK:- IMAGEPICKER DELEGATE
    //MARK:-
    
    func openActionSheet() {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func openCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }else {
            
            let alert = UIAlertController(title: "FameTale", message: "You don't have camera", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        
        
        let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        imageData = UIImageJPEGRepresentation(chosenImage!, 0.5) as NSData!
        
        imgViewProfile.image = chosenImage
        
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.size.width/2
        imgViewProfile.clipsToBounds = true
        
        UserDefaults.standard.set(imageData, forKey: "imageData")
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker = UIImagePickerController()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func dataOnSignup(){
        
        if UserDefaults.standard.value(forKey: "imageData") != nil {
            
            let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
            
            
            
            let Passdict = ["username": txtUserFameTale.text!,
                            "name": txtUserName.text!,
                            "phone": txt_fieldPhoneNumber.text!,
                            "gender":txtGender.text!,
                            "dob": txt_fieldDateOfBirth.text!,
                            "password":txtPasswordRef.text!,
                            "password_confirmation":txtConfirmPasswordRef.text!,
                            "deviceType":"ios",
                            "deviceToken":devicetoken,
                            "socialid":"",
                            "country_code":txtCountryCode.text!] as [String : Any]
            print(Passdict)
            
            
            if InternetConnection.internetshared.isConnectedToNetwork() {
                
                UserDefaults.standard.set(Passdict, forKey: "PASSDICT")
                
                
                self.sendOtpUsingFirebase()
                
                
            }else{
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "No internet connection!", style: AlertStyle.error)
                
            }
            
            
        }else{
            
            
            // WHEN No Image Updated
            
            UserDefaults.standard.removeObject(forKey: "imageData")
            
            let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
            
            let Passdict = ["username": txtUserFameTale.text!,
                            "name": txtUserName.text!,
                            "phone": txt_fieldPhoneNumber.text!,
                            "gender":txtGender.text!,
                            "dob": txt_fieldDateOfBirth.text!,
                            "password":txtPasswordRef.text!,
                            "password_confirmation":txtConfirmPasswordRef.text!,
                            "deviceType":"ios",
                            "deviceToken":devicetoken,
                            "socialid":"",
                            "country_code":txtCountryCode.text!] as [String : Any]
            
            print(Passdict)
            
            
            if InternetConnection.internetshared.isConnectedToNetwork() {
                
                UserDefaults.standard.set(Passdict, forKey: "PASSDICT")
                UserDefaults.standard.removeObject(forKey: "imageData")
                
                
                
                self.sendOtpUsingFirebase()
                
                
                
                
                
            }else{
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "No internet connection!", style: AlertStyle.error)
                
            }
            
            
        }
        
        
    }
    
    //TODO:- VALIDATIONS
    
    
    
    func validationForFullName()->Bool{
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: txtUserName.text!, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, txtUserName.text!.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
        
    }
    
    
    
    
    
    
    func validationSetup()->Void{
        
        
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
        
        if !validation.validateBlankField(txtUserFameTale.text!){
            message = "Please enter user name"
        }
        else if !validation.validateBlankField(txtUserName.text!){
            message = "Please enter name"
        }
            
        else if validationForFullName() == true{
            message = "Please enter your valid full name (Full Name contains A-Z or a-z, no special character or digits are allowed.)"
        }
            
        else if !validation.validateBlankField(txt_fieldDateOfBirth.text!){
            message = "Please select date of birth"
        }
        else if !validation.validateBlankField(txtGender.text!){
            message = "Please select gender"
        }
        else if !validation.validateBlankField(txtCountryCode.text!){
            message = "Please select country code"
        }
        else if !validation.validateBlankField(txt_fieldPhoneNumber.text!){
            message = "Please enter phone number"
        }
        else if !validation.validateBlankField(txtPasswordRef.text!){
            message = "Please enter password"
        }
        else if (txtPasswordRef.text!.characters.count < 6 ){
            message = "Password length should be 6-15 characters"
        }
        else if !validation.validateBlankField(txtConfirmPasswordRef.text!){
            message = "Please enter confirm password"
        }
        else if (txtConfirmPasswordRef.text!.characters.count < 6){
            message = "Confirm password length should be 6-15 characters"
        }
            
        else if txtPasswordRef.text! != txtConfirmPasswordRef.text!{
            
            message = "Password and Confirm Pasword is not matching"
            
        }
            
        else if btnAcceptTermsAndConditionState == false{
            message = "Please accept terms & conditions"
        }
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            checkUser()
            
            
        }
        
        
    }
    
    
    
    
    @objc func lblAlreadyHaveAccountTapped(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func lblTermsAndCondtionsTapped(){
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TermsAndConditionsVC") as? TermsAndConditionsVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    @objc func lblPrivacyPolicyTapped(){
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrivacyAndPolicyVC") as? PrivacyAndPolicyVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    //MARK:- ACTION
    //MARK:
    
    
    
    //
    //    @IBAction func btnDateTapped(_ sender: Any) {
    //        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
    //        self.present(vc, animated: true, completion: nil)
    //    }
    //
    
    
    @IBAction func btnCountryCodeTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListTablVc") as! CityListTablVc
        vc.objeCountryListDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnCameraTapped(_ sender: Any) {
        openActionSheet()
    }
    
    
    @IBAction func btnPasswordEyeTapped(_ sender: Any) {
        if (sender as AnyObject).tag == 1{
            if btnPasswordState == false{
                // btnPasswordRef.setImage(, for: .normal)
                txtPasswordRef.isSecureTextEntry = false
                btnPasswordState = !btnPasswordState
            }
            else{
                // btnPasswordRef.setImage(, for: .normal)
                txtPasswordRef.isSecureTextEntry = true
                btnPasswordState = !btnPasswordState
            }
            
        }
        else if (sender as AnyObject).tag == 2{
            if btnConfirmPasswordState == false{
                // btnConfirmPasswordRef.setImage(, for: .normal)
                txtConfirmPasswordRef.isSecureTextEntry = false
                btnConfirmPasswordState = !btnConfirmPasswordState
            }
            else{
                // btnConfirmPasswordRef.setImage(, for: .normal)
                txtConfirmPasswordRef.isSecureTextEntry = true
                btnConfirmPasswordState = !btnConfirmPasswordState
            }
        }
    }
    
    @IBAction func btnGenderDropDownTapped(_ sender: Any) {
        self.genderDropDown.anchorView = viewGender
        genderDropDown.dataSource = ["Male","Female"]
        genderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtGender.text = item
            //            print("Selected item: \(item) at index: \(index)")
        }
        
        genderDropDown.show()
    }
    
    @IBAction func btnTermsAndConditionsTapped(_ sender: Any) {
        btnAcceptTermsAndConditionState = !btnAcceptTermsAndConditionState
        initialMethod()
    }
    
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        
        validationSetup()
    }
}


extension SignUpVC:selectedCountry{
    
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
    
    
    
    
    
    func checkUser() {
        
        
        
        let passDict = ["phone":txt_fieldPhoneNumber.text!,
                        "country_code":txtCountryCode.text!,
                        "username":txtUserFameTale.text!] as! [String : AnyObject]
        
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("check_back", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    
                    
                    
                    self.dataOnSignup()
                    
                    
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
                vc.isComingFrom = "SIGNUP"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    
}








