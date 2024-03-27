//
//  ViewController.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 11/03/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var list : PokemonListData?
    var selectedPokemon = 0
    
    var allPokemons : [PokemonModel] = []
    var somePokemons : [PokemonModel] = []
    var shownPokemons : [PokemonModel] = []
    
    var requestManager = RequestManager()
    
    let queue = DispatchQueue(label: "pokemonUpdater")
    var timer = Timer()
    
    var allPokemonsInDisplay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shownPokemons = allPokemons
        
        searchTextField.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.PokemonCell, bundle: nil), forCellReuseIdentifier: K.PokemonCell)
        
        requestManager.delegate = self
        requestManager.fetchData(for: .pokemonList(K.firstPage))
    }
    
    func requestNextPage() {
        guard let nextPage = list?.next else { return }
        print(nextPage)
        list?.next = nil
        requestManager.fetchData(for: RequestType.pokemonList(nextPage))
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    
}

//MARK: - RequestManagerDelegate

extension ViewController : RequestManagerDelegate {
    func didUpdate(data: Any) {
        if let pokemonList = data as? PokemonListData{
            list = pokemonList
            for pokemon in pokemonList.results {
                let url = pokemon.url
                let name = pokemon.name
                let newPokemon = PokemonModel(name: name, url: url)
                newPokemon.delegade = self
                newPokemon.updatePokemon()
                allPokemons.append(newPokemon)
            }
            shownPokemons = allPokemons
            allPokemonsInDisplay = true
        } else if let type = data as? TypeData {
            for pokemon in type.pokemon {
                let url = pokemon.pokemon.url
                let name = pokemon.pokemon.name
                let newPokemon = PokemonModel(name: name, url: url)
                newPokemon.delegade = self
                newPokemon.updatePokemon()
                somePokemons.append(newPokemon)
            }
            shownPokemons = somePokemons
            allPokemonsInDisplay = false
        } else if let pokemon = data as? PokemonData {
            let newPokemon = PokemonModel(name: pokemon.name, url: K.pokemonUrl + pokemon.name)
            newPokemon.delegade = self
            newPokemon.updatePokemon()
            somePokemons.append(newPokemon)
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
        let pokemon = shownPokemons[indexPath.row]
        if !pokemon.updateCalled{
            pokemon.updatePokemon()
            cell.isHidden = true
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
            cell.isHidden = false
            cell.id.text = String(format: "#%03d", pokemon.id)
            cell.name.text = pokemon.name.capitalized
            cell.sprite.image = pokemon.sprites[0]
            cell.background.backgroundColor = pokemon.getColor()
            cell.background.layer.cornerRadius = 10
            
            if let type = pokemon.type1 {
                cell.type1.image = UIImage(named: type)
            }
            if let type2 = pokemon.type2{
                cell.type2.image = UIImage(named: type2)
            } else {
                cell.type2.image = nil
            }
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
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: K.PokemonViewSegue, sender: self)
        }
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

//MARK: -UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Search"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var search = searchTextField.text else { return }
        search = search.lowercased()
        somePokemons = []
        shownPokemons = []
        if K.types.contains(search){
            print(1)
            requestManager.fetchData(for: .type(search))
            tableView.reloadData()
        } else {
            search = K.pokemonUrl + search
            requestManager.fetchData(for: .pokemon(search))
        }
        searchTextField.text = ""
    }
}
