//
//  SharedViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class SharedViewController: UIViewController {
    var presenterFactory: PresenterFactory {
        return AppDelegate.shared.presenterFactory
    }
}

