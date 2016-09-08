//
//  NSUserDefault + Subscription.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

private let SubscriptionsUserDefaultKey = "SubscriptionsUserDefaultKey"

extension NSUserDefaults {
    func saveSubscriptionID(subscriptionID: String?, forKey key: String) {
        setObject(subscriptionID, forKey: SubscriptionsUserDefaultKey + key)
        synchronize()
    }

    func getSubscriptionID(forKey key: String) -> String? {
        return objectForKey(SubscriptionsUserDefaultKey + key) as? String
    }
}
