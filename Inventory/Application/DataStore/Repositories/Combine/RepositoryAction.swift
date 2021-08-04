//
//  RepositoryAction.swift
//  Inventory
//
//  Created by Mikael Weiss on 2/17/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import Foundation
import Combine

enum RepositoryAction {
    case add(UUID)
    case update(UUID)
    case delete(UUID)
    
    var id: UUID {
        switch self {
        case .add(let id), .update(let id), .delete(let id): return id
        }
    }
}

typealias RepositoryPublisher = AnyPublisher<RepositoryAction, Never>
typealias RepositorySubject = PassthroughSubject<RepositoryAction, Never>
