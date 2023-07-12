//
//  AppError.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/14.
//

import Foundation

enum APIError: Error {
    enum HTTPStatusCodeError: Error {
        
        /// 400
        case badRequest
        
        /// 404
        case notFound
        
        /// 424
        case failedDependency
        
        /// 429
        case tooManyRequests
        
        /// 500
        case internalServerError
        
        /// 503
        case serviceUnavailable
        
        /// 200番台(成功)以外で上記以外の番号
        case unknown(Int)
        
        // MARK: - Initializer
        
        init(statusCode: Int) {
            switch statusCode {
            case 400:
                self = .badRequest
            case 404:
                self = .notFound
            case 424:
                self = .failedDependency
            case 429:
                self = .tooManyRequests
            case 500:
                self = .internalServerError
            case 503:
                self = .serviceUnavailable
            default:
                self = .unknown(statusCode)
            }
        }
    }
    
    /// 200番台以外のステータスコードが返ってきた
    case statusCode(HTTPStatusCodeError)
    
    /// レスポンスのデコードに失敗した
    case decode(Error)
    
    /// レスポンスを受け取れなかった(ネットワーク不良など)
    case response(Error)
    
    /// 同一UIDに対して短時間に複数リクエストをした
    case refreshTooFast(dateWhenRefreshable: Date)
}

enum ImageAPIError: Error {
    case invalidData
}

enum AppResourceError: Error {
    case notFound
}

enum ImageCachesManagerError: Error {
    /// 書き込みに失敗した
    case write(Error)
}

enum DataStoreError: Error {

    /// トランザクションが失敗した
    case transaction(Error)

    /// 指定したオブジェクトが存在しない
    case notFound(String)
}
