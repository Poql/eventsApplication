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

    static let messageModificationSubscriptionKey = "messageModificationSubscriptionKey"
    static let notifyUserOnMessageCreationSubscriptionKey = "notifyUserOnMessageCreationSubscriptionKey"
}

class SubscriptionRepositoryImplementation: SubscriptionRepository {

    func resetAuthenticatedSubscriptionsKeys() {
        NSUserDefaults.standardUserDefaults().saveSubscriptionID(nil, forKey: Constant.notifyUserOnAdminValidationKey)
        NSUserDefaults.standardUserDefaults().saveSubscriptionID(nil, forKey: Constant.adminModificationSubscriptionKey)
    }

    func ensureAdminModificationSubscriptionOperation() -> AuthenticatedEnsureSubscriptionOperation<Admin> {
        let key = Constant.adminModificationSubscriptionKey
        let options: CKSubscriptionOptions = [.FiresOnRecordUpdate]
        let operation = AuthenticatedEnsureSubscriptionOperation<Admin>(key: key, options: options)
        operation.authenticatedPredicate = { return NSPredicate(format: "userReference == %@", CKReference(recordID: $0, action: .None)) }
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        operation.notificationInfo = notificationInfo
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
        notificationInfo.shouldSendContentAvailable = true
        operation.notificationInfo = notificationInfo
        return operation
    }

    func ensureEventsSubscriptionOperation() -> EnsureSubscriptionOperation<Event> {
        let predicate = NSPredicate.alwaysTrue()
        let options: CKSubscriptionOptions = [.FiresOnRecordCreation, .FiresOnRecordUpdate]
        let key = Constant.eventModificationSubscriptionKey
        let operation = EnsureSubscriptionOperation<Event>(predicate: predicate, key: key, options: options)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        operation.notificationInfo = notificationInfo
        return operation
    }

    func ensureNotifyUserOnEventCreationOperation() -> EnsureSubscriptionOperation<Event> {
        let options: CKSubscriptionOptions = [.FiresOnRecordCreation]
        let predicate = NSPredicate(format: "notify == %i", 1)
        let key = Constant.notifyUserOnEventCreationSubscriptionKey
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertLocalizationKey = "notification_new_event_received_message"
        notificationInfo.alertLocalizationArgs = ["creator", "title"]
        notificationInfo.shouldSendContentAvailable = true
        let operation = EnsureSubscriptionOperation<Event>(predicate: predicate, key: key, options: options)
        operation.notificationInfo = notificationInfo
        return operation
    }
    

    func ensureMessageSubscriptionOperation() -> EnsureSubscriptionOperation<Message> {
        let predicate = NSPredicate.alwaysTrue()
        let options: CKSubscriptionOptions = [.FiresOnRecordCreation, .FiresOnRecordUpdate]
        let key = Constant.messageModificationSubscriptionKey
        let operation = EnsureSubscriptionOperation<Message>(predicate: predicate, key: key, options: options)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertLocalizationKey = "notification_new_message_received_message"
        notificationInfo.alertLocalizationArgs = ["author", "content"]
        notificationInfo.shouldSendContentAvailable = true
        operation.notificationInfo = notificationInfo
        return operation
    }

    func ensureNotifyUserOnMessageCreationOperation() -> EnsureSubscriptionOperation<Message> {
        let options: CKSubscriptionOptions = [.FiresOnRecordCreation]
        let predicate = NSPredicate(format: "notify == %i", 1)
        let key = Constant.notifyUserOnMessageCreationSubscriptionKey
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        let operation = EnsureSubscriptionOperation<Message>(predicate: predicate, key: key, options: options)
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
extension EnsureSubscriptionOperation: EnsureMessageModificationSubscriptionOperationPrototype {}
extension EnsureSubscriptionOperation: EnsureNotifyUserOnMessageCreationOperationPrototype {}
extension FetchRecordOperation: FetchRecordOperationPrototype {}
