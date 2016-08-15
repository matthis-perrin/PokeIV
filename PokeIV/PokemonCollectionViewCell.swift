//
//  PokemonCollectionViewCell.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/11/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    var pokemonPreviewController: PokemonPreviewViewController!
    
    internal func setPokemon(pokemon: Pokemon) {
        if (self.pokemonPreviewController == nil) {
            self.pokemonPreviewController = PokemonPreviewViewController()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let id = "pokemonPreviewViewController"
            self.pokemonPreviewController = storyboard.instantiateViewControllerWithIdentifier(id) as! PokemonPreviewViewController
            self.pokemonPreviewController.view.frame = self.contentView.bounds
            self.contentView.addSubview(self.pokemonPreviewController.view)
        }
        self.pokemonPreviewController.pokemon = pokemon
    }
    
}
