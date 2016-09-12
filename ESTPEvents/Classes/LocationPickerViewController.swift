//
//  LocationPickerViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 11/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit
import MapKit

protocol LocationPickerViewControllerDelegate: class {
    func controller(controller: LocationPickerViewController, didPickLocation location: Location)
}

private struct Constant {
    static let ESTPLocation = Location(title: "ESTP Paris", subtitle: "28 Avenue du Président Wilson, 94230 Cachan, France")
    static let rowHeight: CGFloat = 50
}

class LocationPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MKLocalSearchCompleterDelegate {

    @IBOutlet var searchBar: UISearchBar!

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.rowHeight = Constant.rowHeight
        }
    }

    private let searchCompleter = MKLocalSearchCompleter()

    private var isShowingPredefinedResults: Bool {
        return searchCompleter.results.isEmpty || searchBar.text?.isEmpty ?? true
    }

    weak var delegate: LocationPickerViewControllerDelegate?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

    // MARK: - Private

    private func setupController() {
        title = String(key: "location_picker_title")
        searchBar.placeholder = String(key: "location_picker_placeholder")
        searchBar.delegate = self
        searchCompleter.delegate = self
    }

    private func mapResult(atIndexPath indexPath: NSIndexPath) -> Location {
        return isShowingPredefinedResults ? Constant.ESTPLocation : Location(location: searchCompleter.results[indexPath.row])
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingPredefinedResults ? 1 : searchCompleter.results.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        let result = mapResult(atIndexPath: indexPath)
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.controller(self, didPickLocation: mapResult(atIndexPath: indexPath))
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - UISearchBarDelegate

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tableView.reloadData()
            return
        }
        searchCompleter.queryFragment = searchText
    }

    // MARK: - MKLocalSearchCompleterDelegate

    func completerDidUpdateResults(completer: MKLocalSearchCompleter) {
        tableView.reloadData()
    }
}
