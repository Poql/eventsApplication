//
//  NSUserDefault.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

extension NSUserDefaults {
    func setEntity<T: Coding>(entity: T, forKey key: String) {
        let encoder = Encoder<T>(entity)
        NSKeyedArchiver.setClassName("Encoder\(T.self)", forClass: Encoder<T>.self)
        let data = NSKeyedArchiver.archivedDataWithRootObject(encoder)
        setObject(data, forKey: key)
    }

    func entity<T: Coding>(for key: String) -> T? {
        guard let data = objectForKey(key) as? NSData else { return nil }
        NSKeyedUnarchiver.setClass(Encoder<T>.self, forClassName: "Encoder\(T.self)")
        return (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Encoder<T>)?.entity
    }
}

private class Encoder<T: Coding>: NSObject, NSCoding {

    let entity: T

    init(_ entity: T) {
        self.entity = entity
    }

    @objc required init?(coder aDecoder: NSCoder) {
        self.entity = T.init(dict: aDecoder.decodeObjectForKey("dict") as! [String : AnyObject])
    }

    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(entity.encoded, forKey: "dict")
    }
}
