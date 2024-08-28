//
//  EditProfileVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import DropDown
import PKCCrop


class EditProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate  {
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    @IBOutlet weak var btnSafeRef: UIButton!
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblTermAndCodition: UILabel!
    @IBOutlet weak var viewPasswordContainer: UIView!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet weak var txtViewBio: UITextView!
    @IBOutlet weak var txtFieldName: UITextField!
    
    @IBOutlet weak var txtFeildNumber: UITextField!
    @IBOutlet weak var txtFieldDOB: UITextField!
    
    @IBOutlet weak var txtOldPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    //MARK:- VARIABLE
    //MARK:
    let genderDropDown = DropDown()
    var arrayFromPlist:NSMutableArray = NSMutableArray()
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    let WebserviceConnection  = AlmofireWrapper()
    var UserDataArray :NSMutableArray =  NSMutableArray()
    let validation:Validation = Validation.validationManager() as! Validation
    let datePicker = UIDatePicker()
    var token = ""
    let gradient = Gradient.singletonGradientObj
    var bioText = ""
    var phoneNumberString = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    
    var btnChangePasswordState = false
    var fameTaleUserID = ""
    var isComing = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       initialMethod()
        
        
        
        
    }
    
    
    
    
    //MARK:- METHODS
    //MARK:
    func initialMethod(){
        PKCCropHelper.shared.degressBeforeImage = UIImage(named: "pkc_crop_rotate_left.png")
        PKCCropHelper.shared.degressAfterImage = UIImage(named: "pkc_crop_rotate_right.png")
        if isComing == "LOGIN"{
          btnBack.isHidden = true
            btnChangePassword.isUserInteractionEnabled = false
        }else{
           btnBack.isHidden = false
             btnChangePassword.isUserInteractionEnabled = true
        }
        txtFeildNumber.delegate = self
        let saveButtonGradient = gradient.createBlueGreenGradient(from: btnSafeRef.bounds)
        self.btnSafeRef.layer.insertSublayer(saveButtonGradient, at: 0)
        btnSafeRef.layer.cornerRadius = 5
        btnSafeRef.layer.masksToBounds = true
        
        showDatePicker()
        let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        print(TemArray!)
        
        let temdict  =  TemArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String
        fameTaleUserID = userID!
        print(userID!)
        print("USERID AAGAYAI ")
        
       viewUserProfile()
        token = temdict?.value(forKey: "token") as? String ?? ""
        imgViewProfile.sd_setImage(with: URL(string: temdict?.value(forKey: "image") as? String ?? "user_signup"), placeholderImage: UIImage(named: "user_signup"))
        imgViewProfile.layer.masksToBounds = false
        imgViewProfile.clipsToBounds = true
       
        
      
        
        
        imagePicker.allowsEditing =  true
        if btnChangePasswordState == false{
            viewPasswordContainer.isHidden = true
            imgDropDown.image = #imageLiteral(resourceName: "drop_down_edit")
        }
        
    

        
        

        let myMutableString1 = NSMutableAttributedString()
        let myMutableString2 = NSAttributedString(string: "View ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        let myMutableString3 = NSAttributedString(string: "Terms and condition ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Bold, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        let myMutableString4 = NSAttributedString(string: "and ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.darkGray])

        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        myMutableString1.append(myMutableString4)

        
        lblTermAndCodition.attributedText = myMutableString1
        lblTermAndCodition.isUserInteractionEnabled = true // Remember to do this
        let lblAlreadyHaveAccountTap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(lblTermsAndCondtionsTapped))
        lblTermAndCodition.addGestureRecognizer(lblAlreadyHaveAccountTap)
        
          let myAttributedStringP = NSMutableAttributedString()
        
                let myMutableString5 = NSAttributedString(string: "Privacy policy ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Bold, size: 13.0)!, .foregroundColor :UIColor.darkGray])
                let myMutableString6 = NSAttributedString(string: "of FameTale ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        
        
        
                myAttributedStringP.append(myMutableString5)
                myAttributedStringP.append(myMutableString6)
        
        lblPrivacyPolicy.attributedText = myAttributedStringP
        
        lblPrivacyPolicy.isUserInteractionEnabled = true // Remember to do this
        let lblPrivacyPolicyTap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(lblPrivacyPolicyTapped))
        lblPrivacyPolicy.addGestureRecognizer(lblPrivacyPolicyTap)
        
    }
    private func cropAction(){
        let alertController = UIAlertController(title: "", message: "Choose Image", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: UITextFeid delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    
    
    //MARK: UITextViewDelegate delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(self.txtViewBio == textView){
            
            self.txtViewBio.text = bioText
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if(self.txtViewBio == textView){
            
            if self.txtViewBio.text.isEmpty {
                
                self.txtViewBio.text = "Write Your Bio..."
                
                self.txtViewBio.textColor = UIColor.lightGray
            }
            
            
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (self.txtViewBio.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 150
    }
    
    //TODO:- VALIDATIONS
    
    
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
        
        if !validation.validateBlankField(txtOldPassword.text!){
            message = "Please enter old password"
        }
        else if !validation.validateBlankField(txtNewPassword.text!){
            message = "Please enter new password"
        }
        else if (txtNewPassword.text!.characters.count < 6 ){
            message = "Password length should be 6-15 characters"
        }
            
        else if !validation.validateBlankField(txtConfirmPassword.text!){
            message = "Please enter confirm password"
        }
        else if (txtConfirmPassword.text!.characters.count < 6 ){
            message = "Password length should be 6-15 characters"
        }
            
        else if txtConfirmPassword.text! != txtNewPassword.text!{
            
            message = "confirm password must be same"
            
        }
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            callChangePassword()
            
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
    func validationSetup()->Void{
        
        var message = ""
        
        if !validation.validateBlankField(txtFieldName.text!){
            message = "Please enter name"
        }
        else if !validation.validateBlankField(txtFieldDOB.text!){
            message = "Please select date of birth"
        }
        else if !validation.validateBlankField(txtGender.text!){
            message = "Please select gender"
        }
        else if !validation.validateBlankField(txtFeildNumber.text!){
            message = "Please enter phone number"
        }
        
        else if !validation.validateBlankField(txtCountryCode.text!){
            message = "Please enter country code"
        }
       
        if message != "" {
            
            
            _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
            
        }else{
            callApiEditProfile()
            
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
        txtFieldDOB.inputAccessoryView = toolbar
        // add datepicker to textField
        txtFieldDOB.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtFieldDOB.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    @objc func lblPrivacyPolicyTapped(){
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrivacyAndPolicyVC") as? PrivacyAndPolicyVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        imagePicker .dismiss(animated: true, completion: nil)
//
//        let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
//
//        imageData = UIImageJPEGRepresentation(chosenImage!, 0.5) as NSData!
//
//        imgViewProfile.image = chosenImage
//        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.size.width/2
//        imgViewProfile.clipsToBounds = true
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            return
        }
        
        //Converting the Image data and asign its value in PKCDelegate Functions
        
//        imageData = UIImageJPEGRepresentation(image, 0.5) as NSData!
//        UserDefaults.standard.set(imageData, forKey: "imageData")
        PKCCropHelper.shared.isNavigationBarShow = true
        let cropVC = PKCCropViewController(image, tag: 1)
        cropVC.delegate = self
        picker.pushViewController(cropVC, animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         picker.dismiss(animated: true, completion: nil)
//        self.imagePicker = UIImagePickerController()
//        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @objc func lblTermsAndCondtionsTapped(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TermsAndConditionsVC") as? TermsAndConditionsVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    @IBAction func btnCorrectTapped(_ sender: Any) {
//        print(self.phoneNumberString)
//        print(txtFeildNumber.text!)
//
//        if self.phoneNumberString != txtFeildNumber.text!{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VarificationVC") as! VarificationVC
//            vc.isComingFrom = "EDTPROFILE"
//            vc.mobileNumberString = txtFeildNumber.text!
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
        
            validationSetup()
       // }
    }
    
    
    
    @IBAction func btnCountryTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListTablVc") as! CityListTablVc
        vc.objeCountryListDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnCameraTapped(_ sender: Any) {
        
        cropAction()
//        openActionSheet()
    }
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        if (sender as AnyObject).tag == 1{
            
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnGenderTapped(_ sender: Any) {
        self.genderDropDown.anchorView = viewGender
        genderDropDown.dataSource = ["Male","Female"]
        genderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtGender.text = item
            //            print("Selected item: \(item) at index: \(index)")
        }
        
        genderDropDown.show()
    }
    
    
    @IBAction func btnSavePassword(_ sender: Any) {
      
        validationForChangePassword()
        
    }
    
    
    
    @IBAction func btnChangePasswordTapped(_ sender: Any) {
        if btnChangePasswordState == false{
            viewPasswordContainer.isHidden = true
            imgDropDown.image = #imageLiteral(resourceName: "drop_down_edit")
            btnChangePasswordState = !btnChangePasswordState
        }
        else{
            viewPasswordContainer.isHidden = false
            imgDropDown.image = #imageLiteral(resourceName: "drop_up_edit")
            btnChangePasswordState = !btnChangePasswordState
        }
    }
    
    
    
}



//MARK:- EXTENTION COUNTRY CODE
//MARK:
extension EditProfileVC:selectedCountry{
    
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
    
    
    
 
    
    
    //MARK:- WEBSERVICE IMPLEMENTATION
    //MARk:- WEBSERVICE
    
    func callApiEditProfile(){
        
     
        if UserDefaults.standard.value(forKey: "imageData") != nil {
            
            let temPassdict  = UserDefaults.standard.value(forKey: "PASSDICT")
            
            let imagedata  =  UserDefaults.standard.value(forKey: "imageData") as! NSData
            
      
            let Passdict = [
                "name": txtFieldName.text!,
                "phone": txtFeildNumber.text!,
                "dob": txtFieldDOB.text!,
                "token":token,
                "bio":txtViewBio.text!,
                "gender": txtGender.text!,
                "country_code": txtCountryCode.text!
                ] as [String : Any]
            print(Passdict)
            
            
            if InternetConnection.internetshared.isConnectedToNetwork() {
                
                Indicator.shared.showProgressView(self.view)
                
                WebserviceConnection.requWithFile(imageData: imagedata, fileName: "image.jpg", imageparam: "image", urlString:"users/\(self.fameTaleUserID)", parameters: Passdict as [String : AnyObject], headers: nil, success: { (responseJson) in
            
                    print("response JSON")
                   
                    print(responseJson)
                    
                    print("response JSON")
                    
                    let UserData  =  SignupModel(json: responseJson)
                    
                    if responseJson["status"].stringValue == "SUCCESS" {
                        print(responseJson["status"])
                        
                        Indicator.shared.hideProgressView()
                
                        print(responseJson)
                        
                        let  userDict =  responseJson["data"].dictionary!
                        
                        UserData.name =  userDict["name"]?.string ?? ""
                        UserData.phone = userDict["phone"]?.string ?? ""
                        UserData.dob = userDict["dob"]?.string ?? ""
                        UserData.username = userDict["username"]?.string ?? ""
                        UserData.gender = userDict["gender"]?.string ?? ""
                        UserData.image = userDict["image"]?.string ?? ""
                        UserData.is_admin = userDict["is_admin"]?.string ?? ""
                        //UserData.confirmpassword = userDict["confirmpassword"]?.string
                        UserData.bio = userDict["bio"]?.string ?? ""
                        UserData.created_at = userDict["created_at"]?.string ?? ""
                        UserData.updated_at = userDict["updated_at"]?.string ?? ""
                        UserData.user_id = userDict["user_id"]?.string ?? ""
                        //UserData.token = userDict["token"]?.string
                        
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
                                    "user_id":UserData.user_id!] as [String : Any]
                        
                        
                        self.UserDataArray.add(Dict)
                        
                        print(self.UserDataArray)
                        
                        //UserDefaults.standard.set(self.UserDataArray, forKey: "USERINFO")
                        UserDefaults.standard.removeObject(forKey: "imageData")
                        
                        if self.isComing == "LOGIN"{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                            let navController = UINavigationController(rootViewController: vc)
                            navController.navigationBar.isHidden = true
                            self.appDelegate.window?.rootViewController = navController
                            self.appDelegate.window?.makeKeyAndVisible()

                            
                        }else{
                           self.navigationController?.popViewController(animated: true)
                        }
                      
                        
                        
                        
                    }
                    else{
                        
                        print("FAIL")
                        
                        print(responseJson)
                        Indicator.shared.hideProgressView()
                        
                        let message  = responseJson["message"].stringValue
                        
                        if message == "Internal server error."{
                            
                            SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.none, buttonTitle:"OK") { (isOtherButton) -> Void in
                                
                       
                            }
                            
                        }else{
                             Indicator.shared.hideProgressView()
                            _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
                            
                        }
                        
                        
                        
                    }
                    
                    
                }, failure: { (Error) in
                    
                    print("failure")
                      Indicator.shared.hideProgressView()                    //UserDefaults.standard.removeObject(forKey: "imageData")
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                    NotificationCenter.default.removeObserver(self)
                    
                    
                })
                
                
            }else{
                  Indicator.shared.hideProgressView()
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
                NotificationCenter.default.removeObserver(self)
                
            }
            
            
            
        }else{
            
            // WHEN No Image Updated
            
            let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
            print(devicetoken)
            
            let Passdict = [
                "name": txtFieldName.text!,
                "phone": txtFeildNumber.text!,
                "dob": txtFieldDOB.text!,
                "token":token,
                "bio":txtViewBio.text!,
                "gender": txtGender.text!,
                "country_code":txtCountryCode.text!] as [String : Any]
            
             print(Passdict)
            ////:::::::FQVNpX19AnaMxQWJJRw2uT65G
            let temPassdict  = UserDefaults.standard.value(forKey: "PASSDICT")
            
            if InternetConnection.internetshared.isConnectedToNetwork() {
                
                Indicator.shared.showProgressView(self.view)
                
                WebserviceConnection.requestPOSTURL("users/\(self.fameTaleUserID)", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                    let UserData  =  SignupModel(json: responseJson)
                    
                    if responseJson["status"].stringValue == "SUCCESS" {
                        print("SUCCCCCCCC")
                        Indicator.shared.hideProgressView()
                        print(responseJson)
                        
                        let  userDict =  responseJson["data"].dictionary!
                        
                        UserData.name =  userDict["name"]?.string ?? ""
                        UserData.phone = userDict["phone"]?.string ?? ""
                        UserData.dob = userDict["dob"]?.string ?? ""
                        UserData.username = userDict["username"]?.string ?? ""
                        UserData.gender = userDict["gender"]?.string ?? ""
                        UserData.image = userDict["image"]?.string ?? ""
                        UserData.is_admin = userDict["is_admin"]?.string ?? ""
                        //UserData.confirmpassword = userDict["confirmpassword"]?.string
                        UserData.bio = userDict["bio"]?.string ?? ""
                        UserData.created_at = userDict["created_at"]?.string ?? ""
                        UserData.updated_at = userDict["updated_at"]?.string ?? ""
                        UserData.user_id = userDict["user_id"]?.string ?? ""
                        //UserData.token = userDict["token"]?.string
                        
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
                                    "user_id":UserData.user_id!] as [String : Any]
                        
                        
                        self.UserDataArray.add(Dict)
                        
                        print(self.UserDataArray)
                        
                        //UserDefaults.standard.set(self.UserDataArray, forKey: "USERINFO")
                        UserDefaults.standard.removeObject(forKey: "imageData")
                        
    
                        if self.isComing == "LOGIN"{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                            let navController = UINavigationController(rootViewController: vc)
                            navController.navigationBar.isHidden = true
                            self.appDelegate.window?.rootViewController = navController
                            self.appDelegate.window?.makeKeyAndVisible()
                            
                        }else{
                            self.navigationController?.popViewController(animated: true)
                        }
                        //NotificationCenter.default.removeObserver(self)
                        
                    }else{
                        
                        print("FAIL")
                       
                        print(responseJson)
                        let message  = responseJson["message"].stringValue
                        UserDefaults.standard.removeObject(forKey: "imageData")
                        NotificationCenter.default.removeObserver(self)
                        Indicator.shared.hideProgressView()
                        _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
                         Indicator.shared.hideProgressView()
                    }
                    
                    
                },failure: { (Error) in
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                     Indicator.shared.hideProgressView()
                    NotificationCenter.default.removeObserver(self)
                    
                })
                
                
            }else{
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
                NotificationCenter.default.removeObserver(self)
                 Indicator.shared.hideProgressView()
                
            }
            
        }
        
        
    }
    
    
    
    func callChangePassword(){
 
        let Passdict = ["password_old": txtOldPassword.text!,
                        "password_confirmation":txtConfirmPassword.text!,
                        "password":txtConfirmPassword.text!,
                        "token":token] as [String : Any]

print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("users_change_password/\(self.fameTaleUserID)", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in

                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                   
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                    
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
    
    
    
    
    func viewUserProfile(){
        
        
        let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        print(TemArray!)
        
        let temdict  =  TemArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String
        
        print(userID!)
        print("USERID AAGAYAI ")
    
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("users/\(userID!)/\(userID!)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    
                    
                    let  userDict =  responseJson["data"].dictionary!
                    
                   
                    self.txtFieldName.text = userDict["name"]?.string ?? ""
                    self.txtFieldDOB.text = userDict["dob"]?.string ?? ""
                    self.txtGender.text = userDict["gender"]?.string ?? ""
                    self.txtFeildNumber.text = userDict["phone"]?.string ?? ""
                    
                    self.phoneNumberString = userDict["phone"]?.string ?? ""
                    
                   self.bioText = userDict["bio"]?.string ?? ""
                    
                    self.txtViewBio.text = userDict["bio"]?.string ?? ""
                    self.txtViewBio.textColor = UIColor.black
                    self.txtViewBio.delegate = self
                    
                    
                    let image = userDict["image"]?.string ?? ""
                    
                    
                    
                    self.imgViewProfile.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                    
                    
                    
                    print("SUCCESS")
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("Failure")
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong!", style: AlertStyle.error)
                    
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
    
    
    //MARK:- ACTIONS
    @IBAction func btnCountryCodeTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListTablVc") as! CityListTablVc
        vc.objeCountryListDelegate = self
        present(vc, animated: true, completion: nil)
    }
}



//MARK:- PKCROP Delegates
extension EditProfileVC: PKCCropDelegate {
    
    //return Crop Image & Original Image
    func pkcCropImage(_ image: UIImage?, originalImage: UIImage?) {
//        if let image = image{
//            self.weightConstraint.constant = image.size.width
//            self.heightConstraint.constant = image.size.height
//        }
        self.imgViewProfile.image = image
        
                imageData = UIImageJPEGRepresentation(image!, 0.5) as NSData!
                UserDefaults.standard.set(imageData, forKey: "imageData")
                print("THE CROP IMAGE DATA", imageData)
    }
    
    //If crop is canceled
    func pkcCropCancel(_ viewController: PKCCropViewController) {
        
        //   viewController.navigationController?.popViewController(animated: true)
        viewController.dismiss(animated: true, completion: nil)
        
    }
    
    //Successful crop
    func pkcCropComplete(_ viewController: PKCCropViewController) {
        if viewController.tag == 0{
            viewController.navigationController?.popViewController(animated: true)
        }else{
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}


