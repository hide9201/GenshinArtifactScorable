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
                        resolver.reject(error)
                    }
                case .failure(let error):
                    resolver.reject(error)
                }
            }
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
