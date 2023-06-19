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
    @IBOutlet weak var selectCalculateTypeButton: UIButton!
    @IBOutlet weak var generateBuildCardButton: UIButton!
    
    // MARK: - Property
    
    private var uid: String!
    private var accountService: AccountService!
    private var imageService: ImageService!
    private var shapedAccountAllInfo: ShapedAccountAllInfo?
    
    private var loadingView = LoadingView(with: ())
    private var characterIcons: [UIImage] = []
    private var isCharacterIconsLoaded: [Bool] = []
    private var isProfileIconLoaded = false
    private var isNameCardImageLoaded = false
    private var isInitial = true
    
    private var selectedCalculateType: ScoreCalculateType? {
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
        configureMenu()
        refreshShapedAccountAllInfo()
    }
    
    // MARK: - Private
    
    private func refreshShapedAccountAllInfo() {
        showLoadingView()
        accountService.getAccountAllInfoFromAPI(uid: uid, nextRefreshableDate: shapedAccountAllInfo?.nextRefreshableDate)
            .done { accountAllInfo in
                self.shapedAccountAllInfo = accountAllInfo
                self.characterIcons = Array(repeating: UIImage(), count: accountAllInfo.characters.count)
                self.isCharacterIconsLoaded = Array(repeating: false, count: accountAllInfo.characters.count)
                self.setupUI()
            }.catch { error in
                if let _ = self.shapedAccountAllInfo {
                    self.setupUI()
                }
                print(error)
            }
    }
    
    private func changeGenerateBuildCardButtonEnabled() {
        generateBuildCardButton.isEnabled = (selectedCalculateType != nil && selectedCharacter != nil) ? true : false
    }
    
    private func showLoadingView() {
        loadingView.frame = view.frame
        view.addSubview(loadingView)
        loadingView.startLoading()
    }
    
    private func hideLoadingView() {
        loadingView.stopLoading()
        loadingView.removeFromSuperview()
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
                self.isProfileIconLoaded = true
                if self.isAllUIImagesFetched() { self.hideLoadingView() }
            }.catch { error in
                self.isProfileIconLoaded = true
                if self.isAllUIImagesFetched() { self.hideLoadingView() }
                print(error)
            }
        
        imageService.fetchUIImage(imageString: shapedAccountAllInfo.playerBasicInfo.nameCardString)
            .done { nameCardImage in
                self.namecardImageView.image = nameCardImage
                self.isNameCardImageLoaded = true
                if self.isAllUIImagesFetched() { self.hideLoadingView() }
            }.catch { error in
                self.isNameCardImageLoaded = true
                if self.isAllUIImagesFetched() { self.hideLoadingView() }
                print(error)
            }
        
        shapedAccountAllInfo.characters.enumerated().forEach { (index, character) in
            imageService.fetchUIImage(imageString: character.iconString)
                .done { characterIcon in
                    self.characterIcons[index] = characterIcon
                    self.isCharacterIconsLoaded[index] = true
                    if self.isCharacterIconsLoaded.allSatisfy({ $0 }) {
                        self.isInitial = false
                        self.characterCollectionView.reloadData()
                    }
                    if self.isAllUIImagesFetched() { self.hideLoadingView() }
                }.catch { error in
                    self.isCharacterIconsLoaded[index] = true
                    if self.isCharacterIconsLoaded.allSatisfy({ $0 }) {
                        self.isInitial = false
                        self.characterCollectionView.reloadData()
                    }
                    if self.isAllUIImagesFetched() { self.hideLoadingView() }
                    print(error)
                }
        }
    }
    
    private func isAllUIImagesFetched() -> Bool {
        return isProfileIconLoaded && isNameCardImageLoaded && isCharacterIconsLoaded.allSatisfy({ $0 })
    }
    
    private func configureMenu() {
        let actions = ScoreCalculateType.allCases
            .map { scoreCalculateType in
                UIAction(
                    title: scoreCalculateType.calculateTypeString,
                    image: UIImage(named: scoreCalculateType.propIconString)?.withTintColor(.label, renderingMode: .alwaysOriginal),
                    state: scoreCalculateType == selectedCalculateType ? .on : .off,
                    handler: { _ in
                        self.selectedCalculateType = scoreCalculateType
                        self.configureMenu()
                    })
            }
        
        selectCalculateTypeButton.menu = UIMenu(title: "スコア計算のタイプ", options: .displayInline, children: actions)
        selectCalculateTypeButton.showsMenuAsPrimaryAction = true
        selectCalculateTypeButton.setTitle(selectedCalculateType?.calculateTypeString ?? "選択してください", for: .normal)
        
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .capsule
        configuration.imagePadding = 8
        configuration.imagePlacement = .trailing
        configuration.automaticallyUpdateForSelection = false
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
        selectCalculateTypeButton.configuration = configuration
    }
    
    
    @IBAction func generateBuildCardButtonDidTap(_ sender: Any) {
        let buildCardGeneratorViewController = BuildCardGeneratorViewController(with: (character: selectedCharacter!, scoreCalculateType: selectedCalculateType!))
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
        self.characterIcons = Array(repeating: UIImage(), count: shapedAccountAllInfo?.characters.count ?? 0)
        self.isCharacterIconsLoaded = Array(repeating: false, count: shapedAccountAllInfo?.characters.count ?? 0)
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
        if !isInitial, let shapedAccountAllInfo = shapedAccountAllInfo {
            cell.inject((shapedAccountAllInfo.characters[indexPath.row], characterIcons[indexPath.row]))
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
