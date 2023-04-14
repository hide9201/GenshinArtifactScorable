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

enum ScoreCriteria {
    case attack
    case hp
    case defense
    case energyRecharge
    case elementalMastery
}
