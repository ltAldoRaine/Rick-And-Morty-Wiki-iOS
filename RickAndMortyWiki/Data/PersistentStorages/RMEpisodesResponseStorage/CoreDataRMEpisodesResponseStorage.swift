//
//  CoreDataRMEpisodesResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import CoreData
import Foundation

final class CoreDataRMEpisodesResponseStorage {
    // MARK: - Properties

    private let coreDataStorage: CoreDataStorage

    // MARK: - Initialization

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private Methods

    private func fetchRequest(
        for requestDto: RMEpisodesRequestDTO
    ) -> NSFetchRequest<RMEpisodesRequestEntity> {
        let request: NSFetchRequest = RMEpisodesRequestEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(RMEpisodesRequestEntity.episodes_ids),
            requestDto.ids.map { "\($0)" }.joined(separator: ",")
        )

        return request
    }

    private func deleteResponse(
        for requestDto: RMEpisodesRequestDTO,
        in context: NSManagedObjectContext
    ) throws {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            throw CoreDataStorageError.deleteError(error)
        }
    }
}

extension CoreDataRMEpisodesResponseStorage: RMEpisodesResponseStorage {
    func getResponse(
        for requestDto: RMEpisodesRequestDTO,
        completion: @escaping (ResultType) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDto)

                let requestEntity = try context.fetch(fetchRequest).first

                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(
        response responseDto: [RMEpisodeDTO],
        for requestDto: RMEpisodesRequestDTO
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                try self.deleteResponse(for: requestDto, in: context)

                let requestEntity = requestDto.toEntity(in: context)

                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                debugPrint(
                    """
                    CoreDataRMEpisodesResponseStorage
                    Unresolved error \(error), \((error as NSError).userInfo)
                    """
                )
            }
        }
    }
}
