// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let video = try? newJSONDecoder().decode(Video.self, from: jsonData)

import Foundation

// MARK: - VideoModel
struct VideoModel: Codable {
    let kind, etag: String
    let items: [Item]
    let pageInfo: PageInfo
    
    // MARK: - Item
    struct Item: Codable {
        let kind, etag, id: String
        let snippet: Snippet
        let contentDetails: ContentDetails
        let status: Status
        let statistics: Statistics
        let topicDetails: TopicDetails
        
        // MARK: - ContentDetails
        struct ContentDetails: Codable {
            let duration, dimension, definition, caption: String
            let licensedContent: Bool
            let projection: String
        }
        
        // MARK: - Snippet
        struct Snippet: Codable {
            let publishedAt: Date
            let channelID, title, snippetDescription: String
            let thumbnails: Thumbnails
            let channelTitle: String
            let tags: [String]
            let categoryID, liveBroadcastContent: String
            let localized: Localized
            let defaultAudioLanguage: String
            
            enum CodingKeys: String, CodingKey {
                case publishedAt
                case channelID = "channelId"
                case title
                case snippetDescription = "description"
                case thumbnails, channelTitle, tags
                case categoryID = "categoryId"
                case liveBroadcastContent, localized, defaultAudioLanguage
            }
            
            // MARK: - Thumbnails
            struct Thumbnails: Codable {
                let thumbnailsDefault, medium, high: Default
                
                enum CodingKeys: String, CodingKey {
                    case thumbnailsDefault = "default"
                    case medium, high
                }
                
                // MARK: - Default
                struct Default: Codable {
                    let url: String
                    let width, height: Int
                }
            }
            
            // MARK: - Localized
            struct Localized: Codable {
                let title, localizedDescription: String
                
                enum CodingKeys: String, CodingKey {
                    case title
                    case localizedDescription = "description"
                }
            }
        }//Snippet
        
        // MARK: - Status
        struct Status: Codable {
            let uploadStatus, privacyStatus, license: String
            let embeddable, publicStatsViewable, madeForKids: Bool
        }
        
        // MARK: - Statistics
        struct Statistics: Codable {
            let viewCount, likeCount, favoriteCount, commentCount: String
        }
        
        // MARK: - TopicDetails
        struct TopicDetails: Codable {
            let topicCategories: [String]
        }
    }//Item
    
    // MARK: - PageInfo
    struct PageInfo: Codable {
        let totalResults, resultsPerPage: Int
    }
}//Struct Main VideoModel
