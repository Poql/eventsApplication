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

class EventViewController: SharedViewController, EventPresenterClient, UITableViewDelegate, UITableViewDataSource, SegueHandlerType, ModifyEventViewControllerDelegate {
    
    enum SegueIdentifier: String {
        case addEvent = "ModifyEventViewController"
        case eventDetail = "EventDetailViewController"
    }

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = Constant.rowHeight
            tableView.tableFooterView = UIView()
        }
    }

    private lazy var addEventButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addEventAction(_:)))
    }()
    
    private lazy var eventPresenter: EventPresenter = {
        self.presenterFactory.addClient(self as EventPresenterClient)
        return self.presenterFactory.eventPresenter
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        eventPresenter.queryAllEvents()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifier(forSegue: segue) {
        case .addEvent:
            guard
                let navigationController = segue.destinationViewController as?  UINavigationController,
                let controller = navigationController.topViewController as? ModifyEventViewController else { return }
            controller.event = Event()
            controller.delegate = self
        case .eventDetail:
            guard
                let selectedIndexPath = tableView.indexPathForSelectedRow,
                let controller = segue.destinationViewController as? EventDetailViewController
            else { return }
            controller.event = eventPresenter.event(atIndex: selectedIndexPath)
            controller.delegate = self
        }
    }
    
    // MARK: - Actions

    @objc private func addEventAction(sender: UIBarButtonItem) {
        performSegue(withIdentifier: .addEvent, sender: nil)
    }

    // MARK: - UserStatusUpdateListener

    override func userStatusDidUpdate(userStatus: UserStatus) {
        switch userStatus {
        case .follower:
            navigationItem.rightBarButtonItem = nil
        case .admin:
            navigationItem.rightBarButtonItem = addEventButton
        }
    }

    // MARK: - ModifyEventViewControllerDelegate

    func controller(controller: ModifyEventViewController, didModify event: Event) {
        eventPresenter.modifyEvent(event)
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
            guard
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? EventTableViewCell
                else { return }
                cell.configure(with: eventPresenter.event(atIndex: indexPath))
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

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventPresenter.title(forSection: section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueCell()
        cell.configure(with: eventPresenter.event(atIndex: indexPath))
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventPresenter.numberOfEvents(inSection: section)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventPresenter.numberOfEventSections()
    }
}
