//
//  ViewController.swift
//  PokeDex
//
//  Created by user160618 on 11/30/19.
//  Copyright © 2019 unifor2019.2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var myPokemon = Pokemon(pokedexID: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        myPokemon.downloadDetails {
            print("Funcionou")
        }
    }


}

