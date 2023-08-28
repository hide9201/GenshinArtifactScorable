//
//  MessageBanner.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/07/19.
//

import SwiftEntryKit

final class MessageBanner {
    
    // MARK: - Static
    
    static let shared = MessageBanner()
    
    // MARK: - Public
    
    func error(message: String) {
        let attribute = createBannerAttribute(name: "Error", color: .systemRed, feedBack: .error, duration: 5.0)
        
        let label = EKProperty.LabelContent(text: message, style: .init(font: UIFont.systemFont(ofSize: 15), color: .white, alignment: .center))
        let note = EKNoteMessageView(with: label)
        
        SwiftEntryKit.display(entry: note, using: attribute)
    }
    
    func warn(message: String) {
        let attribute = createBannerAttribute(name: "Warn", color: .systemYellow, feedBack: .warning, duration: 5.0)
        
        let label = EKProperty.LabelContent(text: message, style: .init(font: UIFont.systemFont(ofSize: 15), color: .white, alignment: .center))
        let note = EKNoteMessageView(with: label)
        
        SwiftEntryKit.display(entry: note, using: attribute)
    }
    
    // MARK: - Private
    
    private func createBannerAttribute(name: String, color: UIColor, feedBack: EKAttributes.NotificationHapticFeedback, duration: Double) -> EKAttributes {
        var attribute = EKAttributes.bottomFloat
        attribute.displayMode = .inferred
        attribute.name = name
        attribute.displayDuration = duration
        attribute.hapticFeedbackType = feedBack
        attribute.popBehavior = .animated(animation: .translation)
        attribute.entryBackground = .color(color: EKColor(color))
        attribute.statusBar = .light
        
        return attribute
    }
    
    // MARK: - Initializer
    
    private init() {}
}
