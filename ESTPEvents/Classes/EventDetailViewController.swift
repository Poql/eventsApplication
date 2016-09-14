//
//  EventDetailViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: SharedViewController, UITableViewDelegate, UITableViewDataSource, SegueHandlerType, ModifyEventViewControllerDelegate {

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

    private var eventCoordinate: CLLocationCoordinate2D?

    var event: Event?

    weak var delegate: ModifyEventViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        searchEventLocation()
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
        self.event = event
        tableView.reloadData()
        delegate?.controller(controller, didModify: event)
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
            cell.configure(locationCoordinate: eventCoordinate)
            return cell
        case .url:
            let cell: TextCell = tableView.dequeueCell()
            cell.configure(withLabel: String(key: "event_detail_url_label"), value: event?.link)
            return cell
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
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            self.eventCoordinate = coordinate
            self.tableView.reloadData()
        }
    }
}
