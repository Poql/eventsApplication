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

enum EventInfo: Int, Info {
    case modyfingEvent = 0
    case creatingEvent

    var identifier: Int { return self.rawValue }
    var description: String {
        switch self {
        case .modyfingEvent:
            return String(key: "info_modifing_event")
        case .creatingEvent:
            return String(key: "info_creating_event")
        }
    }
}

class EventViewController: SharedViewController, EventPresenterClient, UITableViewDelegate, UITableViewDataSource, SegueHandlerType, ModifyEventViewControllerDelegate, EventModificationListener {
    
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

    weak private var eventDetailViewController: EventDetailViewController?

    private var creatingEvent: Event?

    private let emptyView = EmptyEventView()

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
        eventPresenter.registerListener(self)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        eventDetailViewController = nil
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
            eventDetailViewController = controller
        }
    }
    
    // MARK: - Actions

    @objc private func addEventAction(sender: UIBarButtonItem) {
        performSegue(withIdentifier: .addEvent, sender: nil)
    }

    // MARK: - EventModificationListener

    func presenterDidBeginToModify(event event: Event) {
        guard let currentEvent = creatingEvent where currentEvent == event else { return }
        showBanner(with: EventInfo.creatingEvent)
    }

    func presenterDidModify(event event: Event) {
        guard let currentEvent = creatingEvent where currentEvent == event else { return }
        dismissBannerInfo(EventInfo.creatingEvent)
        creatingEvent = nil
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
        creatingEvent = event
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
            eventDetailViewController?.tryToUpdateEvent(with: eventPresenter.event(atIndex: indexPath))
        case let .move(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath):
            self.tableView.deleteRowsAtIndexPaths([fromIndexPath], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([toIndexPath], withRowAnimation: .Fade)
            eventDetailViewController?.tryToUpdateEvent(with: eventPresenter.event(atIndex: toIndexPath))
        }
    }

    func presenterEventsWillChange() {
        tableView.beginUpdates()
        emptyView.hidden = true
    }
    
    func presenterEventSectionDidChange(eventSectionChange: EntitySectionChange) {
        switch eventSectionChange {
        case let .insert(section):
            tableView.insertSections(NSIndexSet(index: section), withRowAnimation: .Fade)
        case let .delete(section):
            tableView.deleteSections(NSIndexSet(index: section), withRowAnimation: .Fade)
        }
    }

    func presenterWantsToShowLoading() {
        emptyView.hidden = true
    }
    
    func presenterWantsToDismissLoading() {
    }

    func presenterIsEmpty() {
        emptyView.hidden = false
    }

    func presenterWantsToShowError(error: ApplicationError) {
        let controller = eventDetailViewController ?? self
        controller.showAlert(withMessage: error.description, title: String(key: "error_title"))
    }

    func presenterHasValues() {
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    private func setupController() {
        title = String(key: "event_title")
        tableView.backgroundView = emptyView
        emptyView.hidden = true
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
