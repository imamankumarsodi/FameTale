//
//  Gradient.swift
//  Fametale
//
//  Created by Callsoft on 09/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import Foundation
import UIKit
class Gradient{
    
    static let singletonGradientObj = Gradient()
    func createBlueGreenGradient(from bounds: CGRect) -> CAGradientLayer{
        let topColor = UIColor(red: 74.0/255, green: 192.0/255, blue: 194.0/255, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 63.0/255, green: 80.0/255, blue: 131.0/255, alpha: 1.0).cgColor
        let gradientColors = [topColor, bottomColor]
        
        let gradientLocations: [NSNumber] = [0.0, 1.0]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        //Set startPoint and endPoint property also
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = bounds
        gradientLayer.name = "masklayer"
        return gradientLayer
    }
}


