//
//  MessageListViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let estimatedRowHeight: CGFloat = 60
}

enum MessageInfo: Int, Info {
    case modyfingMessage = 0

    var identifier: Int { return self.rawValue }
    var description: String {
        switch self {
        case .modyfingMessage:
            return String(key: "info_modifing_message")
        }
    }
}

class MessageListViewController: SharedViewController, UITableViewDataSource, MessagesPresenterClient, ModifyMessageViewControllerDelegate, UITableViewDelegate, SegueHandlerType {

    enum SegueIdentifier: String {
        case modifyMessage = "ModifyMessageViewController"
    }

    @IBOutlet private var tableView: UITableView!

    @IBOutlet var addButton: UIBarButtonItem!

    private lazy var messagesPresenter: MessagesPresenter = {
        let presenter = self.presenterFactory.messagesPresenter
        self.presenterFactory.addClient(self)
        return presenter
    }()

    private lazy var emptyView: UIView = {
        let view = EmptyView()
        view.configure(title: String(key: "empty_message_title_label"), subtitle: String(key: "empty_message_subtitle_label"))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupController()
        messagesPresenter.queryMessages()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard
            let navigationController = segue.destinationViewController as? UINavigationController,
            let controller = navigationController.viewControllers.first as? ModifyMessageViewController else { return }
        controller.delegate = self
        if let indexPath = tableView.indexPathForSelectedRow {
            controller.message = messagesPresenter.message(atIndex: indexPath)
        }
    }

    // MARK: -  SharedViewController

    override func userStatusDidUpdate(userStatus: UserStatus) {
        switch userStatus {
        case .admin:
            navigationItem.leftBarButtonItem = addButton
            tableView.allowsSelection = true
        case .follower:
            navigationItem.leftBarButtonItem = nil
            tableView.allowsSelection = false
        }
    }

    // MARK: - Private

    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constant.estimatedRowHeight
        tableView.tableFooterView = UIView()
    }

    private func setupController() {
        title = String(key: "messages_controller_title")
        tableView.backgroundView = emptyView
        emptyView.hidden = true
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesPresenter.numberOfMessages(inSection: section)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MessageTableViewCell = tableView.dequeueCell()
        cell.configure(with: messagesPresenter.message(atIndex: indexPath))
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegue(withIdentifier: .modifyMessage, sender: nil)
    }

    // MARK: - ModifyMessageViewControllerDelegate

    func controller(controller: ModifyMessageViewController, wantsToModify message: Message) {
        messagesPresenter.modifyMessage(message)
    }

    // MARK: - MessagesPresenterClients

    func presenterMessagesDidEndToModifyMessage() {
        dismissBannerInfo(MessageInfo.modyfingMessage)
    }

    func presenterMessagesDidBeginToModifyMessage() {
        showBanner(with: MessageInfo.modyfingMessage)
    }

    func presenterMessagesWantsToShowError(error: ApplicationError) {
        showAlert(withMessage: error.description, title: "error_title")
    }

    func presenterMessagesIsEmpty() {
        emptyView.hidden = false
    }

    func presenterWantsToShowLoading() {
        emptyView.hidden = true
    }

    func presenterMessagesDidFill() {
        tableView.reloadData()
    }

    func presenterMessagesWillChange() {
        tableView.beginUpdates()
        emptyView.hidden = false
    }

    func presenterMessagesDidChange(eventChange: EntityChange) {
        switch eventChange {
        case let .insert(indexPath: indexPath):
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case let .delete(indexPath: indexPath):
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case let .update(indexPath: indexPath):
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
