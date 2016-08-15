//
//  PokemonCollectionViewController.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PokemonCell"

class PokemonCollectionViewController: UICollectionViewController {

    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerClass(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.loadData()
        self.collectionView?.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        let byNum = self.getPokemonByNum()
        return byNum.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let byNum = self.getPokemonByNum()
        return byNum[section].pokemons.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        if let cell = cell as? PokemonCollectionViewCell {
            cell.setPokemon(self.getPokemonByNum()[indexPath.section].pokemons[indexPath.row])
            cell.backgroundColor = UIColor.redColor()
        } else {
            print("ERROR")
            cell.backgroundColor = UIColor.blueColor()
        }
        
        return cell
    }
    
    
    private func loadData() {
        self.pokemons = [
            Pokemon(num: PokemonNum.BULBASAUR, name: "Bulbasaur", cp: 560, attack: 10, defence: 2, stamina: 8),
            Pokemon(num: PokemonNum.CHARMANDER, name: "Charmander", cp: 570, attack: 10, defence: 2, stamina: 8),
            Pokemon(num: PokemonNum.SQUIRTLE, name: "Squirtle", cp: 580, attack: 10, defence: 2, stamina: 8),
            Pokemon(num: PokemonNum.PIKACHU, name: "Pikachu", cp: 590, attack: 10, defence: 2, stamina: 8),
            Pokemon(num: PokemonNum.PIDGEY, name: "Pidgey", cp: 600, attack: 10, defence: 2, stamina: 8),
            Pokemon(num: PokemonNum.PIDGEY, name: "Pidgey", cp: 610, attack: 10, defence: 2, stamina: 8),
            Pokemon(num: PokemonNum.PIDGEY, name: "Pidgey", cp: 620, attack: 10, defence: 2, stamina: 8),
//            Pokemon(num: PokemonNum.BULBASAUR, name: "Bulbasaur", cp: 630, attack: 10, defence: 2, stamina: 8),
//            Pokemon(num: PokemonNum.BULBASAUR, name: "Bulbasaur", cp: 640, attack: 10, defence: 2, stamina: 8),
        ]
    }
    
    private func getPokemonByNum() -> [(num: PokemonNum, pokemons: [Pokemon])] {
        var byNum = [(num: PokemonNum, pokemons: [Pokemon])]()
        for pokemon in self.pokemons {
            if let index = byNum.indexOf({(num: PokemonNum, _: [Pokemon]) in pokemon.num == num}) {
                byNum[index].pokemons.append(pokemon)
            } else {
                byNum.append((num: pokemon.num, pokemons: [pokemon]))
            }
        }
        let byNumSorted = byNum.sort({ (tuple1: (num: PokemonNum, pokemons: [Pokemon]), tuple2: (num: PokemonNum, pokemons: [Pokemon])) -> Bool in
            return tuple1.num.intValue < tuple2.num.intValue
        })
        return byNumSorted
    }

}


extension PokemonCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 200, height: 250)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

}
