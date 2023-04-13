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
    private var imageService: ImageService!
    private var accountAllInfo: AccountAllInfo?
    private var shapedAccountAllInfo: ShapedAccountAllInfo?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountService.getAccountAllInfo(uid: uid)
            .done { accountAllInfo in
                self.accountAllInfo = accountAllInfo
                if let locDict = self.appResource.localizedDictionary, let charMap = self.appResource.characterDetails, let nameCardMap = self.appResource.nameCard {
                    self.shapedAccountAllInfo = .init(accountAllInfo: accountAllInfo, localizedDictionary: locDict, characterMap: charMap, nameCardMap: nameCardMap)
                    self.setupUI(shapedAccountAllInfo: self.shapedAccountAllInfo!)
                }
                
//                if let account = self.accountAllInfo {
//                    print(account)
//                    self.setupUI(accountAllInfo: account)
//                }
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
        
        characterCollectionView.reloadData()
    }
    
    private func setupUI(shapedAccountAllInfo: ShapedAccountAllInfo) {
        uidLabel.text = "UID " + uid
        userNameLabel.text = shapedAccountAllInfo.playerBasicInfo.playerName
        adventureRankLabel.text = String(shapedAccountAllInfo.playerBasicInfo.adventureLevel)
        worldRankLabel.text = String(shapedAccountAllInfo.playerBasicInfo.worldLevel)
        
        statusMessageLabel.text = shapedAccountAllInfo.playerBasicInfo.statusMessage
        
        imageService.fetchUIImage(imageName: "\(shapedAccountAllInfo.playerBasicInfo.profilePictureCharacterIconString).png")
            .done { profileIconImage in
                self.profileIconImageView.image = profileIconImage
            }.catch { error in
                print(error)
            }
        
        imageService.fetchUIImage(imageName: "\(shapedAccountAllInfo.playerBasicInfo.nameCardString).png")
            .done { nameCardImage in
                self.namecardImageView.image = nameCardImage
            }.catch { error in
                print(error)
            }
        characterCollectionView.reloadData()
    }
}

extension SelectCharacterViewController: Storyboardable {
    func inject(_ dependency: String) {
        self.uid = dependency
        self.accountService = AccountService()
        self.imageService = ImageService()
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
