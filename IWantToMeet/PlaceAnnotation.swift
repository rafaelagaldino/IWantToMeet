//
//  PlaceAnnotation.swift
//  IWantToMeet
//
//  Created by Rafaela Galdino on 14/08/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    enum PlaceType {
        case place
        case poi
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: PlaceType
    var address: String?
    
    init(coordinate: CLLocationCoordinate2D, placeType: PlaceType) {
        self.coordinate = coordinate
        self.type = placeType
    }
}
