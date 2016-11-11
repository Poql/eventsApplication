//
//  EventViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let rowHeight: CGFloat = 120
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

    @IBOutlet var tableView: UITableView!

    @IBOutlet var addButton: UIBarButtonItem!

    weak private var eventDetailViewController: EventDetailViewController?

    private var creatingEvent: Event?

    private lazy var emptyView: UIView = {
        let view = EmptyView()
        view.configure(title: String(key: "empty_event_title_label"), subtitle: String(key: "empty_event_subtitle_label"))
        return view
    }()

    private lazy var eventPresenter: EventPresenter = {
        self.presenterFactory.addClient(self as EventPresenterClient)
        return self.presenterFactory.eventPresenter
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupTableView()
        eventPresenter.queryAllEvents()
        eventPresenter.registerListener(self)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        eventDetailViewController = nil
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = String(key: "event_title")
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = nil
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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

    @IBAction func addEventAction(sender: UIBarButtonItem) {
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
            navigationItem.rightBarButtonItem = addButton
        }
    }

    // MARK: - ModifyEventViewControllerDelegate

    func controller(controller: ModifyEventViewController, didModify event: Event) {
        creatingEvent = event
        eventPresenter.modifyEvent(event)
    }

    // MARK: - EventPresenterClient

    func eventPresenterWantsToShowLoading() {}

    func eventPresenterDidFill() {
        tableView.reloadData()
    }

    func eventPresenterIsEmpty() {
        emptyView.hidden = false
    }

    func eventPresenterDidChange() {
        tableView.endUpdates()
    }

    func eventPresenterWillChange() {
        tableView.beginUpdates()
        emptyView.hidden = true
    }

    func eventPresenterWantsToShowError(error: ApplicationError) {
        let controller = eventDetailViewController ?? self
        controller.showAlert(withMessage: error.description, title: String(key: "error_title"))
    }

    func eventPresenterDidChange(eventChange: EntityChange) {
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

    func eventPresenterSectionDidChange(eventSectionChange: EntitySectionChange) {
        switch eventSectionChange {
        case let .insert(section):
            tableView.insertSections(NSIndexSet(index: section), withRowAnimation: .Fade)
        case let .delete(section):
            tableView.deleteSections(NSIndexSet(index: section), withRowAnimation: .Fade)
        }
    }

    // MARK: - Private
    
    private func setupController() {
        view.backgroundColor = UIColor.darkGrey()
        emptyView.hidden = true
    }

    private func setupTableView() {
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = emptyView
        tableView.registerClass(EventTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "EventTableViewHeader")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = Constant.rowHeight
        tableView.tableFooterView = UIView()
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("EventTableViewHeader") as! EventTableViewHeader
        header.configure(title: eventPresenter.title(forSection: section))
        return header
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
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
