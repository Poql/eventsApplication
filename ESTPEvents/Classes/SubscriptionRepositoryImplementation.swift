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
    static let adminModificationSubscriptionKey = "AdminModificationSubscriptionKey"
    static let notifyUserOnAdminValidationKey = "NotifyUserOnAdminValidationKey"

    static let eventModificationSubscriptionKey = "EventModificationSubscriptionKey"
    static let notifyUserOnEventCreationSubscriptionKey = "NotifyUserOnEventCreationSubscriptionKey"
}

class SubscriptionRepositoryImplementation: SubscriptionRepository {

    func ensureAdminModificationSubscriptionOperation() -> AuthenticatedEnsureSubscriptionOperation<Admin> {
        let key = Constant.adminModificationSubscriptionKey
        let options: CKSubscriptionOptions = [.FiresOnRecordUpdate]
        let operation = AuthenticatedEnsureSubscriptionOperation<Admin>(key: key, options: options)
        operation.authenticatedPredicate = { return NSPredicate(format: "userReference == %@", CKReference(recordID: $0, action: .None)) }
        return operation
    }

    func ensureNotifyUserOnAdminValidationOperation() -> AuthenticatedEnsureSubscriptionOperation<Admin> {
        let key = Constant.notifyUserOnAdminValidationKey
        let options: CKSubscriptionOptions = [.FiresOnRecordUpdate]
        let operation = AuthenticatedEnsureSubscriptionOperation<Admin>(key: key, options: options)
        operation.authenticatedPredicate = {
            return NSPredicate(format: "userReference == %@ AND accepted == %i", CKReference(recordID: $0, action: .None), 1)
        }
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertLocalizationKey = "notification_admin_is_accepted_message"
        operation.notificationInfo = notificationInfo
        return operation
    }

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

extension AuthenticatedEnsureSubscriptionOperation: EnsureNotifyUserOnAdminValidationOperationPrototype {}
extension AuthenticatedEnsureSubscriptionOperation: EnsureAdminModificationSubscriptionOperationPrototype {}
extension EnsureSubscriptionOperation: EnsureEventModificationSubscriptionOperationPrototype {}
extension EnsureSubscriptionOperation: EnsureNotifyUserOnEventCreationOperationPrototype {}
extension FetchRecordOperation: FetchRecordOperationPrototype {}
