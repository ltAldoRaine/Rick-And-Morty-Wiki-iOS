//
//  CoreDataRMCharacterResponseStorage.swift
//  RickAndMortyWiki
//
//  Created by Beka Gelashvili on 14.01.24.
//

import CoreData
import Foundation

final class CoreDataRMCharacterResponseStorage {
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(
        for requestDto: RMCharacterRequestDTO
    ) -> NSFetchRequest<RMCharacterRequestEntity> {
        let request: NSFetchRequest = RMCharacterRequestEntity.fetchRequest()

        request.predicate = NSPredicate(format: "%K = %@",
                                        #keyPath(RMCharacterRequestEntity.character_id), requestDto.id)
        return request
    }

    private func deleteResponse(
        for requestDto: RMCharacterRequestDTO,
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

extension CoreDataRMCharacterResponseStorage: RMCharacterResponseStorage {
    func getResponse(
        for requestDto: RMCharacterRequestDTO,
        completion: @escaping (Result<RMCharactersPageResponseDTO.RMCharacterDTO?, Error>) -> Void
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
        response responseDto: RMCharactersPageResponseDTO.RMCharacterDTO,
        for requestDto: RMCharacterRequestDTO
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)

                let requestEntity = requestDto.toEntity(in: context)

                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataRMCharacterResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
