//
//  PersistRecordsOperation.swift
//  ESTPRecords
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack
import Operations

protocol RecordMapper {
    associatedtype Record
    associatedtype PersistentRecord

    static func update(persistentRecord persistentRecord: PersistentRecord, with record: Record)
    static func insertPersistentRecord(from record: Record, in context: NSManagedObjectContext)
}


class PersistRecordsOperation<PersistentRec: PersistentRecord, Rec: Record, Mapper: RecordMapper where Mapper.Record == Rec, Mapper.PersistentRecord == PersistentRec, Rec: Entity>: ContextOperation {
    var records: [Rec] = []

    override func execute() {
        performBlock { context in
            let records = Set(self.records)
            let deletedRecords = records.filter { $0.deleted }
            self.deletePersistentRecordsDeleted(in: deletedRecords, inContext: context)
            let updatingRecords = self.updatePersistedRecords(with: records.subtract(deletedRecords), inContext: context)
            self.insertPersistedRecords(with: records.subtract(updatingRecords.union(deletedRecords)), inContext: context)
            self.saveContextAndFinish()
        }
    }

    // MARK: - Private

    private func deletePersistentRecordsDeleted(in records: [Rec], inContext context: NSManagedObjectContext) {
        let request = NSFetchRequest(entity: PersistentRec.self)
        request.predicate = NSPredicate(format: "recordName IN %@", records.recordNames())
        let persistentRecords = try! context.executeFetchRequest(request) as! [PersistentRec]
        persistentRecords.forEach { record in
            context.deleteObject(record)
        }
    }

    private func updatePersistedRecords(with records: Set<Rec>, inContext context: NSManagedObjectContext) -> Set<Rec> {
        let request = NSFetchRequest(entity: PersistentRec.self)
        request.predicate = NSPredicate(format: "recordName IN %@", records.recordNames())
        let persistentRecords = try! context.executeFetchRequest(request) as! [PersistentRec]

        var persistentRecordsDict = [String : PersistentRec]()
        persistentRecords.forEach { record in
            persistentRecordsDict[record.recordName] = record
        }

        let persistentRecordRecordNames = Set(persistentRecordsDict.keys)
        let updatingRecords = Set(records.filter { persistentRecordRecordNames.contains($0.record.recordID.recordName) })

        updatingRecords.forEach { record in
            Mapper.update(persistentRecord: persistentRecordsDict[record.record.recordID.recordName]!, with: record)
        }
        return updatingRecords
    }

    private func insertPersistedRecords(with records: Set<Rec>, inContext context: NSManagedObjectContext) {
        records.forEach { record in
            Mapper.insertPersistentRecord(from: record, in: context)
        }
    }

    private func removePersistedRecords(notIn records: [Rec], inContext context: NSManagedObjectContext) {
        let request = NSFetchRequest(entity: PersistentRecord.self)
        request.predicate = NSPredicate(format: "recordName NOT IN %@", records.recordNames())
        let persistentRecords = try! context.executeFetchRequest(request) as! [PersistentRecord]
        persistentRecords.forEach { context.deleteObject($0) }
    }
}

