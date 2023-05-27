//
//  ImageTarget.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/14.
//

import Moya

enum ImageTarget {
    
    case fetchUIImage(imageString: String)
}

extension ImageTarget: BaseTarget {
    
    var path: String {
        switch self {
        case .fetchUIImage(let imageString):
            return "/ui/\(imageString).png"
        }
    }
    
    var method: Method {
        switch self {
        case .fetchUIImage:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchUIImage(_):
            return .requestPlain
        }
    }
}
