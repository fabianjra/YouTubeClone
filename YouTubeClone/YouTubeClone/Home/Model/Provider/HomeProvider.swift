//
//  HomeProvider.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import Foundation

protocol HomeProviderProtocol {
    func getVideos(searchString: String, channelId: String) async throws -> VideoModel
    func getChannel(channelId:String) async throws -> ChannelModel
    func getPlaylists(channelId:String) async throws -> PlaylistModel
    func getPlaylistItems(playlistId:String) async throws -> PlaylistItemModel
}

class HomeProvider: HomeProviderProtocol{
    
    func getVideos(searchString: String, channelId: String) async throws -> VideoModel{
        var queryParams: [String:String] = ["part":"snippet", "type": "video"]
        
        if !channelId.isEmpty{
            queryParams["channelId"] = channelId
        }
        
        if !searchString.isEmpty{
            queryParams["q"] = searchString
        }
        
        let requestModel = RequestModel(endPoint: .search, queryItems: queryParams)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, VideoModel.self)
            
            return model
        } catch {
            CatchException(err: error)
            throw error
        }
    }//FIN: Metodo
    
    func getChannel(channelId:String) async throws -> ChannelModel{
        let queryParams: [String:String] = ["part":"snippet,statistics,brandingSettings", "id":channelId]
        
        let requestModel = RequestModel(endPoint: .channels, queryItems: queryParams)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, ChannelModel.self)
            
            return model
        } catch {
            CatchException(err: error)
            throw error
        }
    }//FIN: Metodo
    
    func getPlaylists(channelId:String) async throws -> PlaylistModel{
        let queryParams: [String:String] = ["part":"snippet,contentDetails", "channelId":channelId]
        
        let requestModel = RequestModel(endPoint: .playlists, queryItems: queryParams)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, PlaylistModel.self)
            
            return model
        } catch {
            CatchException(err: error)
            throw error
        }
    }//FIN: Metodo
    
    func getPlaylistItems(playlistId:String) async throws -> PlaylistItemModel{
        let queryParams: [String:String] = ["part":"snippet,id,contentDetails", "playlistId":playlistId]
        
        let requestModel = RequestModel(endPoint: .playlistItems, queryItems: queryParams)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, PlaylistItemModel.self)
            
            return model
        } catch {
            CatchException(err: error)
            throw error
        }
    }//FIN: Metodo

}
