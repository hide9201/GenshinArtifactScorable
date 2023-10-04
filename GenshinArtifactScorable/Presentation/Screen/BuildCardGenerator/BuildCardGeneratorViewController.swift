//
//  BuildCardGeneratorViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/05/27.
//

import UIKit

final class BuildCardGeneratorViewController: UIViewController, BuildCardGeneratable, ErrorShowable {
    
    // MARK: - Outlet
    
    @IBOutlet weak var buildCardImageView: UIImageView! {
        didSet {
            buildCardImageView.image = UIImage(named: "BuildCard/Base/\(character.element.rawValue)")
        }
    }
    @IBOutlet weak var selectCalculateTypeButton: UIButton!
    
    // MARK: - Property
    
    private var character: Character!
    private var selectedScoreCalculateType: ScoreCalculateType!
    private var imageService: ImageService!
    
    private var characterImage: UIImage?
    private var weaponImage: UIImage?
    private var skillIcons: [UIImage?]!
    private var constellationIcons: [UIImage?]!
    private var artifactImages: [UIImage?]!
    
    private var isArtifactEquipedArray: [Bool]!
    private var isShowingErrorView = false
    
    private var loadingView = LoadingView(with: ())
    private var errorView = ErrorView(with: (title: AppConstant.ErrorViewTitle.errorOccured, hideRefreshButton: false))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenu()
        errorView.setRefreshButtonHandler { [weak self] in
            guard let self = self else { return }
            self.prepareUIImages()
            self.hideErrorView()
        }
        prepareUIImages()
    }
    
    // MARK: - Private
    
    private func showLoadingView() {
        loadingView.frame = view.frame
        view.addSubview(loadingView)
        loadingView.startLoading()
    }
    
    private func hideLoadingView() {
        loadingView.stopLoading()
        loadingView.removeFromSuperview()
    }
    
    private func showErrorView() {
        if isShowingErrorView { return }
        isShowingErrorView = true
        errorView.frame = view.frame
        view.addSubview(errorView)
    }
    
    private func hideErrorView() {
        errorView.removeFromSuperview()
        isShowingErrorView = false
    }
    
    private func prepareUIImages() {
        showLoadingView()
        imageService.fetchUIImage(imageString: character.imageString)
            .done { characterImage in
                self.characterImage = characterImage
                if self.isAllUIImagesPrepared() {
                    self.generateBuildCard()
                    self.hideLoadingView()
                }
            }.catch { error in
                self.showErrorBanner(error)
                self.showErrorView()
                self.hideLoadingView()
                print(error)
            }
        
        imageService.fetchUIImage(imageString: character.weapon.iconString)
            .done { weaponImage in
                self.weaponImage = weaponImage
                if self.isAllUIImagesPrepared() {
                    self.generateBuildCard()
                    self.hideLoadingView()
                }
            }.catch { error in
                self.showErrorBanner(error)
                self.showErrorView()
                self.hideLoadingView()
                print(error)
            }
        
        for (index, skill) in character.skills.enumerated() {
            imageService.fetchUIImage(imageString: skill.iconString)
                .done { skillIcon in
                    self.skillIcons[index] = skillIcon
                    if self.isAllUIImagesPrepared() {
                        self.generateBuildCard()
                        self.hideLoadingView()
                    }
                }.catch { error in
                    self.showErrorBanner(error)
                    self.showErrorView()
                    self.hideLoadingView()
                    print(error)
                }
        }
        
        for index in 0..<constellationIcons.count {
            imageService.fetchUIImage(imageString: character.constellationStrings[index])
                .done { constellationIcon in
                    self.constellationIcons[index] = constellationIcon
                    if self.isAllUIImagesPrepared() {
                        self.generateBuildCard()
                        self.hideLoadingView()
                    }
                }.catch { error in
                    self.showErrorBanner(error)
                    self.showErrorView()
                    self.hideLoadingView()
                    print(error)
                }
        }
    
        // character.artifactsは長さが不定(1〜5の間)なので，artifactImagesはenumeratedによるインデックスアクセス不可
        // forEachにより，装備している各聖遺物タイプに応じたインデックスアクセスとする
        character.artifacts.forEach { artifact in
            imageService.fetchUIImage(imageString: artifact.iconString)
                .done { artifactImage in
                    switch artifact.artifactType {
                    case .flower:
                        self.artifactImages[0] = artifactImage
                    case .plume:
                        self.artifactImages[1] = artifactImage
                    case .sands:
                        self.artifactImages[2] = artifactImage
                    case .goblet:
                        self.artifactImages[3] = artifactImage
                    case .circlet:
                        self.artifactImages[4] = artifactImage
                    }
                    if self.isAllUIImagesPrepared() {
                        self.generateBuildCard()
                        self.hideLoadingView()
                    }
                }.catch { error in
                    self.showErrorBanner(error)
                    self.showErrorView()
                    self.hideLoadingView()
                    print(error)
                }
        }
    }
    
    private func generateBuildCard() {
        buildCardImageView.image = generateBuildCard(
            character: character,
            scoreCalculateType: selectedScoreCalculateType,
            characterImage: characterImage!,
            weaponImage: weaponImage!,
            skillIcons: skillIcons.map { $0! },
            constellationIcons: constellationIcons.map { $0! },
            artifactImages: artifactImages)
    }
    
    private func isAllUIImagesPrepared() -> Bool {
        return characterImage != nil && weaponImage != nil && isSkillIconsPrepared() && isArtifactsImagesPrepared() && isConstellationIconsPrepared()
    }
    
    private func isSkillIconsPrepared() -> Bool {
        var isPrepared = true
        skillIcons.forEach {
            if $0 == nil { isPrepared = false }
        }
        return isPrepared
    }
    
    private func isConstellationIconsPrepared() -> Bool {
        var isPrepared = true
        constellationIcons.forEach {
            if $0 == nil { isPrepared = false }
        }
        return isPrepared
    }
    
    private func isArtifactsImagesPrepared() -> Bool {
        var isPrepared = true
        // 装備しているにも関わらず，画像取得の通信が終わってない場合，ビルドカードの準備ができてない
        for (index, artifactImage) in artifactImages.enumerated() {
            if artifactImage == nil, isArtifactEquipedArray[index] {
                isPrepared = false
            }
        }
        return isPrepared
    }
    
    private func configureMenu() {
        let actions = ScoreCalculateType.allCases
            .map { scoreCalculateType in
                UIAction(
                    title: scoreCalculateType.typeName,
                    image: UIImage(named: scoreCalculateType.typeIconString)?.withTintColor(.label, renderingMode: .alwaysOriginal),
                    state: scoreCalculateType == selectedScoreCalculateType ? .on : .off,
                    handler: { _ in
                        self.selectedScoreCalculateType = scoreCalculateType
                        self.configureMenu()
                    })
            }
        
        selectCalculateTypeButton.menu = UIMenu(title: "スコア計算のタイプ", options: .displayInline, children: actions)
        selectCalculateTypeButton.showsMenuAsPrimaryAction = true
        selectCalculateTypeButton.setTitle(selectedScoreCalculateType?.typeName ?? "選択してください", for: .normal)
        
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
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func regenerateBuildCardButtonDidTap(_ sender: Any) {
        generateBuildCard()
    }
    
    @IBAction func shareButtonDidTap(_ sender: Any) {
        let shareImage = buildCardImageView.image!
        let activityViewController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        
        var excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .copyToPasteboard,
            .mail,
            .markupAsPDF,
            .openInIBooks,
            .print,
            UIActivity.ActivityType(rawValue: "com.apple.reminders.sharingextension"),
            UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")
        ]
        
        if #available(iOS 16.0, *) {
            excludedActivityTypes.append(.collaborationCopyLink)
            excludedActivityTypes.append(.collaborationInviteWithLink)
        }
        
        if #available(iOS 16.4, *) {
            excludedActivityTypes.append(.addToHomeScreen)
        }
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        activityViewController.modalPresentationStyle = .pageSheet
        let navigation = UINavigationController(rootViewController: activityViewController)
        present(navigation, animated: true)
    }
}

// MARK: - Storyboardable

extension BuildCardGeneratorViewController: Storyboardable {
    func inject(_ dependency: (character: Character, scoreCalculateType: ScoreCalculateType)) {
        self.character = dependency.character
        self.selectedScoreCalculateType = dependency.scoreCalculateType
        
        self.imageService = ImageService()
    
        self.skillIcons = Array(repeating: nil, count: character.skills.count)
        self.constellationIcons = Array(repeating: nil, count: character.constellationLevel)
        self.artifactImages = Array(repeating: nil, count: 5)
        self.isArtifactEquipedArray = Array(repeating: false, count: 5)
        
        character.artifacts.forEach { artifact in
            switch artifact.artifactType {
            case .flower:
                self.isArtifactEquipedArray[0] = true
            case .plume:
                self.isArtifactEquipedArray[1] = true
            case .sands:
                self.isArtifactEquipedArray[2] = true
            case .goblet:
                self.isArtifactEquipedArray[3] = true
            case .circlet:
                self.isArtifactEquipedArray[4] = true
            }
        }
    }
}
