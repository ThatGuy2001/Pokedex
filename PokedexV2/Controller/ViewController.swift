//
//  ViewController.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 11/03/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedPokemon = 0
    
    var pokemonList : PokemonListData?
    var allPokemons : [PokemonModel] = []
    var somePokemons : [PokemonModel] = []
    var shownPokemons : [PokemonModel] = []
    var allPokemonsInDisplay = true
    
    var requestManager = RequestManager()
    
    // layout constraits
    
    @IBOutlet weak var statsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var statsViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var pokemonViewWidth: NSLayoutConstraint!
    @IBOutlet weak var pokemonViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shownPokemons = allPokemons
//        resetSearchButton.isHidden = true
        
//        searchTextField.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.PokemonCell, bundle: nil), forCellReuseIdentifier: K.PokemonCell)
        
        requestManager.delegate = self
        requestManager.fetchData(for: .pokemonList(K.firstPage))
        
        

    }
    
    func requestNextPage() {
        guard let nextPage = pokemonList?.next else { return }
        pokemonList?.next = nil
        requestManager.fetchData(for: RequestType.pokemonList(nextPage))
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
                
                if UIDevice.current.orientation.isLandscape {
                    print("in landscape")
                    pokemonViewWidth = pokemonViewWidth.setMultiplier(multiplier: 0.45)
                    pokemonViewHeight = pokemonViewHeight.setMultiplier(multiplier: 1)
                    statsViewWidth = statsViewWidth.setMultiplier(multiplier: 0.45)
                    statsViewHeight = statsViewHeight.setMultiplier(multiplier: 1)
                    tableViewWidth = tableViewWidth.setMultiplier(multiplier: 0.10)
                    view.layoutIfNeeded()
                } else {
                    pokemonViewWidth = pokemonViewWidth.setMultiplier(multiplier: 0.8)
                    pokemonViewHeight = pokemonViewHeight.setMultiplier(multiplier: 0.5)
                    statsViewWidth = statsViewWidth.setMultiplier(multiplier: 0.8)
                    statsViewHeight = statsViewHeight.setMultiplier(multiplier: 0.5)
                    tableViewWidth = tableViewWidth.setMultiplier(multiplier: 0.2)
                    view.layoutIfNeeded()
                }
        }
        
}

//MARK: - RequestManagerDelegate

extension ViewController : RequestManagerDelegate {
    func didUpdate(data: Any) {
        if let pokemonList = data as? PokemonListData{
            self.pokemonList = pokemonList
            for pokemon in pokemonList.results {
                let name = pokemon.name
                let newPokemon = PokemonModel(name: name)
                newPokemon.delegade = self
                newPokemon.updatePokemon()
                allPokemons.append(newPokemon)
            }
            shownPokemons = allPokemons
            allPokemonsInDisplay = true
        } else if let type = data as? TypeData {
            for pokemon in type.pokemon {
                let name = pokemon.pokemon.name
                let newPokemon = PokemonModel(name: name)
                newPokemon.delegade = self
                somePokemons.append(newPokemon)
            }
            for i in 0..<10 {
                somePokemons[i].updatePokemon()
            }
            shownPokemons = somePokemons
            allPokemonsInDisplay = false
        } else if let pokemon = data as? PokemonData {
            let newPokemon = PokemonModel(name: pokemon.name)
            newPokemon.delegade = self
            newPokemon.updatePokemon()
            somePokemons.append(newPokemon)
            shownPokemons = somePokemons
            allPokemonsInDisplay = false
        } else if let pokedex = data as? PokedexData {
            for pokemon in pokedex.pokemon_entries {
                let name = pokemon.pokemon_species.name
                let newPokemon = PokemonModel(name: name)
                newPokemon.delegade = self
                somePokemons.append(newPokemon)
            }
            for i in 0..<10 {
                somePokemons[i].updatePokemon()
            }
            shownPokemons = somePokemons
            allPokemonsInDisplay = false
        } 
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PokemonViewController
        destinationVC.pokemon = shownPokemons[selectedPokemon]
    }
    
}

// MARK: - UITableViewDelegate

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        for i in index..<index+3 {
            if i < shownPokemons.count {
                let pokemon = shownPokemons[i]
                if !pokemon.updateCalled{
                    pokemon.updatePokemon()
                    cell.isHidden = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPokemon = indexPath.row
        shownPokemons[indexPath.row].fetchPokemonStats()
    }
}

//MARK: - UITableViewDataSource

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownPokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.PokemonCell, for: indexPath) as! PokemonCell
        let pokemon = shownPokemons[indexPath.row]
        
        if !pokemon.updateCalled{
            pokemon.updatePokemon()
            cell.isHidden = true
            return cell
        }
        
        if pokemon.updateEnded {
            cell.sprite.image = pokemon.sprites[0]
            cell.background.backgroundColor = pokemon.getColor()
            cell.background.layer.cornerRadius = 10
        }
        
        if allPokemons.count-10 == indexPath.row && allPokemonsInDisplay{
            requestNextPage()
        }
        
        return cell
    }
}

//MARK: - PokemonModelDelegate

extension ViewController : PokemonModelDelegate {
    func didUpdateMoves() {
        print("Should not have been called")
    }
    
    func didUpdateStats() {
        print("Should not have been called")
    }
    
    func didEndUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didNotUpdate() {
        print("Erro")
    }
}

////MARK: -UITextFieldDelegate
//extension ViewController: UITextFieldDelegate {
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchTextField.endEditing(true)
//        return true
//    }
//    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != "" {
//            return true
//        } else {
//            textField.placeholder = "Search"
//            return false
//        }
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard var search = searchTextField.text else { return }
//        search = search.lowercased()
//        somePokemons = []
//        shownPokemons = []
//        allPokemonsInDisplay = false
//        resetSearchButton.isHidden = false
//        if K.types.contains(search){
//            requestManager.fetchData(for: .type(search))
//        } else {
//            requestManager.fetchData(for: .pokemon(search))
//        }
//        searchTextField.text = ""
//    }
//}


extension NSLayoutConstraint {
    
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        newConstraint.isActive = true
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
}
