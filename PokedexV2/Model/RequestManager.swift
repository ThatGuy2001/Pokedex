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
    case type (String)
    case pokemon (String)
    case sprite (String, SpriteType)
    case species (String)
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
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, reponse, error in
            if error != nil {
                delegate?.didFailWithError(error: error!)
                return
            }
            guard let data else { return }
            if let decodedData = parseJSON(data: data, request: request){
                delegate?.didUpdate(data: decodedData)
            }
        }
        task.resume()
    }
    
    func getRequestURL(for request : RequestType ) -> String {
        switch request {
        case .pokemonList(let url):
            return url
        case .pokemon(let name):
            return K.url.pokemon + name
        case .sprite(let url ,_):
            return url
        case .type(let type):
            return K.url.type + type
        case .species(let name):
            return K.url.species + name
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
                    guard let image = UIImage(data: data) else { return nil }
                    return SpriteModel(sprite: image, type: spriteType)
                case .type:
                    return try decoder.decode(TypeData.self , from: data)
                case .species(_):
                    return try decoder.decode(SpeciesData.self, from: data)
                }
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
    
}
