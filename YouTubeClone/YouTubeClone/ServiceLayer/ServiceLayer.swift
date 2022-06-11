//
//  Provider.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import Foundation

import UIKit

@MainActor
class ServiceLayer{
    
    //Generic Types. (T) -> Se le pasa el tipo de modelo, de manera generica, para que traiga un objeto de ese tipo.
    //Esto evita que se cree un callService para cada tipo de modelo.
    static func callService<T: Decodable>(_ requestModel: RequestModel, _ modelType: T.Type) async throws -> T{
        
        //Get query parameters
        var serviceURL = URLComponents(string: requestModel.getURL())
        serviceURL?.queryItems = buildQueryItems(params: requestModel.queryItems ?? [:])
        serviceURL?.queryItems?.append(URLQueryItem(name: "key", value: Constants.apiKey))
        
        //Unwrap URL
        guard let componentURL = serviceURL?.url else{
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: componentURL)
        request.httpMethod = requestModel.httpMethod.rawValue
        
        do {
            //Async -- Await funciona desde iOS15 en adelante.
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else{
                throw NetworkError.httpResponseError
            }
            
            if(httpResponse.statusCode > 299){
                throw NetworkError.statusCodeError
            }
            
            let decoder = JSONDecoder()
            
            do{
                let decodeData = try decoder.decode(T.self, from: data)
                return decodeData
            }catch{
                print(error)
                throw NetworkError.couldNotDecodeData
            }
            
        }catch{
            throw NetworkError.generic
        }
        
    }
    
    static func buildQueryItems(params: [String:String]) -> [URLQueryItem]{
        let items = params.map({URLQueryItem(name: $0, value: $1)})
        return items
    }
}
