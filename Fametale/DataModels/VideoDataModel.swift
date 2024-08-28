//
//  VideoDataModel.swift
//  Fametale
//
//  Created by Callsoft on 04/07/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import Foundation
class VideoDataModel{
    
//    "view_count" : "3",
//    "name" : "Anil Sharma",
//    "avg_rating" : "0",
//    "image" : "http:\/\/mobulous.in\/fametales\/public\/users-photos\/5f1efd61e7f55a8.jpg",
//    "thumbnail" : "",
//    "created_at" : "1 day ago",
//    "description" : "bade bhai khatarnaak coder hai",
//    "userId" : "2",
//    "videoId" : "3",
//    "username" : "",
//    "video_name" : "https:\/\/mobulous.in\/fametales\/public\/video-upload\/1539351105.mp4"
    
    var view_count:String?
    var name:String?
    var avg_rating:String?
    var image:String?
    var thumbnail:String?
    var description:String?
    var userId:String?
    var videoId:String?
    var username:String?
    var video_name:String?
    var created_at:String?
    
    init(view_count:String,name:String,avg_rating:String,image:String,thumbnail:String,description:String,userId:String,videoId:String,username:String,video_name:String,created_at:String){
        
        self.view_count = view_count
        self.name = name
        self.avg_rating = avg_rating
        self.image = image
        self.thumbnail = thumbnail
        self.description = description
        self.userId = userId
        self.videoId = videoId
        self.username = username
        self.video_name = video_name
        self.created_at = created_at
        
        
        
        
    }
    
    
    
    
    
    
}
