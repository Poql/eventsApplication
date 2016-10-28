//
//  MessageListViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class MessageListViewController: SharedViewController, UITableViewDataSource, MessagesPresenterClient {

    private var tableView: UITableView {
        return view as! UITableView
    }

    private lazy var messagesPresenter: MessagesPresenter = {
        let presenter = self.presenterFactory.messagesPresenter
        self.presenterFactory.addClient(self)
        return presenter
    }()

    override func loadView() {
        view = UITableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        messagesPresenter.queryMessages()
    }

    // MARK: - Private

    private func setupViews() {
        tableView.dataSource = self
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesPresenter.numberOfMessages(inSection: section)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.textLabel?.text = messagesPresenter.message(atIndex: indexPath).author
        return cell
    }

    // MARK: - MessagesPresenterClients

    func presenterMessagesWantsToShowError(error: ApplicationError) {
        showAlert(withMessage: error.description, title: "error_title")
    }

    func presenterMessagesIsEmpty() {
        tableView.hidden = true
    }

    func presenterWantsToShowLoading() {}

    func presenterMessagesDidFill() {
        tableView.reloadData()
    }

    func presenterMessagesWillChange() {
        tableView.beginUpdates()
    }

    func presenterMessagesDidChange(eventChange: EntityChange) {
        switch eventChange {
        case let .insert(indexPath: indexPath):
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case let .delete(indexPath: indexPath):
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case let .update(indexPath: indexPath):
            guard let cell = self.tableView.cellForRowAtIndexPath(indexPath)
                else { return }
            cell.textLabel?.text = messagesPresenter.message(atIndex: indexPath).author
        case let .move(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath):
            self.tableView.deleteRowsAtIndexPaths([fromIndexPath], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([toIndexPath], withRowAnimation: .Fade)
        }
    }

    func presenterMessagesSectionDidChange(eventSectionChange: EntitySectionChange) {
        switch eventSectionChange {
        case let .insert(section):
            tableView.insertSections(NSIndexSet(index: section), withRowAnimation: .Fade)
        case let .delete(section):
            tableView.deleteSections(NSIndexSet(index: section), withRowAnimation: .Fade)
        }
    }

    func presenterMessagesDidChange(){
        tableView.endUpdates()
    }
}
