//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by user160618 on 12/1/19.
//  Copyright © 2019 unifor2019.2. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var textEntry: UITextView!
    @IBOutlet weak var labelEvolution: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var pokemonId = Int()
    var pokemonName = String()
    var pokemonType = String()
    var pokemonImage = UIImage()
    var pokemonWeight = String()
    var pokemonHeight = String()
    var pokemonEntry = String()
    var pokemonEvolution = String()

    override func viewWillAppear(_ animated: Bool) {
        pokemonType = pokemonType.capitalizingFirstLetter()
        labelName.text = "Name: \(pokemonName)"
        labelType.text = "Type: \(pokemonType)"
        image.image = pokemonImage
        labelHeight.text = "Height: \(pokemonHeight)"
        labelWeight.text = "Weight: \(pokemonWeight)"
        labelEvolution.text = "Evolution: \(pokemonEvolution)"
        getPokedexEntry()
    }
    
    public func getPokedexEntry() {
        AF.request("https://pokeapi.co/api/v2/pokemon-species/"+String(pokemonId)).responseJSON(completionHandler: { response in
        //print(response)
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            let newEntry = json["flavor_text_entries"][1]["flavor_text"].string
            self.pokemonEntry = newEntry!
            self.textEntry.text = self.pokemonEntry
        case .failure(let error):
            print(error)
        }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
