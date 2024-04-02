//
//  ViewController.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 11/03/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var pokemonInDisplay : PokemonModel?
    
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
    
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    // Pokemon Info View Outlets
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sprite: UIImageView!
    var spriteType = SpriteType.male
    @IBOutlet weak var type1: UIImageView!
    @IBOutlet weak var type2: UIImageView!
    
    @IBOutlet weak var pokemonView: UIView!
    @IBOutlet weak var statsView: UIView!
    
    // Stats Bars
    @IBOutlet weak var hpBar: UIProgressView!
    @IBOutlet weak var atkBar: UIProgressView!
    @IBOutlet weak var defBar: UIProgressView!
    @IBOutlet weak var spAtkBar: UIProgressView!
    @IBOutlet weak var spDefBar: UIProgressView!
    @IBOutlet weak var speedBar: UIProgressView!
    
    // Stats Labels
    @IBOutlet weak var hp: UILabel!
    @IBOutlet weak var atk: UILabel!
    @IBOutlet weak var def: UILabel!
    @IBOutlet weak var spAtk: UILabel!
    @IBOutlet weak var spDef: UILabel!
    @IBOutlet weak var speed: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shownPokemons = allPokemons
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.identifiers.PokemonCell, bundle: nil), forCellReuseIdentifier: K.identifiers.PokemonCell)
        
        requestManager.delegate = self
        requestManager.fetchData(for: .pokemonList(K.url.firstPage))
        
        statsView.isHidden = true
        pokemonView.isHidden = true
    }
    
    func requestNextPage() {
        guard let nextPage = pokemonList?.next else { return }
        pokemonList?.next = nil
        requestManager.fetchData(for: RequestType.pokemonList(nextPage))
    }
    
    func setPokemonView(pokemon: PokemonModel){
        id.text = String(format: "#%03d", pokemon.id)
        name.text = pokemon.name.capitalized
        sprite.image = pokemon.sprites.male
        spriteType = .male
        pokemonView.backgroundColor = pokemon.getColor()
        if let type1 = pokemon.type1 {
            self.type1.image = UIImage(named: type1)
        }
        if let type2 = pokemon.type2 {
            self.type2.isHidden = false
            self.type2.image = UIImage(named: type2)
        } else {
            type2.isHidden = true
        }
    }
    
    func setStatusView(pokemon: PokemonModel){
        
        let statsLabels = [hp,atk,def,spAtk,spDef,speed]
        
        hpBar.progress = pokemon.getHp()
        atkBar.progress = pokemon.getAtk()
        defBar.progress = pokemon.getDef()
        spAtkBar.progress = pokemon.getSpAtk()
        spDefBar.progress = pokemon.getSpDef()
        speedBar.progress = pokemon.getSpeed()
        
        for i in 0..<6 {
            statsLabels[i]?.text = String(format: "%3d", pokemon.stats[i])
        }
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
                if UIDevice.current.orientation.isLandscape {
                    changeLayout(0.45, 1, 0.45, 1, 0.1)
                } else {
                    changeLayout(0.8, 0.5, 0.8, 0.5, 0.2)
                }
    }
    
    func changeLayout(_ w1: CGFloat, _ h1: CGFloat, _ w2: CGFloat, _ h2: CGFloat, _ w3: CGFloat ) {
        pokemonViewWidth = pokemonViewWidth.setMultiplier(multiplier: w1)
        pokemonViewHeight = pokemonViewHeight.setMultiplier(multiplier: h1)
        statsViewWidth = statsViewWidth.setMultiplier(multiplier: w2)
        statsViewHeight = statsViewHeight.setMultiplier(multiplier: h2)
        tableViewWidth = tableViewWidth.setMultiplier(multiplier: w3)
        view.layoutIfNeeded()
    }
    
    @IBAction func spriteTapped(_ sender: UITapGestureRecognizer) {
        guard let pokemonInDisplay else { return  }
        if spriteType == .male {
            sprite.image = pokemonInDisplay.sprites.maleShiny
            spriteType = .maleShiny
        } else {
            sprite.image = pokemonInDisplay.sprites.male
            spriteType = .male
        }
    }
    

    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        
        if allPokemonsInDisplay == false {
            allPokemonsInDisplay = true
            shownPokemons = allPokemons
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let alertBox = UIAlertController (title: "Search", message: "Search Pokemon by type or name", preferredStyle: .alert)
        
        alertBox.addTextField { field in
            field.placeholder = "Search..."
            field.returnKeyType = .continue
        }
        
        alertBox.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertBox.addAction(UIAlertAction(title: "Search", style: .default, handler:{_ in
            guard let fields = alertBox.textFields else { return }
            let searchField = fields[0]
            
            guard let search = searchField.text, !search.isEmpty else { return }
            
            print(search)
            self.searchPokemons(search)
        }))
        
        present(alertBox, animated: true)
    }
    
    func searchPokemons(_ search : String) {
        somePokemons = []
        shownPokemons = []
        allPokemonsInDisplay = false
        if K.types.contains(search.lowercased()){
            requestManager.fetchData(for: .type(search))
        } else {
            requestManager.fetchData(for: .pokemon(search))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PokemonInfoView
        guard let pokemon = pokemonInDisplay else { return }
        destinationVC.pokemon = pokemon
    }
    
    
    @IBAction func moreInfoPressed(_ sender: UIButton) {
        guard let pokemon = pokemonInDisplay else { return }
        if pokemon.speciesStatus == .notCaled {
            pokemon.getSpeciesInfo()
        } else if pokemon.speciesStatus == .concluded {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: K.identifiers.PokemonInfoSegue, sender: self)
                   }
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
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

// MARK: - UITableViewDelegate

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        for i in index..<index+5 {
            if i < shownPokemons.count {
                let pokemon = shownPokemons[i]
                if pokemon.updateStatus == .baseInfo {
                    pokemon.updatePokemon()
                    cell.isHidden = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        statsView.isHidden = false
        pokemonView.isHidden = false
        
        pokemonInDisplay = shownPokemons[indexPath.row]
        guard let pokemon = pokemonInDisplay else { return }
        setPokemonView(pokemon: pokemon)
        setStatusView(pokemon: pokemon)
    }
}

//MARK: - UITableViewDataSource

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownPokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.PokemonCell, for: indexPath) as! PokemonCell
        let pokemon = shownPokemons[indexPath.row]
        
        if pokemon.updateStatus == .baseInfo {
            pokemon.updatePokemon()
            cell.isHidden = true
            return cell
        }
        
        if pokemon.updateStatus == .updateEnded {
            cell.sprite.image = pokemon.sprites.male
            cell.background.backgroundColor = pokemon.getColor()
            cell.background.layer.cornerRadius = 1
        }
        
        if allPokemons.count-10 == indexPath.row && allPokemonsInDisplay{
            requestNextPage()
        }
        
        return cell
    }
}

//MARK: - PokemonModelDelegate

extension ViewController : PokemonModelDelegate {
    func didEndUpdateSpecies() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: K.identifiers.PokemonInfoSegue, sender: self)
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
