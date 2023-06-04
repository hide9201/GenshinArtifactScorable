//
//  AccountService.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/20.
//

import PromiseKit

struct AccountService {
    
    private let realmManager: RealmManager
    
    init() {
        realmManager = RealmManager()
    }
    
    func getAllAccountsFromRealm() -> [ShapedAccountAllInfo] {
        return realmManager.getAllObjects(ShapedAccountAllInfoObject.self).compactMap { $0.value }
    }
    
    func getAccountAllInfoFromRealm(uid: String) -> ShapedAccountAllInfo? {
        return realmManager.get(ShapedAccountAllInfoObject.self, primaryKey: uid)?.value
    }
    
    func getAccountAllInfoFromAPI(uid: String, nextRefreshableDate: Date?) -> Promise<ShapedAccountAllInfo> {
        if let nextRefreshableDate = nextRefreshableDate, nextRefreshableDate > Date() {
            return Promise { resolver in
                resolver.reject(APIError.refreshTooFast(dateWhenRefreshable: nextRefreshableDate))
            }
        } else {
            return API.shared.call(AccountTarget.getAccountAllInfo(uid: uid))
                .map { accountAllInfo in
                    let appResource = AppResource.shared
                    if let locDict = appResource.localizedDictionary, let charMap = appResource.characterDetails, let nameCard = appResource.nameCard {
                        return ShapedAccountAllInfo(accountAllInfo: accountAllInfo, localizedDictionary: locDict, characterMap: charMap, nameCardMap: nameCard)
                    } else {
                        throw AppResourceError.notFound
                    }
                }
        }
    }
    
    func saveAccountAllInfo(to accountInfo: ShapedAccountAllInfo) {
        let object = ShapedAccountAllInfoObject.decode(from: accountInfo)
        do {
            try realmManager.save(object)
        } catch {
            print(error)
        }
    }
}
