//
//  PokedexListVC.swift
//  PokeDex
//
//  Created by user160618 on 11/30/19.
//  Copyright © 2019 unifor2019.2. All rights reserved.
//

import UIKit

class PokedexListVC: UITableViewController {
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    var pokemons = Array<Pokemon>()
    var favoritePokemons = Array<Pokemon>()
    var currentPokemon = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPokemons()
    }
    
    
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        let tag = sender.tag
        let favoritePokemon = Pokemon(pokedexID: tag)
        favoritePokemon.downloadDetails {
            self.favoritePokemons.append(favoritePokemon)
        }
    }
    
    @IBAction func SegmentedChange(_ sender: Any) {
        tableView.reloadData()
    }
    
    func loadOne(){
        let aPokemon = Pokemon(pokedexID: 1)
        self.pokemons.append(aPokemon)
        aPokemon.downloadDetails {
            self.tableView.reloadData()
        }
    }
    
    func loadPokemons(){
        if (currentPokemon <= 151) {
            let start = currentPokemon + 1
            let end = currentPokemon + 7
            print("Loading Pokemons: ", terminator: "")
            for i in start...end {
                let newPokemon = Pokemon(pokedexID: i)
                self.pokemons.append(newPokemon)
                newPokemon.printLoaded()
                newPokemon.downloadDetails {
                    self.tableView.reloadData()
                }
            }
            currentPokemon = end + 1
            print("")
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = pokemons.count - 1
        if indexPath.row == lastElement {
            loadPokemons()
        }
    }
    
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         if segmentedController.selectedSegmentIndex == 0 {
            return self.pokemons.count
        }else if segmentedController.selectedSegmentIndex == 1 {
            return self.favoritePokemons.count
        }
        return 0
    }

    @IBAction func shareButtonClicked(_ sender: UIButton) {
        // text to share
        let tag = sender.tag
               let text = "https://pokemondb.net/pokedex/\(tag)"

               // set up activity view controller
               let textToShare = [ text ]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

               // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

               // present the view controller
               self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell", for: indexPath) as! PokedexListCell
        if segmentedController.selectedSegmentIndex == 0 {
            let pokemon = self.pokemons[indexPath.row]
            cell.listNameLabel.text = pokemon.name
            cell.listImage.image = pokemon.img
            cell.Id = pokemon.pokedexId
            cell.btnFavorites.tag = pokemon.pokedexId
            cell.btnShare.tag = pokemon.pokedexId
            cell.btnFavorites.isHidden = false
        }else if segmentedController.selectedSegmentIndex == 1 {
            let pokemon = self.favoritePokemons[indexPath.row]
            cell.listNameLabel.text = pokemon.name
            cell.listImage.image = pokemon.img
            cell.Id = pokemon.pokedexId
            cell.btnShare.tag = pokemon.pokedexId
            cell.btnFavorites.isHidden = true
        }

        return cell
    }
    
    let pokemonDetailIdentifier = "OpenDetailSegue"
    
    // MARK: - Segue
    var Entry = String()
    
    func defineEntry(id: Int){
        Entry = pokemons[id].Entry
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segmentedController.selectedSegmentIndex == 0 {
            if segue.identifier == pokemonDetailIdentifier,
                let destination = segue.destination as? PokemonDetailVC,
                let pokemonIndex = tableView.indexPathForSelectedRow?.row {
                    destination.pokemonName = pokemons[pokemonIndex].name
                    destination.pokemonImage = pokemons[pokemonIndex].img!
                    destination.pokemonType = pokemons[pokemonIndex].type
                    destination.pokemonHeight = pokemons[pokemonIndex].height
                    destination.pokemonWeight = pokemons[pokemonIndex].weight
                    destination.pokemonId = pokemons[pokemonIndex].pokedexId
                destination.pokemonEvolution = pokemons[pokemonIndex].Evolution
        }
        }else if segmentedController.selectedSegmentIndex == 1 {
            if segue.identifier == pokemonDetailIdentifier,
                let destination = segue.destination as? PokemonDetailVC,
                let pokemonIndex = tableView.indexPathForSelectedRow?.row {
                    destination.pokemonName = favoritePokemons[pokemonIndex].name
                    destination.pokemonImage = favoritePokemons[pokemonIndex].img!
                    destination.pokemonType = favoritePokemons[pokemonIndex].type
                    destination.pokemonHeight = favoritePokemons[pokemonIndex].height
                    destination.pokemonWeight = favoritePokemons[pokemonIndex].weight
                    destination.pokemonId = favoritePokemons[pokemonIndex].pokedexId
                destination.pokemonEvolution = pokemons[pokemonIndex].Evolution
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.favoritePokemons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if segmentedController.selectedSegmentIndex == 0 {
            return false
        }else if segmentedController.selectedSegmentIndex == 1 {
            return true
        }
        return false
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
