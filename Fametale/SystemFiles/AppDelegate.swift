//
//  AppDelegate.swift
//  Fametale
//
//  Created by Callsoft on 08/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate,UNUserNotificationCenterDelegate  {
    
    var window: UIWindow?
    var countryArray:NSMutableArray = NSMutableArray()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        UIApplication.shared.isStatusBarHidden = false
        getCountryList()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let simulaterToken = "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        
        UserDefaults.standard.set(simulaterToken as String, forKey: "devicetoken")
        registerForRemoteNotification()
        checkAutoLogin()
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error{
            print("Failed to logged in with Google : ",error)
        }
        print("Successfully loggedIn")
        let name = user.profile.name
        print(name)
        guard let idToken = user.authentication.idToken
            else {return}
        guard let accessToken = user.authentication.accessToken
            else {return}
        
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any
            )
        {
            return true
            
        }
        else if GIDSignIn.sharedInstance().handle(url,
                                                  sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                  annotation: options[UIApplicationOpenURLOptionsKey.annotation]){
            return true
        }
        return true
        
    }
    
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    //MARK:- DEVICE TOKEN GET HERE
    
    
    
    func registerForRemoteNotification() {
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    
                    DispatchQueue.main.async {
                        
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //let characterSet: NSCharacterSet = NSCharacterSet( charactersIn: "<>" )
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        UserDefaults.standard.set(deviceTokenString as String, forKey: "devicetoken")
        
        print("------------dududuudududuududu")
        
        NSLog("Device Token : %@", deviceTokenString)
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        let simulaterToken = "Simulatorb1e2d3bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        UserDefaults.standard.set(simulaterToken, forKey: "devicetoken")
        print(error, terminator: "")
        
        print("---------huhuuhuhuhuuhuh")
        
    }
    
    
    func getCountryList(){
        
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            let list:NSDictionary = CommonMethod.getDictionaryFromXMLFile("country_list_c2call", fileExtension: "xml") as NSDictionary
            
            self.setCountryList(info:list)
            
            
        })
    }
    
    // MARK: read country from xml parser
    
    
    func setCountryList(info:NSDictionary){
        
        let countries: NSDictionary = info.object(forKey: "countries") as! NSDictionary
        let arr_Country: NSArray = countries.object(forKey: "country") as! NSArray
        let arr:NSMutableArray = NSMutableArray()
        
        for i in 0..<arr_Country.count {
            
            let dict:NSDictionary = arr_Country[i] as! NSDictionary
            
            let dictCode = dict.object(forKey: "code") as? NSDictionary
            let text: String = (dictCode?.object(forKey: "text") as? String)!
            let dialing_code: String = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let country_name: String = (dict.object(forKey: "name") as? String)!
            let country_code: String = (dict.object(forKey: "iso") as? String)!
            let country_dailing_code: String = dialing_code
            let info:NSDictionary = ["country_name":country_name,"country_code":country_code,"country_dailing_code":country_dailing_code]
            arr.add(info)
        }
        let descriptor: NSSortDescriptor =  NSSortDescriptor(key: "country_name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let sortedResults: NSArray = (arr.sortedArray(using: [descriptor]) as? NSArray)!
        self.countryArray = NSMutableArray(array: sortedResults)
        //print(self.countryArray)
        
    }
    
    
    func checkAutoLogin()
    {
        
        if UserDefaults.standard.bool(forKey: "isLoginSuccessfully") ==  true {
            
            UserDefaults.standard.set(true, forKey: "isCoimngFront")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            
            
            
            
        }else{
            
            UserDefaults.standard.set(false, forKey: "isCoimngFront")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            
        }
        
        
        
        
        
    }
    
    
    //MARK:  UNNOTIFICATION DELGATE METHODS
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void){
        print("in will present")
        let screen_name  =  ScreeNNameClass.shareScreenInstance.screenName
        if let userInfo = notification.request.content.userInfo as? NSDictionary{
            if let apsDict = userInfo.value(forKey: "aps") as? NSDictionary{
                
                guard let badgeCount = apsDict.value(forKey: "badge") as? Int else{
                    print("No badgeCount")
                    return
                }
                
                if let alertDict = apsDict.value(forKey: "alert") as? NSDictionary{
                    if screen_name == "ProfileVC"{
                        if let type = alertDict.value(forKey: "type") as? String{
                            if type == "commentVideo" || type == "rateVideo" || type == "follow"{
                               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PROFILENOTIFYRELOAD"), object:nil, userInfo: nil)
                            }else{
                              completionHandler([.alert, .badge, .sound])
                            }
                        }
                    }else if screen_name == "Chat2VC"{
                        if let type = alertDict.value(forKey: "type") as? String{
                            if type == "chat"{
                                 print(userInfo)
                                guard let batchDict = apsDict.value(forKey: "batch") as? NSDictionary else{
                                    print("No batchDict")
                                    return
                                }
                                guard let receiver_id = batchDict.value(forKey: "receiver_id") as? String else{
                                    print("No receiver_id")
                                    return
                                }
                                let receiver_idOnScreen  =  ScreeNNameClass.shareScreenInstance.receiver_id
                                print(receiver_idOnScreen)
                                print(receiver_id)
                                if receiver_id == receiver_idOnScreen{
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHATNOTIFYRELOAD"), object:nil, userInfo: nil)
                                }else{
                                    completionHandler([.alert, .badge, .sound])
                                }
                                
                            }else{
                               completionHandler([.alert, .badge, .sound])
                            }
                        }
                        
    
                    }else if screen_name == "NotificationVC"{
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NOTIFICARIONNOTIFYRELOAD"), object:nil, userInfo: nil)
                        
                    }else if screen_name == "ChatVC"{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHATLISTNOTIFYRELOAD"), object:nil, userInfo: nil)
                    }else{
                        completionHandler([.alert, .badge, .sound])
                    }
                }
            }
            print(userInfo)
        }
    }
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        print("in did recieve")
        if UserDefaults.standard.bool(forKey: "isLoginSuccessfully") ==  true {
            if let userInfo = response.notification.request.content.userInfo as? NSDictionary{
                print(userInfo)
                if let apsDict = userInfo.value(forKey: "aps") as? NSDictionary{
                    guard let badgeCount = apsDict.value(forKey: "badge") as? Int else{
                        print("No badgeCount")
                        return
                    }

                    if let alertDict = apsDict.value(forKey: "alert") as? NSDictionary{
                        if let type = alertDict.value(forKey: "type") as? String{
                            if type == "commentVideo" || type == "rateVideo" || type == "follow"{
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let destinationController = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
                                destinationController?.isComing = "NOTI"
                                let navController = UINavigationController(rootViewController: destinationController!)
                                navController.navigationBar.isHidden = true
                                self.window!.rootViewController = navController
                            }else{
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let destinationController = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC
                                let navController = UINavigationController(rootViewController: destinationController!)
                                navController.navigationBar.isHidden = true
                                self.window!.rootViewController = navController
                            }
                        }
                    }
                }
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
            let navController = UINavigationController(rootViewController: destinationController!)
            navController.navigationBar.isHidden = true
            self.window!.rootViewController = navController
        }
    }
}

