//
//  FightPropMapObject.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/05/01.
//

import Foundation
import RealmSwift

final class FightPropMapObject: Object {
    
    /// 基礎HP
    @Persisted var baseHP = 0.0
    /// 基礎攻撃力
    @Persisted var baseATK = 0.0
    /// 基礎防御力
    @Persisted var baseDEF = 0.0
    /// 会心率
    @Persisted var criticalRate = 0.0
    /// 会心ダメージ
    @Persisted var criticalDamage = 0.0
    /// 元素チャージ効率
    @Persisted var energyRecharge = 0.0
    /// 与える治療効果
    @Persisted var healingBonus = 0.0
    /// 受ける治療効果
    @Persisted var healedBonus = 0.0
    /// 元素熟知
    @Persisted var elementalMastery = 0.0
    
    /// 物理耐性
    @Persisted var physicalResistance = 0.0
    /// 物理ダメージ
    @Persisted var physicalDamage = 0.0
    /// 炎元素ダメージ
    @Persisted var pyroDamage = 0.0
    /// 雷元素ダメージ
    @Persisted var electroDamage = 0.0
    /// 水元素ダメージ
    @Persisted var hydroDamage = 0.0
    /// 草元素ダメージ
    @Persisted var dendroDamage = 0.0
    /// 風元素ダメージ
    @Persisted var anemoDamage = 0.0
    /// 岩元素ダメージ
    @Persisted var geoDamage = 0.0
    /// 氷元素ダメージ
    @Persisted var cryoDamage = 0.0
    
    /// 炎元素耐性
    @Persisted var pyroResistance = 0.0
    /// 雷元素耐性
    @Persisted var electroResistance = 0.0
    /// 水元素耐性
    @Persisted var hydroResistance = 0.0
    /// 草元素耐性
    @Persisted var dendroResistance = 0.0
    /// 風元素耐性
    @Persisted var anemoResistance = 0.0
    /// 岩元素耐性
    @Persisted var geoResistance = 0.0
    /// 氷元素耐性
    @Persisted var cryoResistance = 0.0
    
    @Persisted var pyroEnergyCost: Double? = nil
    @Persisted var electroEnergyCost: Double? = nil
    @Persisted var hydroEnergyCost: Double? = nil
    @Persisted var dendroEnergyCost: Double? = nil
    @Persisted var anemoEnergyCost: Double? = nil
    @Persisted var cryoEnergyCost: Double? = nil
    @Persisted var geoEnergyCost: Double? = nil
    
    /// HP上限
    @Persisted var hp = 0.0
    /// 攻撃力
    @Persisted var atk = 0.0
    /// 防御力
    @Persisted var def = 0.0
}

extension FightPropMapObject {
    
    static func decode(from value: FightPropMap) -> FightPropMapObject {
        
        let fightPropMapObject = FightPropMapObject()
        fightPropMapObject.baseHP = value.baseHP
        fightPropMapObject.baseATK = value.baseATK
        fightPropMapObject.baseDEF = value.baseDEF
        fightPropMapObject.criticalRate = value.criticalRate
        fightPropMapObject.criticalDamage = value.criticalDamage
        fightPropMapObject.energyRecharge = value.energyRecharge
        fightPropMapObject.healingBonus = value.healingBonus
        fightPropMapObject.elementalMastery = value.elementalMastery
        
        fightPropMapObject.physicalResistance = value.physicalResistance
        fightPropMapObject.physicalDamage = value.physicalDamage
        fightPropMapObject.pyroDamage = value.pyroDamage
        fightPropMapObject.electroDamage = value.electroDamage
        fightPropMapObject.hydroDamage = value.hydroDamage
        fightPropMapObject.dendroDamage = value.dendroDamage
        fightPropMapObject.anemoDamage = value.anemoDamage
        fightPropMapObject.geoDamage = value.geoDamage
        fightPropMapObject.cryoDamage = value.cryoDamage
        
        fightPropMapObject.pyroResistance = value.pyroResistance
        fightPropMapObject.electroResistance = value.electroResistance
        fightPropMapObject.hydroResistance = value.hydroResistance
        fightPropMapObject.dendroResistance = value.dendroResistance
        fightPropMapObject.anemoResistance = value.anemoResistance
        fightPropMapObject.geoResistance = value.geoResistance
        fightPropMapObject.cryoResistance = value.cryoResistance
        
        fightPropMapObject.pyroEnergyCost = value.pyroEnergyCost
        fightPropMapObject.electroEnergyCost = value.electroEnergyCost
        fightPropMapObject.hydroEnergyCost = value.hydroEnergyCost
        fightPropMapObject.dendroEnergyCost = value.dendroEnergyCost
        fightPropMapObject.anemoEnergyCost = value.anemoEnergyCost
        fightPropMapObject.cryoEnergyCost = value.cryoEnergyCost
        fightPropMapObject.geoEnergyCost = value.geoEnergyCost
        
        fightPropMapObject.hp = value.hp
        fightPropMapObject.atk = value.atk
        fightPropMapObject.def = value.def
        
        return fightPropMapObject
    }
    
    var value: FightPropMap {
        return FightPropMap(baseHP: baseHP, baseATK: baseATK, baseDEF: baseDEF, criticalRate: criticalRate, criticalDamage: criticalDamage, energyRecharge: energyRecharge, healingBonus: healingBonus, healedBonus: healedBonus, elementalMastery: elementalMastery, physicalResistance: physicalResistance, physicalDamage: physicalDamage, pyroDamage: pyroDamage, electroDamage: electroDamage, hydroDamage: hydroDamage, dendroDamage: dendroDamage, anemoDamage: anemoDamage, geoDamage: geoDamage, cryoDamage: cryoDamage, pyroResistance: pyroResistance, electroResistance: electroResistance, hydroResistance: hydroResistance, dendroResistance: dendroResistance, anemoResistance: anemoResistance, geoResistance: geoResistance, cryoResistance: cryoResistance, hp: hp, atk: atk, def: def)
    }
}
