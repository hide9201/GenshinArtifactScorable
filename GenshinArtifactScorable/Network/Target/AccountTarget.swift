//
//  AccountTarget.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/20.
//

import Moya

enum AccountTarget {
    
    case getAccountAllInfo(uid: String)
}

extension AccountTarget: BaseTarget {
    
    var path: String {
        switch self {
        case .getAccountAllInfo(let uid):
            return "/api/uid/\(uid)"
        }
    }
    
    var method: Method {
        switch self {
        case .getAccountAllInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAccountAllInfo(let uid):
            let parameters: Parameters = [
                "uid": uid
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
