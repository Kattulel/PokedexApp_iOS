//
//  Pokemon.swift
//  PokeDex
//
//  Created by user160618 on 11/30/19.
//  Copyright © 2019 unifor2019.2. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

class Pokemon {
    
    var name: String = ""
    var nameNorm: String = ""
    var pokedexId: Int
    var description: String = ""
    var type: String = ""
    var defense: String = ""
    var height: String = ""
    var weight: String = ""
    var attack: String = ""
    var nextEvolutionText: String = ""
    var img: UIImage? = nil
    var Entry: String = ""
    var Evolution: String = ""
    var EvolvesFrom: String = ""

    
    init(pokedexID: Int){
        self.pokedexId = pokedexID
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        //print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent, "Downloaded")
            //print("Download Finished")
            DispatchQueue.main.async() {
                self.img = UIImage(data: data)!
            }
        }
    }
    
   func downloadDetails(completed: @escaping ()->()){
        AF.request("https://pokeapi.co/api/v2/pokemon/"+String(pokedexId)).responseJSON(completionHandler: { response in
            //print(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let height = json["height"].int
                let weight = json["weight"].int
                let type = json["types"][0]["type"]["name"].string
                let defense = json["stats"][3]["base_stat"].int
                let attack = json["stats"][0]["base_stat"].int
                let name = json["name"].string
                let img_url = json["sprites"]["front_default"].string
                self.name = name!.capitalizingFirstLetter()
                self.nameNorm = name!
                self.height = "\(height ?? 0)"
                self.weight = "\(weight ?? 0)"
                self.type = type!
                self.defense = "\(defense ?? 0)"
                self.attack = "\(attack ?? 0)"
                self.downloadImage(from: URL(string: img_url!)!)
                self.getPokemonEvolutionChainLink()
                //self.printLoaded()
            case .failure(let error):
                print(error)
            }
            completed()
        })
    }
    
    public func getPokedexEntry(completed: @escaping () -> ()) {
        AF.request("https://pokeapi.co/api/v2/pokemon-species/"+String(pokedexId)).responseJSON(completionHandler: { response in
        print(response)
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            let newEntry = json["flavor_text_entries"][1]["flavor_text"].string
            self.Entry = newEntry!
        case .failure(let error):
            print(error)
        }
            completed()
        })
    }
    
    public func getPokemonEvolutionChainLink(){
    AF.request("https://pokeapi.co/api/v2/pokemon-species/"+String(pokedexId)).responseJSON(completionHandler: { response in
            print(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let newChain = json["evolution_chain"]["url"].string
                let EvolvesFrom = json["evolves_from_species"]["name"].string
                self.getPokemonEvolution(chain: newChain!)
                self.EvolvesFrom = EvolvesFrom ?? "null"
            case .failure(let error):
                print(error)
            }
            
            })
        }
    
    public func getPokemonEvolution(chain: String) {
        AF.request(chain).responseJSON(completionHandler: { response in
            //print(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var Evolution = json["chain"]["evolves_to"][0]["species"]["name"].string
                if self.nameNorm == Evolution {
                    Evolution = json["chain"]["evolves_to"][0]["evolves_to"][0]["species"]["name"].string
                    if self.nameNorm == Evolution {
                        Evolution = ""
                    }
                }
                if Evolution != nil {
                    if Evolution == self.EvolvesFrom {
                       self.Evolution = ""
                    }else{
                        self.Evolution = Evolution!.capitalizingFirstLetter()
                    }
                }
            case .failure(let error):
                print(error)
            }
            })
    }
    
    public func printPokemon(){
        print("Name: "+self.name, "Loaded")
        //print("Height: "+self.height)
        //print("Weight: "+self.weight)
        //print("Type: "+self.type)
        //print("Defense: "+self.defense)
        //print("Attack: "+self.attack)
    }
    
    public func printLoaded(){
        print(self.pokedexId, "..", terminator:"")
    }
        
}

