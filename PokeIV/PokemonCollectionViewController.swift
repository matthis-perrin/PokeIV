//
//  PokemonCollectionViewController.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import PGoApi

class PokemonCollectionViewController: UICollectionViewController {

    private var _pokemons = [Pogoprotos.Data.PokemonData()]
    private var _pokemonsById = [(num: Int32(), pokemons: [Pogoprotos.Data.PokemonData()])]
    
    var pokemons: [Pogoprotos.Data.PokemonData] {
        get {
            return _pokemons
        }
        set (pokemons) {
            self._pokemons = pokemons
            self._pokemonsById = self.getPokemonById()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView!.registerClass(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self._pokemonsById.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self._pokemonsById[section].pokemons.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath)
        if let cell = cell as? PokemonCollectionViewCell {
            let pokemon = self._pokemonsById[indexPath.section].pokemons[indexPath.row]
            cell.pokemon = pokemon
        }
        return cell
    }
    
    private func getPokemonById() -> [(num: Int32, pokemons: [Pogoprotos.Data.PokemonData])] {
        var byNum = [(num: Int32(), pokemons: [Pogoprotos.Data.PokemonData()])]
        for pokemon in self.pokemons {
            if let index = byNum.indexOf({(num: Int32, _: [Pogoprotos.Data.PokemonData]) in pokemon.pokemonId.rawValue == num}) {
                byNum[index].pokemons.append(pokemon)
            } else {
                byNum.append((num: pokemon.pokemonId.rawValue, pokemons: [pokemon]))
            }
        }
        let byNumSorted = byNum.sort({ (tuple1: (num: Int32, pokemons: [Pogoprotos.Data.PokemonData]), tuple2: (num: Int32, pokemons: [Pogoprotos.Data.PokemonData])) -> Bool in
            return tuple1.num < tuple2.num
        })
        var byNumIVSorted = byNumSorted.map { (group: (num: Int32, pokemons: Array<Pogoprotos.Data.PokemonData>)) -> (num: Int32, pokemons: Array<Pogoprotos.Data.PokemonData>) in
            let sortedPokemons = group.pokemons.sort { (p1: Pogoprotos.Data.PokemonData, p2: Pogoprotos.Data.PokemonData) -> Bool in
                return p1.individualAttack + p1.individualDefense + p1.individualStamina > p2.individualAttack + p2.individualDefense + p2.individualStamina
            }
            return (num: group.num, pokemons: sortedPokemons)
        }
        if byNumIVSorted.first?.num == 0 {
            byNumIVSorted.removeAtIndex(0)
        }
        return byNumIVSorted
    }

}


extension PokemonCollectionViewController : UICollectionViewDelegateFlowLayout {
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: 150, height: 183)
//    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

}
