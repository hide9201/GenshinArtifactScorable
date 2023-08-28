//
//  SelectCharacterViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/17.
//

import UIKit
import ReusableKit

final class SelectCharacterViewController: UIViewController, ErrorShowable {
    
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
    private var errorView = ErrorView(with: (title: AppConstant.ErrorViewTitle.pleaseRefresh, hideRefreshButton: true))
    
    private var characterIcons: [UIImage?] = []
    private var isCharacterIconsLoaded: [Bool] = []
    private var isProfileIconLoaded = false
    private var isNameCardImageLoaded = false
    private var isShowingErrorView = false
    private var isLoading = false
    
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
        errorView.setRefreshButtonHandler { [weak self] in
            guard let self = self else { return }
            self.refreshShapedAccountAllInfo()
            self.hideErrorView()
        }
        refreshShapedAccountAllInfo()
    }
    
    // MARK: - Private
    
    private func refreshShapedAccountAllInfo() {
        if isLoading { return }
        showLoadingView()
        selectedCharacter = nil
        accountService.getAccountAllInfo(uid: uid)
            .done { shapedAccountAllInfo, apiError in
                self.shapedAccountAllInfo = shapedAccountAllInfo
                self.characterIcons = Array(repeating: nil, count: shapedAccountAllInfo.characters.count)
                self.setupUI()
                if let apiError = apiError {
                    self.showErrorBanner(apiError)
                    print(apiError)
                }
            }.catch { error in
                self.showErrorBanner(error)
                self.showErrorView()
                self.hideLoadingView()
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
        isLoading = true
    }
    
    private func hideLoadingView() {
        loadingView.stopLoading()
        loadingView.removeFromSuperview()
        isLoading = false
    }
    
    private func showErrorView() {
        if isShowingErrorView { return }
        errorView.frame = view.frame
        view.addSubview(errorView)
        isShowingErrorView = true
    }
    
    private func hideErrorView() {
        errorView.removeFromSuperview()
        isShowingErrorView = false
    }
    
    private func resetLoadedFlags(numOfCharacterIcons: Int) {
        isProfileIconLoaded = false
        isNameCardImageLoaded = false
        isCharacterIconsLoaded = Array(repeating: false, count: numOfCharacterIcons)
    }
    
    private func fetchImages(shapedAccountAllInfo: ShapedAccountAllInfo) {
        resetLoadedFlags(numOfCharacterIcons: shapedAccountAllInfo.characters.count)
        
        imageService.fetchUIImage(imageString: shapedAccountAllInfo.playerBasicInfo.profilePictureCharacterIconString)
            .done { profileIconImage in
                self.profileIconImageView.image = profileIconImage
            }.catch { error in
                self.showErrorBanner(error)
                self.showErrorView()
                print(error)
            }.finally {
                self.isProfileIconLoaded = true
                if self.isAllUIImagesLoaded() {
                    self.characterCollectionView.reloadData()
                    self.hideLoadingView()
                }
            }
        
        imageService.fetchUIImage(imageString: shapedAccountAllInfo.playerBasicInfo.nameCardString)
            .done { nameCardImage in
                self.namecardImageView.image = nameCardImage
            }.catch { error in
                self.showErrorBanner(error)
                self.showErrorView()
                print(error)
            }.finally {
                self.isNameCardImageLoaded = true
                if self.isAllUIImagesLoaded() {
                    self.characterCollectionView.reloadData()
                    self.hideLoadingView()
                }
            }
        
        shapedAccountAllInfo.characters.enumerated().forEach { (index, character) in
            imageService.fetchUIImage(imageString: character.iconString)
                .done { characterIcon in
                    self.characterIcons[index] = characterIcon
                }.catch { error in
                    self.showErrorBanner(error)
                    self.showErrorView()
                    print(error)
                }.finally {
                    self.isCharacterIconsLoaded[index] = true
                    if self.isAllUIImagesLoaded() {
                        self.characterCollectionView.reloadData()
                        self.hideLoadingView()
                    }
                }
        }
    }
    
    private func setupUI() {
        uidLabel.text = "UID " + uid
        
        guard let shapedAccountAllInfo = self.shapedAccountAllInfo else { return }
        
        userNameLabel.text = shapedAccountAllInfo.playerBasicInfo.playerName
        adventureRankLabel.text = String(shapedAccountAllInfo.playerBasicInfo.adventureLevel)
        worldRankLabel.text = String(shapedAccountAllInfo.playerBasicInfo.worldLevel)
        statusMessageLabel.text = shapedAccountAllInfo.playerBasicInfo.statusMessage
        
        fetchImages(shapedAccountAllInfo: shapedAccountAllInfo)
    }
    
    private func isAllUIImagesLoaded() -> Bool {
        return isProfileIconLoaded && isNameCardImageLoaded && isCharacterIconsLoaded.allSatisfy({ $0 })
    }
    
    private func configureMenu() {
        let actions = ScoreCalculateType.allCases
            .map { scoreCalculateType in
                UIAction(
                    title: scoreCalculateType.typeName,
                    image: UIImage(named: scoreCalculateType.typeIconString)?.withTintColor(.label, renderingMode: .alwaysOriginal),
                    state: scoreCalculateType == selectedCalculateType ? .on : .off,
                    handler: { _ in
                        self.selectedCalculateType = scoreCalculateType
                        self.configureMenu()
                    })
            }
        
        selectCalculateTypeButton.menu = UIMenu(title: "スコア計算のタイプ", options: .displayInline, children: actions)
        selectCalculateTypeButton.showsMenuAsPrimaryAction = true
        selectCalculateTypeButton.setTitle(selectedCalculateType?.typeName ?? "選択してください", for: .normal)
        
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .capsule
        configuration.imagePadding = 8
        configuration.imagePlacement = .trailing
        configuration.automaticallyUpdateForSelection = false
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
        selectCalculateTypeButton.configuration = configuration
    }
    
    // MARK: - Action
    
    @IBAction func refreshButtonDidTap(_ sender: Any) {
        refreshShapedAccountAllInfo()
    }
    
    @IBAction func generateBuildCardButtonDidTap(_ sender: Any) {
        let buildCardGeneratorViewController = BuildCardGeneratorViewController(with: (character: selectedCharacter!, scoreCalculateType: selectedCalculateType!))
        let navigation = UINavigationController(rootViewController: buildCardGeneratorViewController)
        present(navigation, animated: true)
    }
}

// MARK: - Storyboardable

extension SelectCharacterViewController: Storyboardable {
    func inject(_ dependency: String) {
        self.uid = dependency
        self.accountService = AccountService()
        self.imageService = ImageService()
    }
}

// MARK: - UICollectionViewDataSource

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
            cell.inject((shapedAccountAllInfo.characters[indexPath.row], characterIcons[indexPath.row]))
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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

// MARK: - UICollectionViewDelegate

extension SelectCharacterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // CollectionViewCellがタップできる = shapedAccountAllInfoを参照してセルを作成できているので，強制アンラップでも良い
        selectedCharacter = shapedAccountAllInfo!.characters[indexPath.row]
    }
}
