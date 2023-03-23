//
//  SelectCharacter.swift
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
    private var accountService: AccountService!
    private var accountAllInfo: AccountAllInfo?
    private var characterNameFromAvatarIdJSON: JSON?
    private var namecardURLFromNamecardIdJSON: JSON?
    
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
                    
                    if let characterNameFromAvatarIdJSON = self.characterNameFromAvatarIdJSON {
                        if let namecardURLFromNamecardIdJSON = self.namecardURLFromNamecardIdJSON {
                            self.setupUI(accountAllInfo: account, characterNameFromAvatarIdJSON: characterNameFromAvatarIdJSON, namecardURLFromNamecardIdJSON: namecardURLFromNamecardIdJSON)
                        }
                    }
                }
            }.catch { error in
                print(error)
            }
        print(uid!)
    }
    
    private func setupUI(accountAllInfo: AccountAllInfo, characterNameFromAvatarIdJSON: JSON, namecardURLFromNamecardIdJSON: JSON) {
        uidLabel.text = "UID " + uid
        userNameLabel.text = accountAllInfo.playerInfo.nickname
        adventureRankLabel.text = String(accountAllInfo.playerInfo.level)
        worldRankLabel.text = String(accountAllInfo.playerInfo.worldLevel)
        
        if let statusMessage = accountAllInfo.playerInfo.signature {
            self.statusMessageLabel.text = statusMessage
        } else {
            self.statusMessageLabel.text = "ステータスメッセージを設定していません．"
        }
        var profileIconCharacterName = characterNameFromAvatarIdJSON[String(accountAllInfo.playerInfo.profilePicture.avatarId)]["characterNameEN"].stringValue
        
        if profileIconCharacterName == "Lumine" || profileIconCharacterName == "Aether" {
            profileIconCharacterName += "(None)"
        }
        profileIconImageView.image = UIImage(named: "characters/\(profileIconCharacterName)/icon")
        
        let namecardURL = namecardURLFromNamecardIdJSON[String(accountAllInfo.playerInfo.nameCardId)]["icon"].stringValue
        namecardImageView.image = UIImage(url:AppConstant.UI.baseURL + "/" + namecardURL + ".png")
    }
    
    private func readJSONFile(filename: String) -> JSON? {
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

extension SelectCharacterViewController: Storyboardable {
    func inject(_ dependency: String) {
        uid = dependency
        self.accountService = AccountService()
        
        characterNameFromAvatarIdJSON = readJSONFile(filename: "characters")
        namecardURLFromNamecardIdJSON = readJSONFile(filename: "namecards")
        
    }
}
