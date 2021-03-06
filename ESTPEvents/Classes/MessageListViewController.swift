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
    static let tableViewYInsets: CGFloat = 26
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
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        navigationItem.title = String(key: "messages_controller_title")
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = nil
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

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: - ApplicationStateListener

    override func applicationWillEnterForeground() {
        super.applicationWillEnterForeground()
        messagesPresenter.markMessagesAsRead()
    }

    // MARK: -  SharedViewController

    override func userStatusDidUpdate(userStatus: UserStatus) {
        switch userStatus {
        case .admin:
            navigationItem.rightBarButtonItem = addButton
            tableView.allowsSelection = true
        case .follower:
            navigationItem.rightBarButtonItem = nil
            tableView.allowsSelection = false
        }
    }

    override func shouldRefresh() {
        messagesPresenter.queryMessages()
    }

    // MARK: - Private

    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constant.estimatedRowHeight
        tableView.tableFooterView = UIView()
        tableView.contentInset.top += Constant.tableViewYInsets
        tableView.contentInset.bottom += Constant.tableViewYInsets
        view.backgroundColor = UIColor.darkGrey()
    }

    private func setupController() {
        tableView.backgroundView = emptyView
        emptyView.hidden = true
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesPresenter.numberOfMessages(inSection: section)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = messagesPresenter.message(atIndex: indexPath)
        if message.isAlert {
            let cell: AlertMessageTableViewCell = tableView.dequeueCell()
            cell.configure(with: message)
            return cell
        }
        let cell: MessageTableViewCell = tableView.dequeueCell()
        cell.configure(with: message)
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
        addButton.enabled = true
        tableView.allowsSelection = currentUserStatus == .admin
    }

    func presenterMessagesDidBeginToModifyMessage() {
        showBanner(with: MessageInfo.modyfingMessage)
        addButton.enabled = false
        tableView.allowsSelection = false
    }

    func presenterMessagesWantsToShowError(error: ApplicationError) {
        resetRefreshClock()
        showAlert(withMessage: error.description, title: "error_title")
    }

    func presenterMessagesIsEmpty() {
        emptyView.hidden = false
    }

    func presenterWantsToShowLoading() {}

    func presenterMessagesDidFill() {
        tableView.reloadData()
    }

    func presenterMessagesWillChange() {
        tableView.beginUpdates()
        emptyView.hidden = true
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
