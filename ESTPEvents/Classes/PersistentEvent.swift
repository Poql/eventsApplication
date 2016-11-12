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
    
    var location: Location? {
        set {
            locationTitle = newValue?.title ?? ""
            locationSubtitle = newValue?.subtitle ?? ""
        }
        get {
            guard !locationTitle.isEmpty && !locationSubtitle.isEmpty else { return nil }
            return Location(title: locationTitle, subtitle: locationSubtitle)
        }
    }
    
    static let sectionDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "fr")
        dateFormatter.dateFormat = "EEEE d MMMM"
        return dateFormatter
    }()
    
    var sectionIdentifier: String {
        return self.dynamicType.sectionDateFormatter.stringFromDate(eventDate).capitalizedString
    }
    
    @NSManaged var type: String
    
    @NSManaged var title: String

    @NSManaged var eventDescription: String
    
    @NSManaged var color: String
    
    @NSManaged var creator: String
    
    @NSManaged var eventDate: NSDate
    
    @NSManaged var link: String
    
    @NSManaged var locationTitle: String
    
    @NSManaged var locationSubtitle: String
    
    @NSManaged var notify: Bool

    @NSManaged var cancelled: Bool
}
