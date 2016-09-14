//
//  WeakList.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

private class Wrapper {
    weak var v: AnyObject?
    init(v: AnyObject){
        self.v = v
    }
}

struct WeakList<T>: SequenceType {
    private var array: [Wrapper] = []

    private var list: [T] {
        return array.flatMap { $0.v as? T }
    }

    func generate() -> IndexingGenerator<Array<T>> {
        return list.generate()
    }

    mutating func insert(t: T) {
        guard let v = t as? AnyObject else { return }
        array.append(Wrapper(v: v))
    }
}
