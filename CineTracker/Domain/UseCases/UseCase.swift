//
//  UseCase.swift
//  CineTracker
//
//  Created by MAC VN on 14/5/26.
//

import Foundation

protocol UseCase {
    associatedtype Input
    associatedtype Output
    
    func execute(_ input: Input) async throws -> Output
}

protocol SyncUseCase {
    associatedtype Input
    associatedtype Output
    
    func execute(_ input: Input) -> Output
}
