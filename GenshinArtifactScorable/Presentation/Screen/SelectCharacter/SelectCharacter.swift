//
//  SelectCharacterViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/17.
//

import UIKit
import SwiftyJSON

final class SelectCharacterViewController: UIViewController {
    
    @IBOutlet weak var profileComponentView: UIStackView! {
        didSet {
            profileComponentView.backgroundColor = profileComponentView.backgroundColor?.withAlphaComponent(0)
        }
    }
    @IBOutlet weak var namecardImageView: UIImageView!
    
    private var uid: String!
    private var appResource: AppResource!
    private var accountService: AccountService!
    private var accountAllInfo: AccountAllInfo?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusMessageLabel: UILabel!
    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var adventureRankLabel: UILabel!
    @IBOutlet weak var worldRankLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountService.getAccountAllInfo(uid: uid)
            .done { accountAllInfo in
                self.accountAllInfo = accountAllInfo
                if let account = self.accountAllInfo {
                    print(account)
                    self.setupUI(accountAllInfo: account)
                }
            }.catch { error in
                print(error)
            }
        print(uid!)
    }
    
    private func setupUI(accountAllInfo: AccountAllInfo) {
        uidLabel.text = "UID " + uid
        userNameLabel.text = accountAllInfo.playerInfo.nickname
        adventureRankLabel.text = String(accountAllInfo.playerInfo.level)
        worldRankLabel.text = String(accountAllInfo.playerInfo.worldLevel)
        
        if let statusMessage = accountAllInfo.playerInfo.signature {
            self.statusMessageLabel.text = statusMessage
        } else {
            self.statusMessageLabel.text = "ステータスメッセージを設定していません．"
        }
        
        if let characterNameFromAvatarIdJSON = appResource.characterNameFromAvatarIdJSON {
            var profileIconCharacterName = characterNameFromAvatarIdJSON[String(accountAllInfo.playerInfo.profilePicture.avatarId)]["characterNameEN"].stringValue
            
            if profileIconCharacterName == "Lumine" || profileIconCharacterName == "Aether" {
                profileIconCharacterName += "(None)"
            }
            profileIconImageView.image = UIImage(named: "characters/\(profileIconCharacterName)/icon")
        }
        
        if let namecardURLFromNamecardIdJSON = appResource.namecardURLFromNamecardIdJSON {
            let namecardURL = namecardURLFromNamecardIdJSON[String(accountAllInfo.playerInfo.nameCardId)]["icon"].stringValue
            namecardImageView.image = UIImage(url:AppConstant.UI.baseURL + "/" + namecardURL + ".png")
        }
    }
}

extension SelectCharacterViewController: Storyboardable {
    func inject(_ dependency: String) {
        self.uid = dependency
        self.accountService = AccountService()
        self.appResource = AppResource.shared
    }
}
