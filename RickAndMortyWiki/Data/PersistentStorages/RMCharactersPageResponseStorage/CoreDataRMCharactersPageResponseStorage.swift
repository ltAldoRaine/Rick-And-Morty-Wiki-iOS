//
//  CoreDataRMCharactersPageResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import CoreData
import Foundation

final class CoreDataRMCharactersPageResponseStorage {
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(
        for requestDto: RMCharactersPageRequestDTO
    ) -> NSFetchRequest<RMCharactersPageRequestEntity> {
        let request: NSFetchRequest = RMCharactersPageRequestEntity.fetchRequest()

        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
                                        #keyPath(RMCharactersPageRequestEntity.query), requestDto.query,
                                        #keyPath(RMCharactersPageRequestEntity.page), requestDto.page)
        return request
    }

    private func deleteResponse(
        for requestDto: RMCharactersPageRequestDTO,
        in context: NSManagedObjectContext
    ) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataRMCharactersPageResponseStorage: RMCharactersPageResponseStorage {
    func getResponse(
        for requestDto: RMCharactersPageRequestDTO,
        completion: @escaping (Result<RMCharactersPageResponseDTO?, Error>) -> Void
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
        response responseDto: RMCharactersPageResponseDTO,
        for requestDto: RMCharactersPageRequestDTO
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)

                let requestEntity = requestDto.toEntity(in: context)
                
                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataRMCharactersPageResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
