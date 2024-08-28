//
//  AboutFametaleScreen.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class AboutFametaleScreen: UIViewController {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var txtViewTermsAndCondition: UITextView!
    
    /////////////////////////////////////////////////////
    
    //MARK: - Variables
    
    let WebserviceConnection = AlmofireWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termsAndConditionsWebService()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    /////////////////////////////////////////////////////
    
    //MARK: - Methods
    
    //TODO: Web servies
    
    
    func termsAndConditionsWebService(){
        
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("aboutcontent", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    
                    let responseDict = responseJson.dictionaryObject as? NSDictionary ?? [:]
                    
                    let dataDict = responseDict.value(forKey: "data") as? NSDictionary ?? [:]
                    
                    print(dataDict)
                    
                    self.txtViewTermsAndCondition.text = dataDict.value(forKey: "description") as? String ?? ""
                    
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
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////
    
    //MARK: - Actions
    @IBAction func btnNavigationTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
