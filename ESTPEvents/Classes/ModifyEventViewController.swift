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

class ModifyEventViewController: SharedViewController, UITableViewDataSource, UITableViewDelegate {

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
        guard let section = ModifyEventSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .preview:
            guard let row = ModifyEventPreviewRow(rawValue: indexPath.row) else { return UITableViewCell() }
            switch row {
            case .title:
                let cell: TextFieldCell = tableView.dequeueCell()
                cell.configure(withLabel: nil, placeholder: String(key: "modify_event_title_label"), text: event?.title)
                return cell
            case .type:
                let cell: TextFieldCell = tableView.dequeueCell()
                cell.configure(withLabel: nil, placeholder: String(key: "modify_event_type_label"), text: event?.type)
                return cell
            }
        case .creator:
            guard let row = ModifyEventCreatorRow(rawValue: indexPath.row) else { return UITableViewCell() }
            switch row {
            case .creator:
                let cell: TextFieldCell = tableView.dequeueCell()
                cell.configure(withLabel: nil, placeholder: String(key: "modify_event_creator_label"), text: event?.creator)
                return cell
            case .color:
                let cell: ColorCell = tableView.dequeueCell()
                cell.configure(withPlaceholder: String(key: "modify_event_color_label"), value: event?.color)
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
                return cell
            }
        case .adjunct:
            guard let row = ModifyEventAdjunctRow(rawValue: indexPath.row) else { return UITableViewCell() }
            switch row {
            case .url:
                let cell: TextFieldCell = tableView.dequeueCell()
                cell.configure(withLabel: nil, placeholder: String(key: "modify_event_url_label"), text: event?.link)
                cell.textField.autocorrectionType = .No
                cell.textField.autocapitalizationType = .None
                return cell
            case .description:
                let cell: TextViewCell = tableView.dequeueCell()
                cell.configure(placeholder: String(key: "modify_event_description_label"), text: event?.description)
                return cell
            }
        }
    }
    
    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath == descriptionIndexPath ? Constant.textViewRowHeight : Constant.defaultRowHeight
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath == dateIndexPath
    }
}
