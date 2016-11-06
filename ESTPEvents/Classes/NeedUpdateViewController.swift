//
//  NeedUpdateViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 05/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class NeedUpdateViewController: SharedViewController {
    @IBOutlet var validButton: UIButton!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var subtitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

    // MARK: - Private

    private func setupController() {
        titleLabel.text = String(key: "need_update_title")
        subtitleLabel.text = String(key: "need_update_subtitle")
        validButton.setTitle(String(key: "need_update_agree_button"), forState: .Normal)
    }

    @IBAction func validButtonAction(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
