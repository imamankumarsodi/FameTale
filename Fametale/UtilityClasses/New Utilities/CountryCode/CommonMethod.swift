//
//  Common.swift

//  Created by Saurabh on 11/24/15.
//  Copyright © 2017 Mobulous. All rights reserved.
//
import CoreLocation
import CoreData
import UIKit


class CommonMethod: NSObject {
    
    
    
    class func appDelegate()->AppDelegate{
        
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    class func getDictionaryFromXMLFile(_ filename: String, fileExtension `extension`: String) -> [AnyHashable: Any] {

        let configFileURL: URL? = Bundle.main.url(forResource: filename, withExtension: `extension`)
        let xmlString = try? String(contentsOf: configFileURL!, encoding: String.Encoding.utf8)
        let xmlDoc: [AnyHashable: Any]? = try? XMLReader.dictionary(forXMLString: xmlString)
        return xmlDoc!
    }
 
}



