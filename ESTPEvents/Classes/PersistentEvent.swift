//
//  PersistentEvent.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import BNRCoreDataStack

class PersistentEvent: PersistentRecord {
    override class var entityName: String {
        return "PersistentEvent"
    }
    
    var location: CLLocation? {
        set {
            locationLongitude = newValue?.coordinate.longitude ?? 200
            locationLatitude = newValue?.coordinate.latitude ?? 200
        }
        get {
            guard locationLongitude <= 180 && locationLatitude <= 180 else { return nil }
            return CLLocation(latitude: locationLatitude, longitude: locationLongitude)
        }
    }
    
    @NSManaged var type: String
    
    @NSManaged var title: String

    @NSManaged var eventDescription: String
    
    @NSManaged var color: String
    
    @NSManaged var creator: String
    
    @NSManaged var eventDate: NSDate
    
    @NSManaged var link: String
    
    @NSManaged var locationLatitude: Double
    
    @NSManaged var locationLongitude: Double
    
    @NSManaged var notify: Bool

    @NSManaged var cancelled: Bool
}
