//
//  NameCardMap.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/13.
//

import Foundation

struct NameCardMap: Codable {
    var nameCard: [String: NameCard]
    
    struct NameCardKey: CodingKey {
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
        let container = try decoder.container(keyedBy: NameCardKey.self)
        
        var nameCard = [String: NameCard]()
        for key in container.allKeys {
            if let model = try? container.decode(NameCard.self, forKey: key) {
                nameCard[key.stringValue] = model
            }
        }
        self.nameCard = nameCard
    }
    
    struct NameCard: Codable {
        let icon: String
    }
}
