//
//  RecordsFetcherController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 27/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack
import Operations

protocol RecordsFetcherControllerDelegate: class {
    func fetcherControllerWillChange()
    func fetcherControllerDidChange()
    func fetcherControllerIsEmpty()
    func fetcherControllerHasValues()
    func fetcherControllerRecordDidChange(entityChange: EntityChange)
    func fetcherControllerSectionDidChange(sectionChange: EntitySectionChange)
}

class RecordsFetcherController<M: PersistentRecordMapper>: NSObject, FetchedResultsControllerDelegate {

    typealias E = M.R
    typealias PE = M.PR

    private var resultsController: FetchedResultsController<PE>?

    var isEmpty: Bool {
        return resultsController?.fetchedObjects?.isEmpty ?? true
    }

    weak var delegate: RecordsFetcherControllerDelegate?

    init(predicate: NSPredicate, sortDescriptor: [NSSortDescriptor], sectionNameKeyPath: String?, inContext context: NSManagedObjectContext) {
        let request = NSFetchRequest(entity: PE.self)
        request.sortDescriptors = sortDescriptor
        resultsController = FetchedResultsController<PE>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath)
        super.init()
        resultsController?.setDelegate(self)
    }

    func performFetch() {
        try! resultsController?.performFetch()
    }

    // MARK: - QueryEntitiesPresenter

    func numberOfSections() -> Int {
        return resultsController?.sections?.count ?? 0
    }

    func numberOfEntities(inSection section: Int) -> Int {
        return resultsController?.sections?[section].objects.count ?? 0
    }

    func title(forSection section: Int) -> String? {
        return resultsController?.sections?[section].name
    }

    func entity(atIndex index: NSIndexPath) -> E {
        let persitentRecord = resultsController![index]
        return M.getRecord(from: persitentRecord)
    }

    // MARK: - FetchedResultsControllerDelegate

    func fetchedResultsController(controller: FetchedResultsController<PE>, didChangeObject change: FetchedResultsObjectChange<PE>) {
        let entityChange: EntityChange
        switch change {
        case let .Delete(object: _, indexPath: indexPath):
            entityChange = .delete(indexPath: indexPath)
        case let .Insert(object: _, indexPath: indexPath):
            entityChange = .insert(indexPath: indexPath)
        case let .Update(object: _, indexPath: indexPath):
            entityChange = .update(indexPath: indexPath)
        case let .Move(object: _, fromIndexPath: fromIndexPath, toIndexPath: toIndexPath):
            entityChange = .move(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath)
        }
        delegate?.fetcherControllerRecordDidChange(entityChange)
    }

    func fetchedResultsController(controller: FetchedResultsController<PE>, didChangeSection change: FetchedResultsSectionChange<PE>) {
        let entitySectionChange: EntitySectionChange
        switch change {
        case let .Insert(_, index):
            entitySectionChange = .insert(index: index)
        case let .Delete(_, index):
            entitySectionChange = .delete(index: index)
        }
        delegate?.fetcherControllerSectionDidChange(entitySectionChange)
    }

    func fetchedResultsControllerWillChangeContent(controller: FetchedResultsController<PE>) {
        delegate?.fetcherControllerWillChange()
    }

    func fetchedResultsControllerDidChangeContent(controller: FetchedResultsController<PE>) {
        delegate?.fetcherControllerDidChange()
        if isEmpty {
            delegate?.fetcherControllerIsEmpty()
        }
    }

    func fetchedResultsControllerDidPerformFetch(controller: FetchedResultsController<PE>) {
        if isEmpty {
            delegate?.fetcherControllerIsEmpty()
            return
        }
        delegate?.fetcherControllerHasValues()
    }
    
}
