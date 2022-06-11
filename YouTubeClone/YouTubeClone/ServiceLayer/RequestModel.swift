//
//  RequestModel.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import Foundation

//Permite configurar el tupo de requeste que se hace (GET, POST, ETC).
struct RequestModel{
    let endPoint: Endpoints
    var queryItems: [String:String]?
    let httpMethod: HttpMethod = .GET
    var baseUrl : URLBase = .youtube
    
    func getURL() -> String{
        return baseUrl.rawValue + endPoint.rawValue
    }
    
    enum HttpMethod: String{
        case GET
        case POST
    }
    
    enum Endpoints: String{
        case search = "/search"
        case channels = "/channels"
        case playlists = "/playlists"
        case playlistItems = "/playlistItems"
        case empty = ""
    }
    
    enum URLBase: String{
        case youtube = "https://www.googleapis.com/youtube/v3"
        case google = "https://othereweb.com/v2"
    }
}
