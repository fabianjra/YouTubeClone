//
//  Utils.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 28/9/22.
//

import Foundation

enum Log {
    
    /**
     Shows an Catch error message on console, and an optional string message.
     
     **Notes:**
        - This function takes the file name where the error is presented, the function name who call it and the line number where the error is presented.
        - By default **file**, **function** and **line** are setted internally, so you can ignore these parameters.
     
     **Example:**
     ```swift
     do{
        let article = try JSONDecoder().decode(T.self, from: data)
     
        if let article = article {
            completion(article)
        }
        } catch {
            Log.WriteCatchExeption(err: error)
     }
     ```
     
     - Parameters:
        - message:Optional string message to add to the print.
        - error: The catch error message from the try.
     
     - Returns: Void
     
     - Warning: N/A
     
     - Throws: N/A
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: February 2023
     */
    static func WriteCatchExeption(_ message: String? = nil, file: String = #file, function: String = #function, line: Int = #line, error: Error) {
        print("Error in catch - \(message ?? ""), called by: \(file.components(separatedBy: "/").last ?? file) - \(function), at line: \(line). Description: ", error)
    }
    
    /**
     Shows an error message on console.
     
     **Notes:**
        - This function takes the file name where the error is presented, the function name who call it and the line number where the error is presented.
        - By default **file**, **function** and **line** are setted internally, so you can ignore these parameters.
     
     **Example:**
     ```swift
        if let error = error {
            Log.WriteError(error)
        }
     ```
     
     - Parameters:
        - message:Optional string message to add to the print.
        - error: The catch error message from the try.
     
     - Returns: Void
     
     - Warning: N/A
     
     - Throws: N/A
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: February 2023
     */
    static func WriteError(_ message: String? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        print("ERROR MESSAGE: \(message ?? ""), called by: \(file.components(separatedBy: "/").last ?? file) - \(function), at line: \(line)")
    }
}


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
