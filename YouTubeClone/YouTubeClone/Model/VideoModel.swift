// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let video = try? newJSONDecoder().decode(Video.self, from: jsonData)

import Foundation

// MARK: - VideoModel
struct VideoModel: Decodable {
    let kind, etag: String
    let items: [Item]
    let pageInfo: PageInfo
    
    // MARK: - Item
    struct Item: Decodable {
        let kind: String
        let id: String?
        let snippet: Snippet?
        let contentDetails: ContentDetails?
        let statistics: Statistics?
        
        enum CodingKeys: String, CodingKey {
            case kind
            case id
            case snippet
            case contentDetails
            case statistics
        }
        
        //Si se le hacer codingKeys a un campo porque da problemas, hay que hacerselos a todos.
        init(from decoder: Decoder) throws {
            
            //Este container, maneja la informacion de un "item" completo que se obtenga, o sea toda la entidad.
            //Se realiza lo siguiente: Se toma el valor decoder, se le busca la propiedad container y se busca dentro de CodingKeys.
            //Por conversion de utiliza "CodignKeys", pero el nombre puede ser cualquiera.
            //container va a validar que el "id" sea de tipo objeto o de string.
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.kind = try container.decode(String.self, forKey: .kind) //Directo porque es string, no ocupa validacion.
            
            //Valida que seea de tipo VideoId (debe ser type). forKey se usa con el campo "id" del enum CodingKeys.
            //Resumen: Valida que dentro de container, el campo "id" sea del tipo "VideoId". sino, es un String.
            if let id = try? container.decode(VideoId.self, forKey: .id){
                //En caso de que sea de tipo "VideoId":
                self.id = id.videoId
                
            }else{
                //En caso de que no sea String. deja la variable como nil.
                if let id = try? container.decode(String.self, forKey: .id){
                    self.id = id
                }else{
                    self.id = nil
                }
            }
            
            if let snippet = try? container.decode(Snippet.self, forKey: .snippet){
                self.snippet = snippet
            }else{
                self.snippet = nil
            }
            
            if let contentDetails = try? container.decode(ContentDetails.self, forKey: .contentDetails){
                self.contentDetails = contentDetails
            }else{
                self.contentDetails = nil
            }
            
            if let statistics = try? container.decode(Statistics.self, forKey: .statistics){
                self.statistics = statistics
            }else{
                self.statistics = nil
            }
        }
        
        struct VideoId: Decodable{
            let kind: String
            let videoId: String
        }
        
        // MARK: - ContentDetails
        struct ContentDetails: Codable {
            let duration, dimension, definition, caption: String
            let licensedContent: Bool
            let projection: String
        }
        
        // MARK: - Snippet
        struct Snippet: Codable {
            let publishedAt: String
            let channelId: String
            let title: String
            let description: String
            let thumbnails: Thumbnails
            let channelTitle: String
            let tags: [String]?
            
            enum CodingKeys: String, CodingKey {
                case publishedAt
                case channelId
                case title
                case description
                case thumbnails
                case channelTitle
                case tags
            }
            
            // MARK: - Thumbnails
            struct Thumbnails: Codable {
                let medium, high: Default
                
                enum CodingKeys: String, CodingKey {
                    case medium
                    case high
                }
                
                // MARK: - Default
                struct Default: Codable {
                    let url: String
                    let width, height: Int
                }
            }
            
        }//Snippet
        
        // MARK: - Statistics
        struct Statistics: Codable {
            let viewCount, likeCount, favoriteCount, commentCount: String
        }
        
    }//Item
    
    // MARK: - PageInfo
    struct PageInfo: Codable {
        let totalResults, resultsPerPage: Int
    }
}//Struct Main VideoModel
