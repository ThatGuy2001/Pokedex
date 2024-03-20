//
//  RequestManager.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 12/03/2024.
//

import UIKit

//MARK: - RequestType

enum RequestType {
    case pokemonList (String)
    case pokemon (String)
    case pokemonMoves (String)
    case pokemonFullData (String)
    case sprite (String, SpriteType)
}

//MARK: - RequestManagerDelegate

protocol RequestManagerDelegate {
    func didUpdate( data : Any)
    func didFailWithError(error : Error)
}

//MARK: - RequestManager

struct RequestManager {
    
    var delegate : RequestManagerDelegate?
    
    func fetchData(for request : RequestType) {
        let urlString = getRequestURL(for : request)
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, reponse, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let data {
                    if let decodedData = parseJSON(data: data, request: request){
                        delegate?.didUpdate(data: decodedData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getRequestURL(for request : RequestType ) -> String {
        switch request {
        case .pokemonList(let url):
            return url
        case .pokemon(let url):
            return url
        case .sprite(let url,_):
            return url
        case .pokemonFullData(let url):
            return url
        case .pokemonMoves(let url):
            return url
        }
    }
    
    func parseJSON(data : Data, request : RequestType) -> Any? {
        let decoder = JSONDecoder()
        do {
            switch request {
            case .pokemonList:
                return try decoder.decode(PokemonListData.self, from: data)
            case .pokemon:
                return try decoder.decode(PokemonData.self, from: data)
            case .sprite(_, let spriteType):
                if let image = UIImage(data: data) {
                    return SpriteModel(sprite: image, type: spriteType)
                }
                return nil
            case .pokemonFullData:
                return try decoder.decode(PokemonStats.self , from: data)
            case .pokemonMoves:
                return try decoder.decode(PokemonMoves.self, from: data)
            }
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}




