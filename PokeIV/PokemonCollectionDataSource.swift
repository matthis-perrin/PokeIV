//
//  PokemonCollectionDataSource.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/25/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit


enum PokemonCollectionDataSourceMode {
    case Date
    case IV
    case CP
    case NumThenIV
    case NumThenCP
    case NumThenDate
    case Candy
}


class PokemonCollectionDataSource: NSObject {
    
    // Store the pokemon grouped using `buildGroup()` base on `mode`
    private var _pokemonsGroups: [PokemonGroup] = []
    
    // Store the raw array of pokemons
    private var _inventory: Inventory = Inventory()
    var inventory: Inventory {
        get {
            return self._inventory
        }
        set(inventory) {
            self._inventory = inventory
            self.buildGroups()
        }
    }
    
    // Store the current grouping mode of the data source
    private var _mode: PokemonCollectionDataSourceMode = .Date
    var mode: PokemonCollectionDataSourceMode {
        get {
            return _mode
        }
        set(mode) {
            self._mode = mode
            self.buildGroups()
        }
    }
    
    // Store the filter text
    private var _filterText: String = ""
    var filterText: String {
        get {
            return _filterText
        }
        set(filterText) {
            self._filterText = filterText
            self.buildGroups()
        }
    }
    
    // Keep a reference to the collection view
    let collectionView: UICollectionView
    
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    func pokemonAtIndexPath(indexPath: NSIndexPath) -> Pokemon {
        return self._pokemonsGroups[indexPath.section].pokemons[indexPath.row]
    }
    
    private func buildGroups() {
        // Filter the pokemon based on `self.filterText`
        var filteredPokemon = Array(self.inventory.pokemons)
        if !self.filterText.isEmpty {
            filteredPokemon = filteredPokemon.filter { (pokemon) -> Bool in
                let pokemonName = pokemon.displayName
                return pokemonName.uppercaseString.containsString(self.filterText.uppercaseString)
            }
        }
        
        // Get the current PokemonGroup based on `self.mode`
        var groupStrategy: PokemonGroupStrategy.Type
        switch self.mode {
            case .Date: groupStrategy = PokemonGroupStrategy_Date.self
            case .IV: groupStrategy = PokemonGroupStrategy_IV.self
            case .CP: groupStrategy = PokemonGroupStrategy_CP.self
            case .NumThenIV: groupStrategy = PokemonGroupStrategy_NumThenIV.self
            case .NumThenCP: groupStrategy = PokemonGroupStrategy_NumThenCP.self
            case .NumThenDate: groupStrategy = PokemonGroupStrategy_NumThenDate.self
            case .Candy: groupStrategy = PokemonGroupStrategy_Candy.self
        }
        
        // Build the groups
        var groups: [PokemonGroup] = []
        for pokemon in filteredPokemon {
            let pokemonGroupLabel = groupStrategy.getGroupLabel(pokemon)
            if let index = groups.indexOf({(group: PokemonGroup) in pokemonGroupLabel == group.label}) {
                groups[index].pokemons.append(pokemon)
            } else {
                let candyAmount: Int32? = groupStrategy.showCandyInHeader() ? self.inventory.getCandyAmount(pokemon.num) : nil
                groups.append(PokemonGroup(label: pokemonGroupLabel, pokemons: [pokemon], candyAmount: candyAmount))
            }
        }
        
        // Sort the group
        let sortedGroups = groups.sort({ (group1: PokemonGroup, group2: PokemonGroup) -> Bool in
            return groupStrategy.groupIsBefore(group1, group2: group2)
        })
        
        // Sort pokemons inside the group
        let fullySortedGroups = sortedGroups.map { (group: PokemonGroup) -> PokemonGroup in
            let sortedPokemons = group.pokemons.sort { (p1: Pokemon, p2: Pokemon) -> Bool in
                return groupStrategy.pokemonIsBefore(p1, p2: p2)
            }
            return PokemonGroup(label: group.label, pokemons: sortedPokemons, candyAmount: group.candyAmount)
        }
        
        // Store the new groups
        self._pokemonsGroups = fullySortedGroups
        self.collectionView.reloadData()
    }
    
}

extension PokemonCollectionDataSource: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _pokemonsGroups[section].pokemons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath)
        if let cell = cell as? PokemonCollectionViewCell {
            let pokemon = self._pokemonsGroups[indexPath.section].pokemons[indexPath.row]
            cell.pokemon = pokemon
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return _pokemonsGroups.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "PokemonSectionHeader", forIndexPath: indexPath)
        if let view = view as? PokemonCollectionViewHeader {
            let group = self._pokemonsGroups[indexPath.section]
            if let pokemon = group.pokemons.first {
                view.titleLabel.text = "\(group.label) (\(group.pokemons.count))"
                if let candyAmount = group.candyAmount {
                    view.candyAmountLabel.text = String(candyAmount)
                    view.candyView.num = pokemon.num
                    view.candyAmountLabel.hidden = false
                    view.candyView.hidden = false
                } else {
                    view.candyAmountLabel.hidden = true
                    view.candyView.hidden = true
                }
            }
        }
        return view
    }

}

private struct PokemonGroup {
    var label: String
    var pokemons: Array<Pokemon>
    var candyAmount: Int32?
}

private class CategoryUtil {
    let categories: [(min: Double, max: Double, label: String)]
    init(categories: [(min: Double, max: Double, label: String)]) {
        self.categories = categories
    }
    func labelForValue(value: Double) -> String? {
        for category in self.categories {
            if value >= category.min && value < category.max {
                return category.label
            }
        }
        return nil
    }
    func valuesForLabel(label: String) -> (min: Double, max: Double) {
        for category in self.categories {
            if label == category.label {
                return (min: category.min, max: category.max)
            }
        }
        return (min: 0, max: 0)
    }
}

private protocol PokemonGroupStrategy {
    static func getGroupLabel(p: Pokemon) -> String
    static func groupIsBefore(group1: PokemonGroup, group2: PokemonGroup) -> Bool
    static func pokemonIsBefore(p1: Pokemon, p2: Pokemon) -> Bool
    static func showCandyInHeader() -> Bool
}

private class PokemonGroupStrategy_Date: PokemonGroupStrategy {
    private static let calendar = NSCalendar.currentCalendar()
    
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    private static let LAST_10_MINUTES = NSLocalizedString("Last10Minutes", comment: "Header when listing pokemons by dates - Last 10 minutes")
    private static let LAST_HOUR = NSLocalizedString("LastHour", comment: "Header when listing pokemons by dates - Last hour")
    private static let TODAY = NSLocalizedString("Today", comment: "Header when listing pokemons by dates - Today")
    private static let YERSTERDAY = NSLocalizedString("Yesterday", comment: "Header when listing pokemons by dates - Yesterday")
    
    static func getGroupLabel(p: Pokemon) -> String {
        let date = p.creationTime
        if !(date.compare(NSDate(timeIntervalSinceNow: -10 * 60)) == .OrderedAscending) {
            return LAST_10_MINUTES
        }
        if !(date.compare(NSDate(timeIntervalSinceNow: -1 * 60 * 60)) == .OrderedAscending) {
            return LAST_HOUR
        }
        
        let now = NSDate()
        let components = calendar.components([.Day , .Month, .Year], fromDate: now)
        let today = calendar.dateFromComponents(components) ?? now
        if !(date.compare(today) == .OrderedAscending) {
            return TODAY
        }
        
        let yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: today, options: NSCalendarOptions.MatchFirst) ?? today
        if !(date.compare(yesterday) == .OrderedAscending) {
            return YERSTERDAY
        }
        
        return self.dateFormatter.stringFromDate(date)
    }
    static func groupIsBefore(group1: PokemonGroup, group2: PokemonGroup) -> Bool {
        let orders = [
            LAST_10_MINUTES: 0,
            LAST_HOUR: 1,
            TODAY: 2,
            YERSTERDAY: 3,
        ]
        let order1 = orders[group1.label] ?? Int.max
        let order2 = orders[group2.label] ?? Int.max
        
        if order1 != order2 {
            return order1 < order2
        }
        
        guard let date1 = self.dateFormatter.dateFromString(group1.label) else {
            return false
        }
        guard let date2 = self.dateFormatter.dateFromString(group2.label) else {
            return true
        }
        
        return date1.compare(date2) == .OrderedDescending
    }
    static func pokemonIsBefore(p1: Pokemon, p2: Pokemon) -> Bool {
        return p1.creationTime.compare(p2.creationTime) == .OrderedDescending
    }
    static func showCandyInHeader() -> Bool {
        return false
    }
}

private class PokemonGroupStrategy_IV: PokemonGroupStrategy {
    private static let categories = CategoryUtil(categories: [
        (min: 95.0, max: DBL_MAX, label: ">95%"),
        (min: 90.0, max: 95.0,  label: "90% - 95%"),
        (min: 80.0, max: 90.0,  label: "80% - 90%"),
        (min: 70.0, max: 80.0,  label: "70% - 80%"),
        (min: 60.0, max: 70.0,  label: "60% - 70%"),
        (min: 50.0, max: 60.0,  label: "50% - 60%"),
        (min: 40.0, max: 50.0,  label: "40% - 50%"),
        (min: 30.0, max: 40.0,  label: "30% - 40%"),
        (min: 20.0, max: 30.0,  label: "20% - 30%"),
        (min: 10.0, max: 20.0,  label: "10% - 20%"),
        (min: DBL_MIN, max: 10.0,  label: "<10%"),
    ])
    static func getGroupLabel(p: Pokemon) -> String {
        return self.categories.labelForValue(p.IVRatio * 100) ?? String(format: "%.1f%%", p.IVRatio * 100)
    }
    static func groupIsBefore(group1: PokemonGroup, group2: PokemonGroup) -> Bool {
        let max1 = self.categories.valuesForLabel(group1.label).max
        let max2 = self.categories.valuesForLabel(group2.label).max
        return max1 > max2
    }
    static func pokemonIsBefore(p1: Pokemon, p2: Pokemon) -> Bool {
        return p1.IVRatio == p2.IVRatio ? p1.cp > p2.cp : p1.IVRatio > p2.IVRatio
    }
    static func showCandyInHeader() -> Bool {
        return false
    }
}

private class PokemonGroupStrategy_CP: PokemonGroupStrategy {
    private static let categories = CategoryUtil(categories: [
        (min: 2500.0, max: DBL_MAX, label: ">2500"),
        (min: 2000.0, max: 2500.0,  label: "2000-2500"),
        (min: 1500.0, max: 2000.0,  label: "1500-2000"),
        (min: 1000.0, max: 1500.0,  label: "1000-1500"),
        (min: 500.0,  max: 1000.0,  label: "500-1000"),
        (min: 100.0,  max: 500.0,   label: "100-500"),
        (min: DBL_MIN,max: 100.0,   label: "<100"),
    ])
    static func getGroupLabel(p: Pokemon) -> String {
        return self.categories.labelForValue(p.cp) ?? String(format: "%.1f%%", p.cp)
    }
    static func groupIsBefore(group1: PokemonGroup, group2: PokemonGroup) -> Bool {
        let max1 = self.categories.valuesForLabel(group1.label).max
        let max2 = self.categories.valuesForLabel(group2.label).max
        return max1 > max2
    }
    static func pokemonIsBefore(p1: Pokemon, p2: Pokemon) -> Bool {
        return p1.cp == p2.cp ? p1.IVRatio > p2.IVRatio : p1.cp > p2.cp
    }
    static func showCandyInHeader() -> Bool {
        return false
    }
}

private class PokemonGroupStrategy_NumThenIV: PokemonGroupStrategy {
    static func getGroupLabel(p: Pokemon) -> String {
        return p.displayName
    }
    static func groupIsBefore(group1: PokemonGroup, group2: PokemonGroup) -> Bool {
        guard let p1 = group1.pokemons.first else { return false }
        guard let p2 = group2.pokemons.first else { return true }
        return p1.num.rawValue.integerValue < p2.num.rawValue.integerValue
    }
    static func pokemonIsBefore(p1: Pokemon, p2: Pokemon) -> Bool {
        return p1.IVRatio == p2.IVRatio ? p1.cp > p2.cp : p1.IVRatio > p2.IVRatio
    }
    static func showCandyInHeader() -> Bool {
        return true
    }
}

private class PokemonGroupStrategy_NumThenCP: PokemonGroupStrategy {
    static func getGroupLabel(p: Pokemon) -> String {
        return p.displayName
    }
    static func groupIsBefore(group1: PokemonGroup, group2: PokemonGroup) -> Bool {
        guard let p1 = group1.pokemons.first else { return false }
        guard let p2 = group2.pokemons.first else { return true }
        return p1.num.rawValue.integerValue < p2.num.rawValue.integerValue
    }
    static func pokemonIsBefore(p1: Pokemon, p2: Pokemon) -> Bool {
        return p1.cp == p2.cp ? p1.IVRatio > p2.IVRatio : p1.cp > p2.cp
    }
    static func showCandyInHeader() -> Bool {
        return true
    }
}

private class PokemonGroupStrategy_NumThenDate: PokemonGroupStrategy {
    static func getGroupLabel(p: Pokemon) -> String {
        return p.displayName
    }
    static func groupIsBefore(group1: PokemonGroup, group2: PokemonGroup) -> Bool {
        guard let p1 = group1.pokemons.first else { return false }
        guard let p2 = group2.pokemons.first else { return true }
        return p1.num.rawValue.integerValue < p2.num.rawValue.integerValue
    }
    static func pokemonIsBefore(p1: Pokemon, p2: Pokemon) -> Bool {
        return p1.creationTime.compare(p2.creationTime) == .OrderedDescending
    }
    static func showCandyInHeader() -> Bool {
        return true
    }
}

private class PokemonGroupStrategy_Candy: PokemonGroupStrategy {
    static func getGroupLabel(p: Pokemon) -> String {
        return p.displayName
    }
    static func groupIsBefore(group1: PokemonGroup, group2: PokemonGroup) -> Bool {
        let candy1 = group1.candyAmount ?? 0
        let candy2 = group2.candyAmount ?? 0
        if candy1 == candy2 {
            return group1.pokemons.count > group2.pokemons.count
        }
        return candy1 > candy2
    }
    static func pokemonIsBefore(p1: Pokemon, p2: Pokemon) -> Bool {
        return p1.IVRatio == p2.IVRatio ? p1.cp > p2.cp : p1.IVRatio > p2.IVRatio
    }
    static func showCandyInHeader() -> Bool {
        return true
    }
}

