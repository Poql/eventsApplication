//
//  ConfigurationPresenter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

private struct Constant {
    static let stateFileUserDefaultKey = "StateFileUserDefaultKey"
    static let applicationFirstOpeningKey = "ApplicationFirstOpeningKey"
}

class ConfigurationPresenter<Repository: UserStatusRepository> {

    private var userDefaults: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }

    var currentStateFile: ApplicationStateFile? {
        return userDefaults.entity(for: Constant.stateFileUserDefaultKey)
    }

    var applicationIsOpened: Bool {
        return userDefaults.boolForKey(Constant.applicationFirstOpeningKey)
    }

    let operationQueue = OperationQueue()

    let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    // MARK: - Public

    func finishApplicationOpening() {
        userDefaults.setBool(true, forKey: Constant.applicationFirstOpeningKey)
    }

    func updateCurrentStateFile(showLoading showLoading: Bool = false) {
        let operation = repository.fetchConfigurationFileOperation()
        let observer = BlockObserverOnMainQueue(willExecute: { _ in
            self.presenterDidBeginUpdatingConfigurationFile()
        }) { _, errs in
            self.handleErrors(errs)
            self.saveCurrentStateFile(operation.configurationFile)
            self.updateTintColor()
            self.checkApplicationVersion()
        }
        operation.addObserver(observer)
        if showLoading {
            operation.addObserver(NetworkObserver())
        }
        operationQueue.addOperation(operation)
    }

    func presenterDidBeginUpdatingConfigurationFile() {}

    func presenterDidUpdateTintColor(colorHex: String) {}
    
    func presenterDidDiscoverInvalidApplicationVersion() {}

    func presenterDidFail(with error: ApplicationError) {}

    // MARK: - Private

    private func handleErrors(errors: [ErrorType]) {
        guard let error = ErrorMapper.applicationError(fromOperationErrors: errors) else { return }
        presenterDidFail(with: error)
    }

    private func updateTintColor() {
        guard let file = currentStateFile else { return }
        presenterDidUpdateTintColor(file.tintColor)
    }

    private func checkApplicationVersion() {
        guard
            let requiredVersion = currentStateFile?.requiredVersion,
            let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
            where currentVersion.compare(requiredVersion) == .OrderedAscending
            else { return }
        presenterDidDiscoverInvalidApplicationVersion()
    }

    private func saveCurrentStateFile(configurationFile: ConfigurationFile?) {
        guard
            let configurationFile = configurationFile,
            let stateFile = ApplicationStateFile(configurationFile: configurationFile)
            else { return }
        userDefaults.setEntity(stateFile, forKey: Constant.stateFileUserDefaultKey)
    }
}
