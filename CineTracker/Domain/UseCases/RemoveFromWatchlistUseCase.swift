//
//  RemoveFromWatchlistUseCase.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation

struct RemoveFromWatchlistUseCase: UseCase {
    typealias Input = Int
    typealias Output = Void
    
    private let repository: WatchlistRepository
    
    init(repository: WatchlistRepository) {
        self.repository = repository
    }
    
    func execute(_ input: Int) async throws -> Void {
        try repository.remove(id: input)
    }
}
