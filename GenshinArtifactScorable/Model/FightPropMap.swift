//
//  FightPropMap.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/11.
//

import Foundation

struct FightPropMap: Codable {
    
    /// 基礎HP
    var baseHP: Double
    /// 基礎攻撃力
    var baseATK: Double
    /// 基礎防御力
    var baseDEF: Double
    /// 会心率
    var criticalRate: Double
    /// 会心ダメージ
    var criticalDamage: Double
    /// 元素チャージ効率
    var energyRecharge: Double
    /// 与える治療効果
    var healingBonus: Double
    /// 受ける治療効果
    var healedBonus: Double
    /// 元素熟知
    var elementalMastery: Double
    
    /// 物理耐性
    var physicalResistance: Double
    /// 物理ダメージ
    var physicalDamage: Double
    /// 炎元素ダメージ
    var pyroDamage: Double
    /// 雷元素ダメージ
    var electroDamage: Double
    /// 水元素ダメージ
    var hydroDamage: Double
    /// 草元素ダメージ
    var dendroDamage: Double
    /// 風元素ダメージ
    var anemoDamage: Double
    /// 岩元素ダメージ
    var geoDamage: Double
    /// 氷元素ダメージ
    var cryoDamage: Double

    /// 炎元素耐性
    var pyroResistance: Double
    /// 雷元素耐性
    var electroResistance: Double
    /// 水元素耐性
    var hydroResistance: Double
    /// 草元素耐性
    var dendroResistance: Double
    /// 風元素耐性
    var anemoResistance: Double
    /// 岩元素耐性
    var geoResistance: Double
    /// 氷元素耐性
    var cryoResistance: Double

    var pyroEnergyCost: Double?
    var electroEnergyCost: Double?
    var hydroEnergyCost: Double?
    var dendroEnergyCost: Double?
    var anemoEnergyCost: Double?
    var cryoEnergyCost: Double?
    var geoEnergyCost: Double?

    /// HP上限
    var HP: Double
    /// 攻撃力
    var ATK: Double
    /// 防御力
    var DEF: Double

    private enum CodingKeys: String, CodingKey {
        case baseHP = "1"
        case baseATK = "4"
        case baseDEF = "7"
        case criticalRate = "20"
        case criticalDamage = "22"
        case energyRecharge = "23"
        case healingBonus = "26"
        case healedBonus = "27"
        case elementalMastery = "28"
        case physicalResistance = "29"
        case physicalDamage = "30"
        case pyroDamage = "40"
        case electroDamage = "41"
        case hydroDamage = "42"
        case dendroDamage = "43"
        case anemoDamage = "44"
        case geoDamage = "45"
        case cryoDamage = "46"
        case pyroResistance = "50"
        case electroResistance = "51"
        case hydroResistance = "52"
        case dendroResistance = "53"
        case anemoResistance = "54"
        case geoResistance = "55"
        case cryoResistance = "56"
        case pyroEnergyCost = "70"
        case electroEnergyCost = "71"
        case hydroEnergyCost = "72"
        case dendroEnergyCost = "73"
        case anemoEnergyCost = "74"
        case cryoEnergyCost = "75"
        case geoEnergyCost = "76"
        case HP = "2000"
        case ATK = "2001"
        case DEF = "2002"
    }
}
