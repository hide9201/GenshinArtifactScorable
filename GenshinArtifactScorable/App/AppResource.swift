//
//  AppResource.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/29.
//

import SwiftyJSON

final class AppResource {
    
    static let shared = AppResource()
    
    let characterNameFromAvatarIdJSON: JSON?
    let namecardURLFromNamecardIdJSON: JSON?
    
    private init() {
        let jsonReader = JSONReader()
        characterNameFromAvatarIdJSON = jsonReader.readJSONFile(filename: "characters")
        namecardURLFromNamecardIdJSON = jsonReader.readJSONFile(filename: "namecards")
    }
}

struct JSONReader {
    func readJSONFile(filename: String) -> JSON? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("ファイルが見つからない")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("ファイル読み込みエラー")
        }
        do {
            let jsonObject = try JSON(data: data)
            return jsonObject
        } catch let error {
            print(error)
            return nil
        }
    }
}
