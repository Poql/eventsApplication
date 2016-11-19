//
//  QueryEntitiesPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 26/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import BNRCoreDataStack

protocol RecordsFetcherControllerInitializer: class {
    associatedtype Mapper: PersistentRecordMapper
    var fetcherControllerPredicate: NSPredicate { get }
    var fetcherControllerSortDescriptors: [NSSortDescriptor] { get }
    var fetcherControllerSectionPath: String? { get }
    var fetcherController: RecordsFetcherController<Mapper>? { get set }
}

extension RecordsFetcherControllerInitializer {
    func initialiseFetcherControllerOperation(with delegate: RecordsFetcherControllerDelegate) -> Operation {
        let operation = DataStackBlockOperation { stack in
            guard let mainContext = stack?.mainQueueContext else { return }
            self.initFetcherController(inContext: mainContext)
            self.fetcherController?.delegate = delegate
            self.fetcherController?.performFetch()
        }
        let provider = DataStackProviderOperation()
        provider.userIntent = .Initiated
        provider.addDataStackOperation(operation)
        return provider
    }

    private func initFetcherController(inContext context: NSManagedObjectContext) {
        let predicate = fetcherControllerPredicate
        let sortDescriptors = fetcherControllerSortDescriptors
        let path = fetcherControllerSectionPath
        self.fetcherController = RecordsFetcherController(predicate: predicate,
                                                          sortDescriptor: sortDescriptors,
                                                          sectionNameKeyPath: path,
                                                          inContext: context)
    }
}
