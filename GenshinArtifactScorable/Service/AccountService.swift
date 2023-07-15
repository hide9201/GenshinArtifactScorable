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
    
    func getAccountAllInfo(uid: String) -> Promise<ShapedAccountAllInfo> {
        if let cachedAccountAllInfo = getAccountAllInfoFromRealm(uid: uid) {
            return Promise { resolver in
                getAccountAllInfoFromAPI(uid: uid, nextRefreshableDate: cachedAccountAllInfo.nextRefreshableDate)
                    .done { shapedAccountAllInfo in
                        resolver.fulfill(shapedAccountAllInfo)
                    }.catch { _ in
                        resolver.fulfill(cachedAccountAllInfo)
                    }
            }
        } else {
            return getAccountAllInfoFromAPI(uid: uid, nextRefreshableDate: nil)
        }
    }
    
    private func getAccountAllInfoFromRealm(uid: String) -> ShapedAccountAllInfo? {
        if var accountAllInfo = realmManager.get(ShapedAccountAllInfoObject.self, primaryKey: uid)?.value {
            accountAllInfo.searchDate = Date()
            saveAccountAllInfo(to: accountAllInfo)
            return accountAllInfo
        } else {
            return nil
        }
    }
    
    private func getAccountAllInfoFromAPI(uid: String, nextRefreshableDate: Date?) -> Promise<ShapedAccountAllInfo> {
        if let nextRefreshableDate = nextRefreshableDate, nextRefreshableDate > Date() {
            return Promise { resolver in
                resolver.reject(APIError.AccountAPIError.refreshTooFast(dateWhenRefreshable: nextRefreshableDate))
            }
        } else {
            return API.shared.call(AccountTarget.getAccountAllInfo(uid: uid))
                .map { accountAllInfo in
                    let appResource = AppResource.shared
                    if let locDict = appResource.localizedDictionary, let charMap = appResource.characterDetails, let nameCard = appResource.nameCard {
                        var accountAllInfo = ShapedAccountAllInfo(accountAllInfo: accountAllInfo, localizedDictionary: locDict, characterMap: charMap, nameCardMap: nameCard)
                        accountAllInfo.searchDate = Date()
                        saveAccountAllInfo(to: accountAllInfo)
                        return accountAllInfo
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
