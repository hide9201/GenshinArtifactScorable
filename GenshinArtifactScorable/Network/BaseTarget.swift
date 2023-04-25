//
//  BaseTarget.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/19.
//

import Moya

protocol BaseTarget: TargetType {
}

extension BaseTarget {
    
    var baseURL: URL {
        return URL(string: AppConstant.API.baseURL)!
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var sampleData: Data {
        return Data()
    }
}

typealias Parameters = [String: Any]
