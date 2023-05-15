//
//  AppError.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/14.
//

import Foundation

protocol CauseTraceable {
    var causeError: Error? { get }
}

enum APIError: Error {
    case invalidData
    case refreshTooFast(dateWhenRefreshable: Date)
}

enum FileReadError: Error {
    
}

enum AppResourceError: Error {
    case notFound
}

enum DataStoreError: Error, CauseTraceable {

    /// トランザクションが失敗した
    case transaction(Error)

    /// 指定したオブジェクトが存在しない
    case notFound(String)

    var causeError: Error? {
        switch self {
        case .transaction(let error):
            return error

        case .notFound:
            return nil
        }
    }
}
