//
//  VideosProvider.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 17/10/22.
//

import Foundation

protocol VideosProviderProtocol {
    func getVideos(channelId: String) async throws -> VideoModel
}

class VideosProvider: VideosProviderProtocol {
    func getVideos(channelId: String) async throws -> VideoModel {
        var queryParams: [String:String] = ["part":"snippet", "type": "video", "order": "date", "maxResults": "50"]
        
        if !channelId.isEmpty{
            queryParams["channelId"] = channelId
        }

        let requestModel = RequestModel(endPoint: .search, queryItems: queryParams)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, VideoModel.self)
            
            return model
        } catch {
            CatchException(err: error)
            throw error
        }
    }
}
