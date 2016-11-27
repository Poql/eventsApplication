//
//  UITableViewCell + ReusableCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

enum RegistrableView<T: UIView> {
    var identifier: String { return String(T) }
    case fromNib
    case fromClass
}

extension UITableView {
    func registerView<T: UITableViewCell>(view: RegistrableView<T>) {
        switch view {
        case .fromNib:
            let nib = UINib(nibName: view.identifier, bundle: nil)
            registerNib(nib, forCellReuseIdentifier: view.identifier)
        case .fromClass:
            registerClass(T.self, forCellReuseIdentifier: view.identifier)
        }
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>() -> T {
        return dequeueReusableCellWithIdentifier(String(T)) as! T
    }
}

extension UICollectionView {
    func registerView<T: UICollectionViewCell>(view: RegistrableView<T>) {
        switch view {
        case .fromNib:
            let nib = UINib(nibName: view.identifier, bundle: nil)
            registerNib(nib, forCellWithReuseIdentifier: view.identifier)
        case .fromClass:
            registerClass(T.self, forCellWithReuseIdentifier: view.identifier)
        }
    }
}

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(forIndexPath indexPath: NSIndexPath) -> T {
        return dequeueReusableCellWithReuseIdentifier(String(T), forIndexPath: indexPath) as! T
    }
}
