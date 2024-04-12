//
//  ViewController.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 11/03/2024.
//
import UIKit
import Alamofire

enum SpriteType {
    case male
    case maleShiny
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var initiated = false
    var pokemonInDisplay : PokemonModel?
    var pokemonList : PokemonListData?
    var allPokemons : [PokemonModel] = []
    var somePokemons : [PokemonModel] = []
    var shownPokemons : [PokemonModel] = []
    var allPokemonsInDisplay = true
    var selectedCell : PokemonCell?
    
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
    @IBOutlet weak var favButton: UIButton!
    
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
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        shownPokemons = allPokemons
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.identifiers.PokemonCell, bundle: nil), forCellReuseIdentifier: K.identifiers.PokemonCell)
        
        AF.request(K.url.firstPage).responseDecodable(of: PokemonListData.self) { response in
            guard let response = response.value else { return }
            self.pokemonListHandler(response)
        }
    }
    
    func showPokemon(_ pokemon: PokemonModel) {
        pokemonInDisplay = pokemon
        setStatusView(pokemon: pokemon)
        setPokemonView(pokemon: pokemon)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PokemonInfoView
        guard let pokemon = pokemonInDisplay else { return }
        destinationVC.pokemon = pokemon
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer)  {
        if gesture.direction == .left {
                goToPokemonInfo()
           }
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
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        guard let pokemonInDisplay else { return }
        
        if !pokemonInDisplay.isFavorite() {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
        }
        pokemonInDisplay.changeFavoriteStatus()
    }
    
    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        
        if allPokemonsInDisplay == false {
            searchButton.setSymbolImage(UIImage(systemName: "magnifyingglass")!, contentTransition: .automatic)
            allPokemonsInDisplay = true
            shownPokemons = allPokemons
            initiated = false
            updateTableView()
            return
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
            self.searchPokemons(search.lowercased())
        }))
        
        present(alertBox, animated: true)
        
        searchButton.setSymbolImage(UIImage(systemName: "arrow.counterclockwise")!, contentTransition: .automatic)
    }
    
    
    @IBAction func moreInfoPressed(_ sender: UIButton) {
        goToPokemonInfo()
    }
    
    func goToPokemonInfo() {
        guard let pokemon = pokemonInDisplay else { return }
        if pokemon.speciesStatus == .notCaled {
            pokemon.getSpeciesInfo {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: K.identifiers.PokemonInfoSegue, sender: self)
                       }
            }
        } else if pokemon.speciesStatus == .concluded {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: K.identifiers.PokemonInfoSegue, sender: self)
                   }
        }
    }
    
    //MARK: - Layout
    
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
        
        if pokemon.isFavorite() {
            favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func setStatusView(pokemon: PokemonModel) {
        
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
                choseLayout()
    }
    
    func changeLayout(_ w1: CGFloat, _ h1: CGFloat, _ w2: CGFloat, _ h2: CGFloat, _ w3: CGFloat ) {
        pokemonViewWidth = pokemonViewWidth.setMultiplier(multiplier: w1)
        pokemonViewHeight = pokemonViewHeight.setMultiplier(multiplier: h1)
        statsViewWidth = statsViewWidth.setMultiplier(multiplier: w2)
        statsViewHeight = statsViewHeight.setMultiplier(multiplier: h2)
        tableViewWidth = tableViewWidth.setMultiplier(multiplier: w3)
        view.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        choseLayout()
        guard let pokemonInDisplay else {return}
        setPokemonView(pokemon: pokemonInDisplay)
    }
    
    func choseLayout(){
        if UIDevice.current.orientation.isLandscape {
            changeLayout(0.45, 1, 0.45, 1, 0.1)
        } else {
            changeLayout(0.8, 0.5, 0.8, 0.5, 0.2)
        }
    }
    
    //MARK: - Requests
    
    func requestNextPage() {
        guard let nextPage = pokemonList?.next else { return }
        pokemonList?.next = nil
        AF.request(nextPage).responseDecodable(of: PokemonListData.self) { response in
            guard let response = response.value else { return }
            self.pokemonListHandler(response)
        }
    }
    
    func pokemonListHandler( _ pokemonList : PokemonListData) {
        self.pokemonList = pokemonList
        for pokemon in pokemonList.results {
            let name = pokemon.name
            let newPokemon = PokemonModel(name: name)
            updatePokemon(newPokemon)
            allPokemons.append(newPokemon)
        }
        shownPokemons = allPokemons
        updateTableView()
    }
    
    
    func searchPokemons(_ search : String) {
        somePokemons = []
        if K.types.contains(search.lowercased()){
            AF.request(K.url.type + search).responseDecodable(of: TypeData.self) { response in
                guard let response = response.value else {return}
                self.pokemonByTypeHandler(response)
            }
        } else {
            AF.request(K.url.pokemon + search).responseDecodable(of: PokemonData.self) { response in
                guard let response = response.value else {return}
                self.pokemonHandler(response)
            }
        }
    }
    
    func pokemonByTypeHandler(_ pokemonTypeList : TypeData ){
        for pokemon in pokemonTypeList.pokemon {
            let name = pokemon.pokemon.name
            let newPokemon = PokemonModel(name: name)
            somePokemons.append(newPokemon)
        }
        for i in 0..<10 {
            let pokemon = somePokemons[i]
            updatePokemon(pokemon)
        }
        shownPokemons = somePokemons
        initiated = false
        allPokemonsInDisplay = false
    }

    func pokemonHandler(_ pokemon : PokemonData) {
            let newPokemon = PokemonModel(name: pokemon.name)
            updatePokemon(newPokemon)
            somePokemons.append(newPokemon)
            shownPokemons = somePokemons
            allPokemonsInDisplay = false
    }
    
    func updatePokemon(_ pokemon : PokemonModel) {
        pokemon.updatePokemon{
            pokemon.updateSprites {
                self.updateTableView()
            }
        }
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

    
}

// MARK: - UITableViewDelegate

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        for i in index..<index+10 {
            if i < shownPokemons.count {
                let pokemon = shownPokemons[i]
                if pokemon.updateStatus == .baseInfo {
                    updatePokemon(pokemon)
                    cell.isHidden = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let lastSelectedCell = selectedCell {
            lastSelectedCell.selectedBackground.backgroundColor = UIColor(named: "clear")
        }
        
        let currentCell = tableView.cellForRow(at:indexPath) as! PokemonCell
        selectedCell = currentCell
        
        pokemonInDisplay = shownPokemons[indexPath.row]
        guard let pokemon = pokemonInDisplay else { return }
        //currentCell.selectedBackground.backgroundColor = .white
        showPokemon(pokemon)
    }
}

//MARK: - UITableViewDataSource

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownPokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.PokemonCell, for: indexPath) as! PokemonCell
        cell.selectedBackground.backgroundColor = UIColor(named: "clear")
        let pokemon = shownPokemons[indexPath.row]
        
        if pokemon.updateStatus == .baseInfo {
            pokemon.updatePokemon {
                pokemon.updateSprites {
                    self.updateTableView()
                }
            }
            cell.isHidden = true
            return cell
        }
        
        if pokemon.updateStatus == .updateEnded {
            
            if indexPath.row == 0  && !initiated{
                initiated = true
                showPokemon(pokemon)
            }
        
            cell.sprite.image = pokemon.sprites.male
            cell.background.backgroundColor = pokemon.getColor()
            cell.background.layer.cornerRadius = 4
        }
        
        if allPokemons.count-20 < indexPath.row && allPokemonsInDisplay{
            requestNextPage()
        }
        
        return cell
    }
}


