//
//  AccountService.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/20.
//

import PromiseKit

struct AccountService {
    
    func getAccountAllInfo(uid: String) -> Promise<ShapedAccountAllInfo> {
        return API.shared.call(AccountTarget.getAccountAllInfo(uid: uid))
            .map { accountAllInfo in
                let appResource = AppResource.shared
                if let locDict = appResource.localizedDictionary, let charMap = appResource.characterDetails, let nameCard = appResource.nameCard {
                    return ShapedAccountAllInfo(accountAllInfo: accountAllInfo, localizedDictionary: locDict, characterMap: charMap, nameCardMap: nameCard)
                } else {
                    throw DataError.notFound
                }
            }
    }
}
