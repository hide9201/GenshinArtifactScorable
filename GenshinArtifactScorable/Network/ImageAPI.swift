//
//  ImageAPI.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/14.
//

import Moya
import PromiseKit

final class ImageAPI {
    
    // MARK: - Static
    
    static let shared = ImageAPI()
    
    // MARK: - Property
    
    private let provider: MoyaProvider<MultiTarget>
    
    // MARK: - Public
    
    func call<Target: TargetType>(_ request: Target) -> Promise<UIImage> {
        let target = MultiTarget(request)
        return Promise { resolver in
            self.provider.request(target) { response in
                switch response.result {
                case .success(let result):
                    if let image = UIImage(data: result.data) {
                        resolver.fulfill(image)
                    } else {
                        resolver.reject(APIError.ImageAPIError.invalidData)
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

