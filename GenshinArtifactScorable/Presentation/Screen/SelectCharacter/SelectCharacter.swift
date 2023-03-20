//
//  SelectCharacter.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/17.
//

import UIKit

final class SelectCharacterViewController: UIViewController {
    
    private var uid: String!
    private var accountService: AccountService!
    private var accountAllInfo: AccountAllInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountService.getAccountAllInfo(uid: uid)
            .done { accountAllInfo in
                self.accountAllInfo = accountAllInfo
                print(accountAllInfo)
            }.catch { error in
                print(error)
            }
        print(uid!)
    }
}

extension SelectCharacterViewController: Storyboardable {
    func inject(_ dependency: String) {
        uid = dependency
        self.accountService = AccountService()
    }
}
