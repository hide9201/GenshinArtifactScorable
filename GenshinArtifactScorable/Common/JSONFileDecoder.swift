//
//  JSONFileDecoder.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/12.
//

import Foundation

struct JSONFileDecoder<T: Codable> {
    
    static func decode(fileName: String) -> T? {
        let decoder = JSONDecoder()
        let jsonFilePath = Bundle.main.url(forResource: fileName, withExtension: "json")!
        
        guard let jsonData = try? Data(contentsOf: jsonFilePath) else {
            print("File Read Error")
            return nil
        }
        
        do {
            return try decoder.decode(T.self, from: jsonData)
        } catch {
            print(error)
            return nil
        }
    }
}
