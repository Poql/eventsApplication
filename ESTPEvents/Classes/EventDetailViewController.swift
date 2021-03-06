//
//  EventDetailViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit
import MapKit


class EventDetailViewController: SharedViewController, UITableViewDelegate, UITableViewDataSource, SegueHandlerType, ModifyEventViewControllerDelegate, EventModificationListener {

    enum SegueIdentifier: String {
        case editEvent = "ModifyEventViewController"
    }

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.registerView(RegistrableView<LocationCell>.fromNib)
            tableView.registerView(RegistrableView<EventPreviewCell>.fromNib)
            tableView.registerView(RegistrableView<TextCell>.fromNib)
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView()
        }
    }

    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: String(key: "edit_button"), style: .Plain, target: self, action: #selector(editAction(_:)))
        return button
    }()

    private var eventMapItem: MKMapItem?

    var event: Event?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        searchEventLocation()
        presenterFactory.eventPresenter.registerListener(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let event = event else { return }
        if presenterFactory.eventPresenter.isModifyingEvent(event) {
            showBanner(with: EventInfo.modyfingEvent, animated: false)
            editButton.enabled = false
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifier(forSegue: segue) {
        case .editEvent:
            guard
                let navigationController = segue.destinationViewController as?  UINavigationController,
                let controller = navigationController.topViewController as? ModifyEventViewController else { return }
            controller.event = event
            controller.delegate = self
        }
    }

    // MARK: - Public

    func tryToUpdateEvent(with event: Event) {
        guard let currentEvent = self.event where event == currentEvent else { return }
        self.event = event
        eventMapItem = nil
        searchEventLocation()
        tableView.reloadData()
    }

    // MARK: - EventModificationListener

    func presenterDidBeginToModify(event event: Event) {
        guard let currentEvent = self.event where event == currentEvent else { return }
        showBanner(with: EventInfo.modyfingEvent)
        editButton.enabled = false
    }

    func presenterDidModify(event event: Event) {
        guard let currentEvent = self.event where event == currentEvent else { return }
        dismissBannerInfo(EventInfo.modyfingEvent)
        editButton.enabled = true
    }

    // MARK: - UserStatusUpdateListener

    override func userStatusDidUpdate(userStatus: UserStatus) {
        switch userStatus {
        case .follower:
            navigationItem.rightBarButtonItem = nil
        case .admin:
            navigationItem.rightBarButtonItem = editButton
        }
    }

    // MARK: - Actions

    @objc private func editAction(sender: UIBarButtonItem) {
        performSegue(withIdentifier: .editEvent, sender: self)
    }

    // MARK: - ModifyEventViewControllerDelegate

    func controller(controller: ModifyEventViewController, didModify event: Event) {
        presenterFactory.eventPresenter.modifyEvent(event)
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventDetailRowMapper.numberOfRows(forEvent: event)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let row = EventDetailRowMapper.row(atIndexPath: indexPath, forEvent: event) else { return UITableViewCell() }
        switch row {
        case .preview:
            let cell: EventPreviewCell = tableView.dequeueCell()
            cell.configure(event: event)
            return cell
        case .description:
            let cell: TextCell = tableView.dequeueCell()
            cell.configure(withLabel: event?.description, value: nil)
            cell.accessoryType = .None
            cell.label.numberOfLines = 0
            return cell
        case .location:
            let cell: LocationCell = tableView.dequeueCell()
            cell.configure(location: event?.location)
            cell.configure(locationCoordinate: eventMapItem?.placemark.coordinate)
            return cell
        case .url:
            let cell: TextCell = tableView.dequeueCell()
            cell.configure(withLabel: String(key: "event_detail_url_label"), value: event?.link)
            return cell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let row = EventDetailRowMapper.row(atIndexPath: indexPath, forEvent: event) else { return }
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        switch row {
        case .url:
            guard
                let link = event?.link,
                let url = NSURL(string: link)
                where UIApplication.sharedApplication().canOpenURL(url)
                else { return }
            UIApplication.sharedApplication().openURL(url)
        case .location:
            guard let item = eventMapItem else { return }
            item.openInMapsWithLaunchOptions(nil)
        default:
            return
        }
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        guard let row = EventDetailRowMapper.row(atIndexPath: indexPath, forEvent: event) else { return nil }
        switch row {
        case .url:
            return indexPath
        case .location:
            return eventMapItem != nil ? indexPath : nil
        default:
            return nil
        }
    }

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let row = EventDetailRowMapper.row(atIndexPath: indexPath, forEvent: event) else { return false }
        switch row {
        case .url:
            return true
        case .location:
            return eventMapItem != nil
        default:
            return false
        }
    }

    // MARK: - Private

    private func setupController() {
        title = String(key: "event_detail_title")
    }

    private func searchEventLocation() {
        guard let location = event?.location else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "\(location.title) \(location.subtitle)"
        let localSearch = MKLocalSearch(request: request)
        localSearch.startWithCompletionHandler { response, error in
            guard let item = response?.mapItems.first else { return }
            self.eventMapItem = item
            self.tableView.reloadData()
        }
    }
}
