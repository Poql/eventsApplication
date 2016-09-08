//
//  SubscriptionRepositoryImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

private struct Constant {
    static let eventModificationSubscriptionKey = "EventModificationSubscriptionKey"
    static let notifyUserOnEventCreationSubscriptionKey = "NotifyUserOnEventCreationSubscriptionKey"
}

class SubscriptionRepositoryImplementation: SubscriptionRepository {
    func ensureEventsSubscriptionOperation() -> EnsureSubscriptionOperation<Event> {
        let predicate = NSPredicate.alwaysTrue()
        let options: CKSubscriptionOptions = [.FiresOnRecordCreation, .FiresOnRecordUpdate]
        return EnsureSubscriptionOperation(predicate: predicate, key: Constant.eventModificationSubscriptionKey, options: options)
    }

    func ensureNotifyUserOnEventCreationOperation() -> EnsureSubscriptionOperation<Event> {
        let options: CKSubscriptionOptions = [.FiresOnRecordCreation]
        let predicate = NSPredicate(format: "notify == %i", 1)
        let key = Constant.notifyUserOnEventCreationSubscriptionKey
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertLocalizationKey = "%1$@ : %2$@"
        notificationInfo.alertLocalizationArgs = ["creator", "title"]
        let operation = EnsureSubscriptionOperation<Event>(predicate: predicate, key: key, options: options)
        operation.notificationInfo = notificationInfo
        return operation
    }
    
    func fetchRecordOperation(recordName recordName: String) -> FetchRecordOperation {
        return FetchRecordOperation(recordName: recordName)
    }
}

extension EnsureSubscriptionOperation: EnsureEventModificationSubscriptionOperationPrototype {}
extension EnsureSubscriptionOperation: EnsureNotifyUserOnEventCreationOperationPrototype {}
extension FetchRecordOperation: FetchRecordOperationPrototype {}
