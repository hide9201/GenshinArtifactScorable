//
//  API.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/18.
//

import Moya
import PromiseKit

final class API {
    
    // MARK: - Static
    
    static let shared = API()
    
    // MARK: - Property
    
    private let provider: MoyaProvider<MultiTarget>
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    // MARK: - Public
    
    func call<T: Decodable, Target: TargetType>(_ request: Target) -> Promise<T> {
        let target = MultiTarget(request)
        return Promise { resolver in
            self.provider.request(target) { response in
                switch response.result {
                case .success(let result):
                    do {
                        resolver.fulfill(try self.decoder.decode(T.self, from: result.data))
                    } catch {
                        resolver.reject(APIError.decode(error))
                    }
                case .failure(let error):
                    resolver.reject(self.createError(from: error))
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func createError(from error: MoyaError) -> Error {
        switch error {
        case .statusCode(let response):
            return APIError.statusCode(.init(statusCode: response.statusCode))
            
        case .underlying(let underlyingError, let response):
            guard let response = response else { return APIError.response(underlyingError) }
            return APIError.statusCode(.init(statusCode: response.statusCode))
            
        default:
            return APIError.response(error)
        }
    }
    
    // MARK: - Initializer
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        
        provider = MoyaProvider<MultiTarget>(manager: manager)
    }
}
