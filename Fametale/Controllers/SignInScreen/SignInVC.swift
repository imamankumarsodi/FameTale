//
//  SignInScreen.swift
//  Fametale
//
//  Created by Callsoft on 08/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import InstagramKit
import InstagramLogin

class SignInVC: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate {
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var txtfiled_password: UITextField!
    @IBOutlet weak var txtfiled_UserIdField: UITextField!
    @IBOutlet weak var btnRememberMe: UIButton!
    @IBOutlet weak var btnSignInRef: UIButton!
    @IBOutlet weak var lblNewToFametale: UILabel!
    @IBOutlet weak var lblForgotPassword: UILabel!
    
    //MARK:- Animation Outlets
    //MARK:
    @IBOutlet weak var lblSignIn: UILabel!
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var viewUnderLine: UIView!
    @IBOutlet weak var imgUserImge: UIImageView!
    @IBOutlet weak var viewUserPassword: UIView!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var viewUnderLinePass: UIView!
    @IBOutlet weak var lblRemember: UILabel!
    @IBOutlet weak var lblSign: UILabel!
    @IBOutlet weak var btnFaceBook: UIButton!
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    
    //MARK:- VARIABLES
    //MARK:
    let validation:Validation = Validation.validationManager() as! Validation
    var instagramLogin: InstagramLoginViewController!
    let clientId = "60ce5c6d6dd84934bc3340e6725d43b7"
    let redirectUri = "http://www.mobulous.com"
    let gradient = Gradient.singletonGradientObj
    let alert = SweetAlert()
    let WebserviceConnection  = AlmofireWrapper()
    var UserDataArray :NSMutableArray =  NSMutableArray()
    var btnRememberMeState = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //****variables for social login
    var socialName = ""
    var socialAliasName = ""
    var socialPhoneNumber = ""
    var socialEmailId = ""
    var socialGender = ""
    
    
    var socialLoginGmail = ["userId" : "user.userID","idToken" : "user.authentication.idToken","fullName" : "user.profile.name","givenName" : "user.profile.givenName","familyName" : "user.profile.familyName","email" : "user.profile.email"]
    
    var socialLoginFB = ["id","name","first_name","last_name","picture.type(large)","email" ]
    var dict : [String : AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        //        fadedEffectOnView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- METHODS
    //MARK:
    func initialSetup(){
        
                fadedEffectOnView()
        
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName as! String)
            print("Font Names = [\(names)]")
        }
        
        
        if UserDefaults.standard.value(forKey: "REMEBER_STS") != nil{
            print("do nothing")
        }else{
            
            UserDefaults.standard.set(btnRememberMeState, forKey: "REMEBER_STS")
        }
        
        
        let btnRemState =  UserDefaults.standard.value(forKey: "REMEBER_STS") as? Bool ?? false
        let email =  UserDefaults.standard.value(forKey: "REMEMBERME_EMAIL") as? String ?? ""
        let password =  UserDefaults.standard.value(forKey: "REMEMBERME_PASSWORD") as? String ?? ""
        
        
        if btnRemState == true {
            
            btnRememberMe.setImage(#imageLiteral(resourceName: "remember_selected"), for: .normal)
            txtfiled_UserIdField.text = email
            txtfiled_password.text = password
            
        }else{
            
            btnRememberMe.setImage(#imageLiteral(resourceName: "remember_unselected"), for: .normal)
        }
        
        
        let signInButtonGradient = gradient.createBlueGreenGradient(from: btnSignInRef.bounds)
        self.btnSignInRef.layer.insertSublayer(signInButtonGradient, at: 0)
        btnSignInRef.layer.cornerRadius = 5
        btnSignInRef.layer.masksToBounds = true
        
        let text = lblNewToFametale.text
        let textRange = NSRange(location: 17, length: 7)
        var attributedText = NSMutableAttributedString(string: text!)
        attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 74.0/255, green: 192.0/255, blue: 194.0/255, alpha: 1.0), range: textRange)
        lblNewToFametale.attributedText = attributedText
        
        
        lblNewToFametale.isUserInteractionEnabled = true // Remember to do this
        let tapLblNewToFametale: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(newtoFametale))
        lblNewToFametale.addGestureRecognizer(tapLblNewToFametale)
        
        lblForgotPassword.isUserInteractionEnabled = true // Remember to do this
        let tapLblForgotPassword: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(forgotPassword))
        lblForgotPassword.addGestureRecognizer(tapLblForgotPassword)
    }
    
    
    func rememberPassword(){
        
        guard let btnRememberMeState = UserDefaults.standard.value(forKey: "REMEBER_STS") as? Bool else{return}
        if btnRememberMeState == true{
            btnRememberMe.setImage(#imageLiteral(resourceName: "remember_selected"), for: .normal)
            let txtfiled_UserIdFieldRem = txtfiled_UserIdField.text ?? ""
            let txtfiled_passwordRem =  txtfiled_password.text ?? ""
            UserDefaults.standard.set(txtfiled_UserIdFieldRem, forKey: "REMEMBERME_EMAIL")
            UserDefaults.standard.set(txtfiled_passwordRem, forKey: "REMEMBERME_PASSWORD")
            
            
        }else{
            
             btnRememberMe.setImage(#imageLiteral(resourceName: "remember_unselected"), for: .normal)
            UserDefaults.standard.removeObject(forKey: "REMEMBERME_EMAIL")
            UserDefaults.standard.removeObject(forKey: "REMEMBERME_PASSWORD")
            
        }
    }
    
    
    
    
    func Gmail(){
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func getFBUserData(){
        
        
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    
                    
                    let pictureData = self.dict["picture"]!.value(forKey: "data")! as? NSDictionary ?? [:]
                    let pictureUrl = pictureData.value(forKey: "url")
                    
                    let theProfileImageUrl:URL! = URL(string: pictureUrl as! String)
                    
                    
                    do{
                        let imageData =   try NSData(contentsOf: theProfileImageUrl as URL)
                        
                        UserDefaults.standard.set(imageData, forKey: "imageData")
                        
                    }
                    catch{
                        print(error)
                    }
                    if let name = self.dict["name"]{
                        print(name)
                        self.socialName = "\(name)"
                    }
                    if let nickName = self.dict["last_name"]{
                        print(nickName)
                        self.socialAliasName = "\(nickName)"
                    }
                    if let email = self.dict["email"]{
                        print(email)
                        self.socialEmailId = "\(email)"
                        
                    }
                    
                    if let fbID = self.dict["id"]{
                        print(fbID)
                        
                        UserDefaults.standard.set("\(fbID)", forKey: "SocialID")
                        
                    }
                    UserDefaults.standard.set(self.dict, forKey: "socialData")
                    self.apiCallForSocialLogin()
                    

                    
                }
            })
        }
        
        let params = ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]
        
        
        let request = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params, httpMethod: "GET")
        
        request?.start(completionHandler: { (connection, result, error) in
            if error != nil{
                print(error?.localizedDescription)
                
            }else{
                print(result)
            }
        })
        
        
        
    }
    
    
    //TODO:- VALIDATION METHOD
    //
    func validationSetup()->Void{
        
        var message = ""
        
        // var tempString = txtfiled_UserIdField.text ?? ""
        
        if !validation.validateBlankField(txtfiled_UserIdField.text!){
            
            message = "Enter your Username/ Phone number"
            
        }
            
        else if !validation.validateBlankField(txtfiled_password.text!){
            message = "Enter your password"
        }
        
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            callApiLogin()
            
        }
        
        
        
        
    }
    
    
    
    @objc func newtoFametale(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func forgotPassword(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK:- ACTIONS
    //MARK:
    
    
    @IBAction func btnRememberMeTapped(_ sender: Any) {
        
        
        if btnRememberMeState == false{
            
            btnRememberMe.setImage(#imageLiteral(resourceName: "remember_selected"), for: .normal)
            btnRememberMeState =  true
            UserDefaults.standard.set(btnRememberMeState, forKey: "REMEBER_STS")
            
            
        }else {
            
            btnRememberMe.setImage(#imageLiteral(resourceName: "remember_unselected"), for: .normal)
            UserDefaults.standard.removeObject(forKey: "REMEMBERME_EMAIL")
            UserDefaults.standard.removeObject(forKey: "REMEMBERME_PASSWORD")
            btnRememberMeState = false
            UserDefaults.standard.set(btnRememberMeState, forKey: "REMEBER_STS")
            
        }
        
    }
    
    @IBAction func btnSignInTapped(_ sender: Any) {
        
        
        validationSetup()
        
        
    }
    
    @IBAction func btnFBLoginTapped(_ sender: Any) {
        
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
        
        
        
    }
    
    @IBAction func btnInstaLoginTapped(_ sender: Any) {
        
        
        loginWithInstagram()
        
    }
    
    @IBAction func btnGoogleLoginTapped(_ sender: Any) {
        Gmail()
        
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil{
            print(error ?? "google error")
            return
        }
            
        else {
            
            
            
            
            print(user)
            
            print("\(user.userID)")
            print("\(user.authentication.idToken)")
            print("\(user.profile.name)")
            print("\(user.profile.givenName)")
            print("\(user.profile.familyName)")
            print("\(user.profile.email)")
            
            self.socialName = "\(user.profile.name!)"
            self.socialEmailId = "\(user.profile.email!)"
            self.socialAliasName = "\(user.profile.familyName!)"
            
            let profilePicURL = user.profile.imageURL(withDimension: 200).absoluteString
            
            let theProfileImageUrl:URL! = URL(string:profilePicURL as! String)
            
            do{
                let imageData =   try NSData(contentsOf: theProfileImageUrl as URL)
                print(imageData)
                UserDefaults.standard.set(imageData, forKey: "imageData")
            }
            catch{
                print(error)
            }
            
            print(profilePicURL)
            
            
            
            
            UserDefaults.standard.set("\(user.userID!)", forKey: "SocialID")
            
            self.dict = ["name": socialName,
                         "email":socialEmailId,
                         "id":user.userID!] as [String : AnyObject]
            UserDefaults.standard.set(self.dict, forKey: "socialData")
            print(self.dict)
            
            self.apiCallForSocialLogin()
            
            
        }
    }
    
    
    
    
}


//MARK:- EXTENSION WEBSERVICES
//MARK:

extension SignInVC{
    
}




//MARK:- EXTENSION INSTAGRAM LOGIN
//MARK:
extension SignInVC: InstagramLoginViewControllerDelegate{
    
    func loginWithInstagram() {
        
        instagramLogin = InstagramLoginViewController(clientId: clientId, redirectUri: redirectUri)
        instagramLogin.delegate = self
        instagramLogin.scopes = [.all]
        instagramLogin.title = "Instagram"
        instagramLogin.progressViewTintColor = .blue
        
        instagramLogin.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissLoginViewController))
        
        present(UINavigationController(rootViewController: instagramLogin), animated: true)
        
        
    }
    
    
    @objc func  dismissLoginViewController(){
        
        self.instagramLogin.dismiss(animated: true, completion: nil)
        
    }
    
    func instagramLoginDidFinish(accessToken: String?, error: InstagramError?) {
        
        print(accessToken)
        
        //instaApiCall(accessToken: accessToken!)
        
        dismissLoginViewController()
        
    }
    
    
    
    //    func instaApiCall(accessToken:String){
    //
    //        ServiceClassMethods.AlamoRequest(method: "GET", serviceString: AppConstants.kinstaURL
    //            + accessToken, parameters: [:], completion: { (dic) in
    //                print("Response Data :\n\(dic)")
    //
    //                if let responseDic = dic.object(forKey: "data") as? NSDictionary{
    //
    //
    //                    let fullName = responseDic.object(forKey: "full_name") as? String ?? ""
    //                    let uniqueId = responseDic.object(forKey: "id") as? String ?? ""
    //                    let imageUrlForSocial = responseDic.object(forKey: "profile_picture") as? String ?? ""
    //                    let url1 = URL(string: imageUrlForSocial as String)
    //
    //                    if url1 != nil{
    //
    //                        self.imageData = NSData(contentsOf: url1!)
    //
    //                    }
    //                    self.socialLoginApiCall(fullname: fullName, email: "", phone: "", postcode: "", imageData: self.imageData, type: "google", Fbid: "", twitterID: "", instaID: uniqueId)
    //                }
    //        })
    //    }
    
    
    
    
    
    
    //MARK:- WEBSERVICE IMPLEMENTATION
    //MARk:- WEBSERVICE
    
    func callApiLogin(){
        
        let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        
        
        let Passdict = ["username": txtfiled_UserIdField.text!,
                        "password":txtfiled_password.text!,
                        "deviceType":"ios",
                        "deviceToken":devicetoken] as [String : Any]
        
        print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("login", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                
                
                let UserData  =  SignupModel(json: responseJson)
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    self.rememberPassword()
                    let  userDict =  responseJson["data"].dictionary!
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
                    UserDefaults.standard.removeObject(forKey: "imageData")
                    
                    UserDefaults.standard.set(true, forKey: "isLoginSuccessfully")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                    let navController = UINavigationController(rootViewController: vc)
                    navController.navigationBar.isHidden = true
                    self.appDelegate.window?.rootViewController = navController
                    self.appDelegate.window?.makeKeyAndVisible()
                    
                    
                    
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
            
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    //TODO:-API CALL FOR SOCIAL LOGIN
    
    func apiCallForSocialLogin(){
        
        
        let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        let socialId = UserDefaults.standard.value(forKey: "SocialID") as? String ?? ""
        
        let Passdict = ["socialid": socialId,
                        "deviceType":"ios",
                        "deviceToken":devicetoken] as [String : Any]
        
        print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("social_login", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    
                    let  userDict =  responseJson["data"].dictionary!
                    
                    if let status = userDict["status"] {
                        
                        if status == "0"{
                            
                            self.signUPApi()
                            
                            // WHEn first time user ko firebase mei register karoghay
                            
                        }else{
                            
                            let UserData  =  SignupModel(json: responseJson)
                            let  userDict =  responseJson["data"].dictionary!
                            
                            
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
                            
                            
                        }
                        
                    }else{
                        
                        // DO NOTHING
                    }
                    
                    
                }else{
                    
                    Indicator.shared.hideProgressView()
                    
                    let message  = responseJson["message"].stringValue
                    
                    print("FAILUERE")
                    print(responseJson)
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
                    
                    
                }
                
                
            },failure: { (Error) in
                
                Indicator.shared.hideProgressView()
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    
    
    
    
    //MARK: WEBSERVICE IMPLEMENTATION
    
    @objc func signUPApi(){
        
        if UserDefaults.standard.value(forKey: "imageData") != nil {
            
            let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
            
            let temPassdict  = UserDefaults.standard.value(forKey: "PASSDICT")
            
            let imagedata  =  UserDefaults.standard.value(forKey: "imageData") as! NSData
            
            
            let socialDict = UserDefaults.standard.value(forKey: "socialData") as? NSDictionary ?? [:]
            
            print(socialDict)
            
            
            
            
            
            
            let Passdict = ["name": socialDict.object(forKey: "name")!,
                            "phone": socialDict.object(forKey: "phone") as? String ?? "",
                            "country_code":"",
                            "gender": "",
                            "deviceType": "ios",
                            "deviceToken": devicetoken,
                            "dob": "",
                            "password": "",
                            "password_confirmation": "",
                            "username": "",
                            "socialid": socialDict.object(forKey: "id")!] as [String : Any]
            
            print(Passdict)
            
            if InternetConnection.internetshared.isConnectedToNetwork() {
                
                Indicator.shared.showProgressView(self.view)
                
                WebserviceConnection.requWithFile(imageData: imagedata, fileName: "image.jpg", imageparam: "image", urlString:"users", parameters: Passdict as [String : AnyObject], headers: nil, success: { (responseJson) in
                    Indicator.shared.hideProgressView()
                    
                    
                    if responseJson["status"].stringValue == "SUCCESS" {
                        
                        Indicator.shared.hideProgressView()
                        print("SUCCESS")
                        let UserData  =  SignupModel(json: responseJson)
                        let  userDict =  responseJson["data"].dictionary!
                        
                        
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
                        UserDefaults.standard.removeObject(forKey: "imageData")
                        
                        /// SEND TO HOME
                        
                        UserDefaults.standard.set(true, forKey: "isLoginSuccessfully")
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                        vc.isComing = "LOGIN"
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//                        let navController = UINavigationController(rootViewController: vc)
//                        navController.navigationBar.isHidden = true
//                        self.appDelegate.window?.rootViewController = navController
//                        self.appDelegate.window?.makeKeyAndVisible()
                        
                        
                        
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
            
            
            
            //print(temPassdict!)
            
            if InternetConnection.internetshared.isConnectedToNetwork() {
                
                Indicator.shared.showProgressView(self.view)
                
                // WHEN No Image Updated
                //let temPassdict  = UserDefaults.standard.value(forKey: "PASSDICT")
                let socialDict = UserDefaults.standard.value(forKey: "socialData") as? NSDictionary ?? [:]
                let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
                let Passdict = ["name": socialDict.object(forKey: "name")!,
                                "phone": socialDict.object(forKey: "phone") as? String ?? "",
                                "country_code":"",
                                "gender": "",
                                "deviceType": "ios",
                                "deviceToken": devicetoken,
                                "dob": "",
                                "password": "",
                                "password_confirmation": "",
                                "username": "",
                                "socialid": socialDict.object(forKey: "id")!] as [String : Any]
                print(Passdict)
                
                WebserviceConnection.requestPOSTURL("users", params: Passdict as? [String : AnyObject], headers:nil, success: { (responseJson) in
                    
                    if responseJson["status"].stringValue == "SUCCESS" {
                        
                        Indicator.shared.hideProgressView()
                        
                        let UserData  =  SignupModel(json: responseJson)
                        let  userDict =  responseJson["data"].dictionary!
                        
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
                        UserDefaults.standard.removeObject(forKey: "imageData")
                        
                        UserDefaults.standard.set(true, forKey: "isLoginSuccessfully")
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                        
                        
                        print("RESPONSE JSON")
                        
                        
                    }else{
                        
                        print("RESPONSE JSON")
                        print(responseJson)
                        print("RESPONSE JSON")
                        
                        
                        _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong!", style: AlertStyle.error)
                        
                    }
                    
                    
                },failure: { (Error) in
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                    
                    Indicator.shared.hideProgressView()
                })
                
                
            }else{
                
                _ = SweetAlert().showAlert("Claas", subTitle: "No interter connection!", style: AlertStyle.error)
                
                Indicator.shared.hideProgressView()
            }
            
            
            
            
        }
        
        
    }
    
    
    
}



//MARK: EXTENSION
//MARK:-


extension String {
    
    var isNumeric: Bool {
        
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
        
    }
}



//MARK: - Extention Animaitons

extension SignInVC{
    
    
    
    func fadedEffectOnView() {
        
        //for IMAGE LOGO. Sliding from right
        self.logoImg.transform = CGAffineTransform(translationX: -400, y: 0)
        UIView.animate(withDuration: 1.5) {
            self.logoImg.transform = CGAffineTransform.identity
        }
        
        //for login Label Dropping from Top
        self.lblSignIn.transform = CGAffineTransform(translationX: 0, y: -400)
        UIView.animate(withDuration: 2.0) {
            self.lblSignIn.transform = CGAffineTransform.identity
        }
        
        self.viewUserName.fadeOutImmidiatlyWithoutshowingEffect()
        self.viewUserPassword.fadeOutImmidiatlyWithoutshowingEffect()
        self.viewUnderLine.fadeOutImmidiatlyWithoutshowingEffect()
        self.imgUserImge.fadeOutImmidiatlyWithoutshowingEffect()
        self.imgPassword.fadeOutImmidiatlyWithoutshowingEffect()
        self.viewUnderLinePass.fadeOutImmidiatlyWithoutshowingEffect()
        self.lblRemember.fadeOutImmidiatlyWithoutshowingEffect()
        self.lblSign.fadeOutImmidiatlyWithoutshowingEffect()
        self.btnFaceBook.fadeOutImmidiatlyWithoutshowingEffect()
        self.btnInsta.fadeOutImmidiatlyWithoutshowingEffect()
        self.btnGoogle.fadeOutImmidiatlyWithoutshowingEffect()
        self.btnRememberMe.fadeOutImmidiatlyWithoutshowingEffect()
        self.lblNewToFametale.fadeOutImmidiatlyWithoutshowingEffect()
        self.lblForgotPassword.fadeOutImmidiatlyWithoutshowingEffect()
        self.btnSignInRef.fadeOutImmidiatlyWithoutshowingEffect()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.viewUserName.fadeIn()
            self.viewUserPassword.fadeIn()
            self.viewUnderLine.fadeIn()
            self.imgUserImge.fadeIn()
            self.imgPassword.fadeIn()
            self.viewUnderLinePass.fadeIn()
            self.lblRemember.fadeIn()
            self.lblSign.fadeIn()
            self.btnFaceBook.fadeIn()
            self.btnInsta.fadeIn()
            self.btnGoogle.fadeIn()
            self.btnRememberMe.fadeIn()
            self.lblNewToFametale.fadeIn()
            self.lblForgotPassword.fadeIn()
            self.btnSignInRef.fadeIn()
        }
    }
    
    
    
}


