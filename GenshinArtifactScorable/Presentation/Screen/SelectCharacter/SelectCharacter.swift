//
//  SelectCharacter.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/17.
//

import UIKit
import SwiftyJSON

final class SelectCharacterViewController: UIViewController {
    
    private var uid: String!
    private var accountService: AccountService!
    private var accountAllInfo: AccountAllInfo?
    private var jpnNameFromAvatarIdJSON: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountService.getAccountAllInfo(uid: uid)
            .done { accountAllInfo in
                self.accountAllInfo = accountAllInfo
                if let account = self.accountAllInfo {
                    print(account)
                    if let jpnNameFromAvatarIdJSON = self.jpnNameFromAvatarIdJSON {
                        print(jpnNameFromAvatarIdJSON[String(account.playerInfo.profilePicture.avatarId)].stringValue)
                    }
                }
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
        
        guard let url = Bundle.main.url(forResource: "characters", withExtension: "json") else {
            fatalError("ファイルが見つからない")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("ファイル読み込みエラー")
        }
        do {
            jpnNameFromAvatarIdJSON = try JSON(data: data)
        } catch let error {
            print(error)
        }
    }
}
