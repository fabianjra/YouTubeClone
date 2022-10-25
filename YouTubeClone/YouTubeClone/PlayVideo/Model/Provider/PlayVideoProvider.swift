//
//  PlayVideoProvider.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 24/10/22.
//

import Foundation

protocol PlayVideoProviderProtocol{
    func getVideo(_ videoId : String) async throws ->  VideoModel
    func getRelatedVideos(_ relatedToVideoId : String) async throws -> VideoModel
    func getChannel(_ channelId : String) async throws -> ChannelModel
}

class PlayVideoProvider: PlayVideoProviderProtocol {
    
    func getVideo(_ videoId: String) async throws -> VideoModel {
        let queryItems = ["id" : videoId, "part": "snippet,contentDetails,status,statistics"]
        let request = RequestModel(endPoint: .videos, queryItems: queryItems)
        
        do{
            let model = try await ServiceLayer.callService(request, VideoModel.self)
            debugPrint(model)
            return model
        }catch {
            throw error
        }
    }
    
    //Obtiene la lista de videos relacionados para mostrarlos en el TableView al abrir en el modal un video.
    func getRelatedVideos(_ relatedToVideoId: String) async throws -> VideoModel {
        let queryItems = ["relatedToVideoId" : relatedToVideoId, "part": "snippet", "maxResults": "50", "type":"video"]
        let request = RequestModel(endPoint: .search, queryItems: queryItems)
        
        do{
            let model = try await ServiceLayer.callService(request, VideoModel.self)
            return model
        }catch {
            throw error
        }
    }
    
    //Obtiene la informacion del canal, para mostarrlo en la celda, debajo del video que se abre en el modal.
    func getChannel(_ channelId : String) async throws -> ChannelModel{
        let queryItems = ["id" : channelId, "part": "snippet,statistics"]
        let request = RequestModel(endPoint: .channels, queryItems: queryItems)
        
        do{
            let model = try await ServiceLayer.callService(request, ChannelModel.self)
            return model
        }catch {
            throw error
        }
    }
}
