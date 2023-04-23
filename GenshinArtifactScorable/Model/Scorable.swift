//
//  Scorable.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/11.
//

import Foundation

/// スコアをもつキャラクター，聖遺物用プロトコル
protocol Scorable {
    func calculateCriticalScore() -> Double
    func calculateTotalScore(criteria: ScoreCriteria) -> Double
}

enum ScoreCriteria: CaseIterable {
    case attack
    case hp
    case defense
    case energyRecharge
    case elementalMastery
    
    var criteriaString: String {
        switch self {
        case .attack:
            return "攻撃％"
        case .hp:
            return "HP％"
        case .defense:
            return "防御％"
        case .energyRecharge:
            return "元素チャージ効率"
        case .elementalMastery:
            return "元素熟知"
        }
    }
    
    var propIconString: String {
        switch self {
        case .attack:
            return "PropIcon/ATTACK_PERCENT"
        case .hp:
            return "PropIcon/HP_PERCENT"
        case .defense:
            return "PropIcon/DEFENSE_PERCENT"
        case .energyRecharge:
            return "PropIcon/CHARGE_EFFICIENCY"
        case .elementalMastery:
            return "PropIcon/ELEMENT_MASTERY"
        }
    }
}
