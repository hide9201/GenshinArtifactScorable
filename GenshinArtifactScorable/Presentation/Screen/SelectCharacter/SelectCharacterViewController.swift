//
//  SelectCharacterViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/17.
//

import UIKit
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
    @IBOutlet weak var selectCriteriaButton: UIButton!
    @IBOutlet weak var generateBuildCardButton: UIButton!
    
    // MARK: - Property
    
    private var uid: String!
    private var accountService: AccountService!
    private var imageService: ImageService!
    private var shapedAccountAllInfo: ShapedAccountAllInfo?
    
    private var selectedCriteria: ScoreCriteria? {
        didSet {
            changeGenerateBuildCardButtonEnabled()
        }
    }
    
    private var selectedCharacter: Character? {
        didSet {
            changeGenerateBuildCardButtonEnabled()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateBuildCardButton.isEnabled = false
        setupUI()
        configureMenu()
        refreshShapedAccountAllInfo()
    }
    
    // MARK: - Private
    
    private func refreshShapedAccountAllInfo() {
        accountService.getAccountAllInfoFromAPI(uid: uid, nextRefreshableDate: shapedAccountAllInfo?.nextRefreshableDate)
            .done { accountAllInfo in
                self.shapedAccountAllInfo = accountAllInfo
                self.setupUI()
                self.accountService.saveAccountAllInfo(to: accountAllInfo)
                
            }.catch { error in
                print(error)
            }
    }
    
    private func changeGenerateBuildCardButtonEnabled() {
        generateBuildCardButton.isEnabled = (selectedCriteria != nil && selectedCharacter != nil) ? true : false
    }
    
    private func setupUI() {
        uidLabel.text = "UID " + uid
        
        guard let shapedAccountAllInfo = self.shapedAccountAllInfo else { return }
        
        userNameLabel.text = shapedAccountAllInfo.playerBasicInfo.playerName
        adventureRankLabel.text = String(shapedAccountAllInfo.playerBasicInfo.adventureLevel)
        worldRankLabel.text = String(shapedAccountAllInfo.playerBasicInfo.worldLevel)
        statusMessageLabel.text = shapedAccountAllInfo.playerBasicInfo.statusMessage
        
        imageService.fetchUIImage(imageString: shapedAccountAllInfo.playerBasicInfo.profilePictureCharacterIconString)
            .done { profileIconImage in
                self.profileIconImageView.image = profileIconImage
                self.imageService.saveUIImage(image: profileIconImage, imageString: shapedAccountAllInfo.playerBasicInfo.profilePictureCharacterIconString)
            }.catch { error in
                print(error)
            }
        
        imageService.fetchUIImage(imageString: shapedAccountAllInfo.playerBasicInfo.nameCardString)
            .done { nameCardImage in
                self.namecardImageView.image = nameCardImage
                self.imageService.saveUIImage(image: nameCardImage, imageString: shapedAccountAllInfo.playerBasicInfo.nameCardString)
            }.catch { error in
                print(error)
            }
        
        characterCollectionView.reloadData()
    }
    
    private func configureMenu() {
        let actions = ScoreCriteria.allCases
            .map { criteria in
                UIAction(
                    title: criteria.criteriaString,
                    image: UIImage(named: criteria.propIconString)?.withTintColor(.darkGray, renderingMode: .alwaysOriginal),
                    state: criteria == selectedCriteria ? .on : .off,
                    handler: { _ in
                        self.selectedCriteria = criteria
                        self.configureMenu()
                    })
            }
        
        selectCriteriaButton.menu = UIMenu(title: "スコアの計算基準", options: .displayInline, children: actions)
        selectCriteriaButton.showsMenuAsPrimaryAction = true
        selectCriteriaButton.setTitle(selectedCriteria?.criteriaString ?? "選択してください", for: .normal)
        
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .capsule
        configuration.imagePadding = 8
        configuration.imagePlacement = .trailing
        configuration.automaticallyUpdateForSelection = false
        configuration.image = UIImage(systemName: "chevron.up")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
        selectCriteriaButton.configuration = configuration
    }
    
    
    @IBAction func generateBuildCardButtonDidTap(_ sender: Any) {
        let buildCardGeneratorViewController = BuildCardGeneratorViewController(with: (character: selectedCharacter!, scoreCriteria: selectedCriteria!))
        let navigation = UINavigationController(rootViewController: buildCardGeneratorViewController)
        present(navigation, animated: true)
    }
}

extension SelectCharacterViewController: Storyboardable {
    func inject(_ dependency: String) {
        self.uid = dependency
        self.accountService = AccountService()
        self.imageService = ImageService()
        self.shapedAccountAllInfo = accountService.getAccountAllInfoFromRealm(uid: uid)
    }
}

extension SelectCharacterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let shapedAccountAllInfo = shapedAccountAllInfo {
            return shapedAccountAllInfo.characters.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CharacterCollectionViewCell.reusable, for: indexPath)
        if let shapedAccountAllInfo = shapedAccountAllInfo {
            cell.inject((shapedAccountAllInfo.characters[indexPath.row], imageService))
        }
        return cell
    }
}

extension SelectCharacterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSizeWidth = characterCollectionView.frame.width / 4
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // CollectionViewCellがタップできる = shapedAccountAllInfoを参照してセルを作成できているので，強制アンラップでも良い
        selectedCharacter = shapedAccountAllInfo!.characters[indexPath.row]
    }
}
