//
//  ViewController.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 11/03/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var list : PokemonListData?
    var pokemons : [PokemonModel] = []
    var selectedPokemon = 0
    
    var requestManager = RequestManager()
    
    let queue = DispatchQueue(label: "pokemonUpdater")
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.PokemonCell, bundle: nil), forCellReuseIdentifier: K.PokemonCell)
        
        requestManager.delegate = self
        requestManager.fetchData(for: .pokemonList(K.firstPage))
    }
    
    func requestNextPage() {
        if let nextPage = list?.next {
            let request = RequestType.pokemonList(nextPage)
            requestManager.fetchData(for: request)
        } else {
            return
        }
    }
    
    
    func updateAllPokemons() {
        print("Updating All Pokemons")
        for pokemon in pokemons {
            if !pokemon.updateEnded{
                pokemon.updatePokemon()
            }
        }
        print("Update Complete")
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
                pokemons.append(newPokemon)
            }
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
        destinationVC.pokemon = pokemons[selectedPokemon]
    }
}

// MARK: -

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let pokemon = pokemons[indexPath.row]
        if !pokemon.updateCalled{
            pokemon.updatePokemon()
            cell.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(pokemons[indexPath.row].name)
        selectedPokemon = indexPath.row
        performSegue(withIdentifier: K.PokemonViewSegue, sender: self)
    }
}

//MARK: - UITableViewDataSource

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.PokemonCell, for: indexPath) as! PokemonCell
        if pokemons.count-10 == indexPath.row {
            requestNextPage()
        }
        let pokemon = pokemons[indexPath.row]
        
        if !pokemon.updateCalled{
            pokemon.updatePokemon()
            cell.isHidden = true
            return cell
        }
        
        if pokemon.updateEnded {
            cell.isHidden = false
            cell.id.text = String(pokemon.id!)
            cell.name.text = pokemon.name
            
            cell.sprite.image = pokemon.front
            
            if let type = pokemon.type1{
                cell.type1.image = UIImage(named: type)
            }
            if let type2 = pokemon.type2{
                cell.type2.image = UIImage(named: type2)
            } else {
                cell.type2.image = nil
            }
        }
        return cell
        
    }
}

//MARK: - PokemonModelDelegate

extension ViewController : PokemonModelDelegate {
    func didEndUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didNotUpdate() {
        print("Erro")
    }
}
