// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchModel = try? newJSONDecoder().decode(SearchModel.self, from: jsonData)

import Foundation

// MARK: - SearchModel
struct SearchModel: Codable {
    let kind, etag, nextPageToken, regionCode: String
    let pageInfo: PageInfo
    let items: [Item]
    
    // MARK: - PageInfo
    struct PageInfo: Codable {
        let totalResults, resultsPerPage: Int
    }
    
    // MARK: - Item
    struct Item: Codable {
        let kind, etag: String
        let id: ID
        let snippet: Snippet
        
        // MARK: - ID
        struct ID: Codable {
            let kind, videoID: String
            
            enum CodingKeys: String, CodingKey {
                case kind
                case videoID = "videoId"
            }
        }
        
        // MARK: - Snippet
        struct Snippet: Codable {
            let publishedAt: Date
            let channelID, title, snippetDescription: String
            let thumbnails: Thumbnails
            let channelTitle, liveBroadcastContent: String
            let publishTime: Date
            
            enum CodingKeys: String, CodingKey {
                case publishedAt
                case channelID = "channelId"
                case title
                case snippetDescription = "description"
                case thumbnails, channelTitle, liveBroadcastContent, publishTime
            }
            
            // MARK: - Thumbnails
            struct Thumbnails: Codable {
                let thumbnailsDefault, medium, high: Default
                let standard, maxres: Default?
                
                enum CodingKeys: String, CodingKey {
                    case thumbnailsDefault = "default"
                    case medium, high, standard, maxres
                }
                
                // MARK: - Default
                struct Default: Codable {
                    let url: String
                    let width, height: Int
                }
            }
        }
    }
}
