//
//  ModifyEventViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let defaultRowHeight: CGFloat = 44
    static let textViewRowHeight: CGFloat = 150
}

protocol ModifyEventViewControllerDelegate: class {
    func controller(controller: ModifyEventViewController, didModify event: Event)
}

class ModifyEventViewController: SharedViewController, UITableViewDataSource, UITableViewDelegate, SegueHandlerType, DatePickerViewControllerDelegate, LocationPickerViewControllerDelegate {

    enum SegueIdentifier: String {
        case date = "DatePickerViewController"
        case location = "LocationPickerViewController"
    }

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.registerView(RegistrableView<TextFieldCell>.fromNib)
            tableView.registerView(RegistrableView<TextCell>.fromNib)
            tableView.registerView(RegistrableView<BooleanCell>.fromNib)
            tableView.registerView(RegistrableView<TextViewCell>.fromNib)
            tableView.registerView(RegistrableView<ColorCell>.fromNib)
            tableView.tableFooterView = UIView()
        }
    }

    private lazy var keyboardManager: KeyboardManager = {
        return KeyboardManager(scrollView: self.tableView)
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(title: String(key: "add_button_title"), style: .Plain, target: self, action: #selector(addAction(_:)))
    }()

    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
        return dateFormatter
    }()

    private var dateIndexPath: NSIndexPath {
        return NSIndexPath(forRow: ModifyEventDetailRow.date.rawValue, inSection: ModifyEventSection.detail.rawValue)
    }

    private var descriptionIndexPath: NSIndexPath {
        return NSIndexPath(forRow: ModifyEventAdjunctRow.description.rawValue, inSection: ModifyEventSection.adjunct.rawValue)
    }

    private var locationIndexPath: NSIndexPath {
        return NSIndexPath(forRow: ModifyEventDetailRow.location.rawValue, inSection: ModifyEventSection.detail.rawValue)
    }

    private var initialEvent: Event?

    var event: Event?

    weak var delegate: ModifyEventViewControllerDelegate?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialEvent = event
        setupController()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager.registerForKeyboardMoves()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.unregisterForKeyboardMoves()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifier(forSegue: segue) {
        case .date:
            guard let controller = segue.destinationViewController as? DatePickerViewController else { return }
            controller.initialDate = event?.eventDate
            controller.delegate = self
        case .location:
            guard let controller = segue.destinationViewController as? LocationPickerViewController else { return }
            controller.delegate = self
        }
    }
    
    // MARK: - Private

    private func setupController() {
        title = String(key: "modify_event_title")
        let cancelButton = UIBarButtonItem(title: String(key: "cancel_button_title"), style: .Plain, target: self, action: #selector(cancelAction(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
        addButton.enabled = false
    }

    private func tryEnableAddButton() {
        let eventIsEmpty = (event?.color ?? "") != ""
            && (event?.creator ?? "") != ""
            && (event?.title ?? "") != ""
            && (event?.description ?? "") != ""
            && (event?.type ?? "") != ""
            && (event?.eventDate != nil)
        let eventHasChanged = initialEvent?.isEqual(to: event) ?? true
        addButton.enabled = eventHasChanged && eventIsEmpty
    }
    
    // MARK: - Actions

    func cancelAction(button: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addAction(button: UIBarButtonItem) {
        view.endEditing(true)
        dismissViewControllerAnimated(true) { _ in
            guard let event = self.event else { return }
            self.delegate?.controller(self, didModify: event)
        }
    }

    // MARK: - LocationPickerViewControllerDelegate

    func controller(controller: LocationPickerViewController, didPickLocation location: Location) {
        event?.location = location
        tryEnableAddButton()
        tableView.reloadRowsAtIndexPaths([locationIndexPath], withRowAnimation: .Fade)
    }
    
    // MARK: - DatePickerViewControllerDelegate
    
    func controller(controller: DatePickerViewController, didPickDate date: NSDate) {
        event?.eventDate = date
        tryEnableAddButton()
        tableView.reloadRowsAtIndexPaths([dateIndexPath], withRowAnimation: .Fade)
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
        guard let section = ModifyEventSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .preview:
            guard let row = ModifyEventPreviewRow(rawValue: indexPath.row) else { return UITableViewCell() }
            switch row {
            case .title:
                let cell: TextFieldCell = tableView.dequeueCell()
                cell.configure(withLabel: nil, placeholder: String(key: "modify_event_title_placeholder"), text: event?.title)
                cell.textFieldDidChange = { self.event?.title = $0; self.tryEnableAddButton() }
                return cell
            case .type:
                let cell: TextFieldCell = tableView.dequeueCell()
                cell.configure(withLabel: nil, placeholder: String(key: "modify_event_type_placeholder"), text: event?.type)
                cell.textFieldDidChange = { self.event?.type = $0; self.tryEnableAddButton() }
                return cell
            }
        case .creator:
            guard let row = ModifyEventCreatorRow(rawValue: indexPath.row) else { return UITableViewCell() }
            switch row {
            case .creator:
                let cell: TextFieldCell = tableView.dequeueCell()
                cell.configure(withLabel: nil, placeholder: String(key: "modify_event_creator_placeholder"), text: event?.creator)
                cell.textFieldDidChange = { self.event?.creator = $0; self.tryEnableAddButton() }
                return cell
            case .color:
                let cell: ColorCell = tableView.dequeueCell()
                cell.configure(withPlaceholder: String(key: "modify_event_color_placeholder"), value: event?.color)
                cell.colorDidChange = { self.event?.color = $0; self.tryEnableAddButton() }
                return cell
            }
        case .detail:
            guard let row = ModifyEventDetailRow(rawValue: indexPath.row) else { return UITableViewCell() }
            switch row {
            case .date:
                let cell: TextCell = tableView.dequeueCell()
                let value: String?
                if let date = event?.eventDate {
                    value = dateFormatter.stringFromDate(date)
                } else {
                    value = nil
                }
                cell.configure(withLabel: String(key: "modify_event_date_label"), value: value)
                return cell
            case .notify:
                let cell: BooleanCell = tableView.dequeueCell()
                cell.configure(withLabel: String(key: "modify_event_notify_label"), selected: event?.notify ?? false)
                cell.switchDidChange = { self.event?.notify = $0; self.tryEnableAddButton() }
                return cell
            case .location:
                let cell: TextCell = tableView.dequeueCell()
                let label = event?.location?.title ?? String(key: "modify_event_location_label")
                cell.configure(withLabel: label, value: event?.location?.subtitle)
                return cell
            }
        case .adjunct:
            guard let row = ModifyEventAdjunctRow(rawValue: indexPath.row) else { return UITableViewCell() }
            switch row {
            case .url:
                let cell: TextFieldCell = tableView.dequeueCell()
                cell.configure(withLabel: nil, placeholder: String(key: "modify_event_url_placeholder"), text: event?.link)
                cell.textFieldDidChange = { self.event?.link = $0; self.tryEnableAddButton() }
                cell.textField.autocorrectionType = .No
                cell.textField.autocapitalizationType = .None
                return cell
            case .description:
                let cell: TextViewCell = tableView.dequeueCell()
                cell.configure(placeholder: String(key: "modify_event_description_placeholder"), text: event?.description)
                cell.textViewDidChange = { self.event?.description = $0; self.tryEnableAddButton() }
                return cell
            }
        }
    }
    
    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath == descriptionIndexPath ? Constant.textViewRowHeight : Constant.defaultRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath {
        case dateIndexPath:
            performSegue(withIdentifier: .date, sender: self)
        case locationIndexPath:
            performSegue(withIdentifier: .location, sender: self)
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath == dateIndexPath || indexPath == locationIndexPath
    }
}
