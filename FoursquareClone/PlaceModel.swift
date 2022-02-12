//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Ali on 9.02.2022.
//

import Foundation
import UIKit
class PlaceModel  {
    static let sharedInstance = PlaceModel()
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){}
}
