//
//  SignupModel.swift
//  Claas
//
//  Created by DSP on 17/01/18.
//  Copyright © 2018 Mobulous. All rights reserved.


import Foundation
import SwiftyJSON

class SignupModel {

    var name: String?
    var phone: String?
    var dob: String?
    var username: String?
    var gender: String?
    var image:String?
    var is_admin: String?
    var confirmpassword:String?
    var bio:String?
    var created_at:String?
    var updated_at:String?
    var user_id:String?
    var token:String?
    var country_code:String?
    
    init(json: JSON) {
    
        name = json["name"].string
        
        phone = json["phone"].string
        
        dob = json["dob"].string
        
        username = json["username"].string
        
        gender = json["gender"].string
        
        image = json["image"].string
        
        is_admin = json["is_admin"].string
        
        confirmpassword = json["confirmpassword"].string
    
        image = json["image"].string
        
        is_admin = json["is_admin"].string
        
        confirmpassword = json["confirmpassword"].string
        
        bio = json["bio"].string
        
        created_at = json["created_at"].string
        
        updated_at = json["updated_at"].string
        
        token = json["token"].string
        
        country_code = json["country_code"].string
        
    }
}
