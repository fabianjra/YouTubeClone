// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let channelModel = try? newJSONDecoder().decode(ChannelModel.self, from: jsonData)

import Foundation

// MARK: - ChannelModel
struct ChannelModel: Codable {
    let kind, etag: String
    let pageInfo: PageInfo
    let items: [Item]
    
    // MARK: - PageInfo
    struct PageInfo: Codable {
        let totalResults, resultsPerPage: Int
    }
    
    // MARK: - Item
    struct Item: Codable {
        let kind, etag, id: String
        let snippet: Snippet
        let statistics: Statistics
        let brandingSettings: BrandingSettings
        
        // MARK: - Snippet
        struct Snippet: Codable {
            let title, snippetDescription, customURL, publishedAt: String
            let thumbnails: Thumbnails
            let defaultLanguage: String
            let localized: Localized
            let country: String

            enum CodingKeys: String, CodingKey {
                case title
                case snippetDescription = "description"
                case customURL = "customUrl"
                case publishedAt, thumbnails, defaultLanguage, localized, country
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
        
        // MARK: - Statistics
        struct Statistics: Codable {
            let viewCount, subscriberCount: String
            let hiddenSubscriberCount: Bool
            let videoCount: String
        }
        
        // MARK: - BrandingSettings
        struct BrandingSettings: Codable {
            let channel: Channel
            let image: Image
            
            // MARK: - Channel
            struct Channel: Codable {
                let title, channelDescription, keywords, defaultLanguage: String
                let country: String

                enum CodingKeys: String, CodingKey {
                    case title
                    case channelDescription = "description"
                    case keywords, defaultLanguage, country
                }
            }
            
            // MARK: - Image
            struct Image: Codable {
                let bannerExternalURL: String

                enum CodingKeys: String, CodingKey {
                    case bannerExternalURL = "bannerExternalUrl"
                }
            }
        }//BrandingSettings
    }//Item
}
