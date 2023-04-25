//
//  AppError.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/14.
//

import Foundation

enum APIError: Error {
    case invalidData
}

enum FileReadError: Error {
    
}

enum DataError: Error {
    case notFound
}
