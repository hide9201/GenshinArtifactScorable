//
//  SelectCharacterViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/17.
//

import UIKit
import SwiftyJSON
import ReusableKit

final class SelectCharacterViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var profileComponentView: UIStackView! {
        didSet {
            profileComponentView.backgroundColor = profileComponentView.backgroundColor?.withAlphaComponent(0)
        }
    }
    @IBOutlet weak var characterCollectionView: UICollectionView! {
        didSet {
            characterCollectionView.dataSource = self
            characterCollectionView.delegate = self
            characterCollectionView.register(CharacterCollectionViewCell.reusable)
        }
    }
    @IBOutlet weak var namecardImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusMessageLabel: UILabel!
    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var adventureRankLabel: UILabel!
    @IBOutlet weak var worldRankLabel: UILabel!
    
    // MARK: - Property
    
    private var uid: String!
    private var appResource: AppResource!
    private var accountService: AccountService!
    private var accountAllInfo: AccountAllInfo?
    
    // MARK: - Lifecycle
    
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
    
    // MARK: - Private
    
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
        characterCollectionView.reloadData()
    }
}

extension SelectCharacterViewController: Storyboardable {
    func inject(_ dependency: String) {
        self.uid = dependency
        self.accountService = AccountService()
        self.appResource = AppResource.shared
    }
}

extension SelectCharacterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let accountAllInfo = accountAllInfo {
            if let avatarInfoList = accountAllInfo.avatarInfoList {
                return avatarInfoList.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CharacterCollectionViewCell.reusable, for: indexPath)
        if let accountAllInfo = accountAllInfo {
            if let avatarInfoList = accountAllInfo.avatarInfoList {
                cell.inject((avatarInfoList[indexPath.row], appResource))
            }
        }
        return cell
    }
}

extension SelectCharacterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSizeWidth = self.characterCollectionView.frame.width / 4
        let cellSizeHeight = cellSizeWidth * (136.0 / 112.0)
        
        return CGSize(width: cellSizeWidth, height: cellSizeHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension SelectCharacterViewController: UICollectionViewDelegate {
    
}
