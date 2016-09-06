//
//  PersistEventsOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack
import Operations

class PersistEventsOperation: ContextOperation, PersistEventsOperationPrototype {
    var events: [Event] = []
    var completionHandler: (([Event]) -> Void)?

    override func execute() {
        performBlock { context in
            let events = Set(self.events)
            let updatingEvents = self.updatePersistedEvents(with: events, inContext: context)
            self.insertPersistedEvents(with: events.subtract(updatingEvents), inContext: context)
            self.saveContextAndFinish()
        }
    }
    
    // MARK: - Private
    
    private func updatePersistedEvents(with events: Set<Event>, inContext context: NSManagedObjectContext) -> Set<Event> {
        let request = NSFetchRequest(entity: PersistentEvent.self)
        request.predicate = NSPredicate(format: "recordName IN %@", events.map {$0.record.recordID.recordName })
        let persistentEvents = try! context.executeFetchRequest(request) as! [PersistentEvent]

        var persistentEventsDict = [String : PersistentEvent]()
        for event in persistentEvents {
            persistentEventsDict[event.recordName] = event
        }

        let persistentEventRecordNames = Set(persistentEventsDict.keys)
        let updatingEvents = Set(events.filter { persistentEventRecordNames.contains($0.record.recordID.recordName) })

        for event in updatingEvents {
            RecordMapper.updatePersistentEvent(persistentEventsDict[event.record.recordID.recordName]!, with: event)
        }
        return updatingEvents
    }
    
    private func insertPersistedEvents(with events: Set<Event>, inContext context: NSManagedObjectContext) {
        events.forEach { event in
            RecordMapper.insertPersistentEvent(from: event, inContext: context)
        }
    }
    
    private func removePersistedEvents(notIn events: [Event], inContext context: NSManagedObjectContext) {
        let request = NSFetchRequest(entity: PersistentEvent.self)
        request.predicate = NSPredicate(format: "recordName NOT IN %@", events.map {$0.record.recordID.recordName })
        let persistentEvents = try! context.executeFetchRequest(request) as! [PersistentEvent]
        persistentEvents.forEach { context.deleteObject($0) }
    }
}
