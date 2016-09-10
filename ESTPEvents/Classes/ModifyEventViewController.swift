//
//  ModifyEventViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class ModifyEventViewController: SharedViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    var event: Event?
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

    // MARK: - Private

    private func setupController() {
        title = String(key: "modify_event_title")
    }
    
    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ModifyEventSection.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = ModifyEventSection(rawValue: section) else { return 0 }
        switch section {
        case .preview:
            return ModifyEventPreviewRow.count
        case .creator:
            return ModifyEventCreatorRow.count
        case .detail:
            return ModifyEventDetailRow.count
        case .adjunct:
            return ModifyEventAdjunctRow.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
