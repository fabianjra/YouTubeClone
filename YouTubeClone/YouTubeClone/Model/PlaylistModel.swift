//
//  PlaylistModel.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import Foundation

struct PlaylistModel: Decodable {
    let kind, etag, nextPageToken: String
    let pageInfo: PageInfo
    let items: [Items]
    
    struct PageInfo: Decodable{
        let totalResults, resultsPerPage: Int
    }
    
    struct Items: Decodable {
        let kind, etag, id: String
        let snipet: Snipet
        let contentDetails: ContentDetails
        
        struct Snipet: Decodable {
            let publishedAt, channelId, title, description: String
            let thumbnails: Thumbnails
            
            struct Thumbnails: Decodable {
                let medium: Medium
                
                struct Medium:Decodable {
                    let url: String
                    let width: Int
                    let height: Int
                }
            }//Thumbnails
            
            let channelTitle: String
            let localized: Localized
            
            struct Localized: Decodable {
                let tile, description: String
            }
        }//Snippet
        
        struct ContentDetails: Decodable {
            let itemCount: Int
        }
    }//Items
}
