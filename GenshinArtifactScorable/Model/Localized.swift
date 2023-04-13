//
//  Localized.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/13.
//

import Foundation

struct Localized: Codable {
    let ja: LocalizedDictionary
    
    struct LocalizedDictionary: Codable {
        var content: [String: String]
        
        struct DictionaryKey: CodingKey {
            var stringValue: String
            var intValue: Int?
            
            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            init?(intValue: Int) {
                self.stringValue = "\(intValue)"
                self.intValue = intValue
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DictionaryKey.self)
            
            var content = [String: String]()
            for key in container.allKeys {
                if let model = try? container.decode(String.self, forKey: key) {
                    content[key.stringValue] = model
                }
            }
            self.content = content
        }
    }
}
