//
//  AccountService.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/20.
//

import PromiseKit

struct AccountService {
    
    func getAccountAllInfo(uid: String) -> Promise<AccountAllInfo> {
        return API.shared.call(AccountTarget.getAccountAllInfo(uid: uid))
    }
}
