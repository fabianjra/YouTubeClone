//
//  Utils.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 28/9/22.
//

import Foundation


/// Imprime en consola un error de un Catch.
/// - Parameters:
///   - message: Mensaje opcional a parte del errro del catch.
///   - err: Error que retorna el Catch del Try.
func EscribirCatchException(_ message: String? = nil, err: Error) {
    print("Error en un catch: \(message ?? "")", err)
}

//Convertir el JSON a un tipo de dato especifico para poder ser utilizado por Swift.
class Utils {
    
    /// Metodo estatico, por lo que no requiere instancia.
    /// - Parameters:
    ///   - jsonName: nombre del archivo.
    ///   - model: Tipo de objeto al que se quiere convertir el archivo.
    /// - Returns: Retorna un objeto opcional, por lo que la respuesta puede ser nil.
    static func parseJson<T: Decodable>(jsonName: String, model: T.Type) -> T? {
        
        //lee un archivo que esta en el Bundle, pasandole un nombre y el tipo de extension.
        guard let url = Bundle.main.url(forResource: jsonName, withExtension: "json") else {
            return nil
        }
        
        do {
            //Lee la URL donde está el archivo y lo convierte en "data".
            let data = try Data(contentsOf: url)
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let responseModel = try jsonDecoder.decode(T.self, from: data)
                return responseModel
            }catch{
                EscribirCatchException("json mock: ", err: error)
                return nil
            }
        }catch{
            return nil
        }
    }
}
