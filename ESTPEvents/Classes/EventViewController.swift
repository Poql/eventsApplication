//
//  EventViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class EventViewController: SharedViewController, EventPresenterClient, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var presenterFactory: PresenterFactory?
    
    private lazy var eventPresenter: EventPresenter? = {
        self.presenterFactory?.addClient(self as EventPresenterClient)
        return self.presenterFactory?.eventPresenter
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventPresenter?.queryAllEvents()
    }
    
    // MARK: - EventPresenterClient
    
    func presenterDidQueryEvents() {
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = eventPresenter?.events[indexPath.row].description
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventPresenter?.events.count ?? 0
    }
}
