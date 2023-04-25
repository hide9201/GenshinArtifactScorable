//
//  AppResource.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/29.
//

final class AppResource {
    
    static let shared = AppResource()
    
    let characterDetails: [String: CharacterMap.Character]?
    let nameCard: [String: NameCardMap.NameCard]?
    let localizedDictionary: [String: String]?
    
    private init() {
        characterDetails = JSONFileDecoder<CharacterMap>.decode(fileName: "characters")?.characterStaticData
        nameCard = JSONFileDecoder<NameCardMap>.decode(fileName: "namecards")?.nameCard
        localizedDictionary = JSONFileDecoder<Localized>.decode(fileName: "loc")?.ja.content
    }
}
