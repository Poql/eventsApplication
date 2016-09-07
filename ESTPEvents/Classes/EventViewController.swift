//
//  EventViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let rowHeight: CGFloat = 100
}

class EventViewController: SharedViewController, EventPresenterClient, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = Constant.rowHeight
            tableView.tableFooterView = UIView()
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
        setupController()
        eventPresenter?.queryAllEvents()
    }
    
    // MARK: - EventPresenterClient
    
    func presenterEventsDidChange() {
        tableView.endUpdates()
    }

    func presenterEventDidChange(eventChange: EntityChange) {
        switch eventChange {
        case let .insert(indexPath: indexPath):
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case let .delete(indexPath: indexPath):
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case let .update(indexPath: indexPath):
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                cell.textLabel?.text = eventPresenter?.event(atIndex: indexPath).description
            }
        case let .move(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath):
            self.tableView.deleteRowsAtIndexPaths([fromIndexPath], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([toIndexPath], withRowAnimation: .Fade)
        }
    }

    func presenterEventsWillChange() {
        tableView.beginUpdates()
    }
    
    func presenterEventSectionDidChange(eventSectionChange: EntitySectionChange) {
        switch eventSectionChange {
        case let .insert(section):
            tableView.insertSections(NSIndexSet(index: section), withRowAnimation: .Fade)
        case let .delete(section):
            tableView.deleteSections(NSIndexSet(index: section), withRowAnimation: .Fade)
        }
    }
    
    func presenterDidChangeState(state: PresenterState<ApplicationError>) {
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    private func setupController() {
        title = String(key: "event_title")
        automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventPresenter?.title(forSection: section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueCell()
        if let event = eventPresenter?.event(atIndex: indexPath) {
            cell.configure(with: event)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventPresenter?.numberOfEvents(inSection: section) ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventPresenter?.numberOfEventSections() ?? 0
    }
}
