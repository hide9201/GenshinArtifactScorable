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
    let characterDetails: [String: CharacterMap.Character]?
    let nameCard: [String: NameCardMap.NameCard]?
    let localizedDictionary: [String: String]?
    
    private init() {
        let jsonReader = JSONFileReader()

        characterNameFromAvatarIdJSON = jsonReader.readJSONFile(filename: "charactersTemp")
        namecardURLFromNamecardIdJSON = jsonReader.readJSONFile(filename: "namecards")
        
        characterDetails = JSONFileDecoder<CharacterMap>.decode(fileName: "characters")?.characterStaticData
        nameCard = JSONFileDecoder<NameCardMap>.decode(fileName: "namecards")?.nameCard
        localizedDictionary = JSONFileDecoder<Localized>.decode(fileName: "loc")?.ja.content
    }
}

struct JSONFileReader {
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
