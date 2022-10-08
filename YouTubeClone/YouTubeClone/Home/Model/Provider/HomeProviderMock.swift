//
//  HomeProviderMock.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 7/10/22.
//

import Foundation

//Clase que conforma al protocolo y tiene los metodos que se necesitan para mostrar la pantalla principal en base a Mocks.
class HomeProviderMock: HomeProviderProtocol {
    
    func getVideos(searchString: String, channelId: String) async throws -> VideoModel {
        
        //Se le pasa el nombre del archivo y el tipo de dato al que lo va a convertir.
        guard let model = Utils.parseJson(jsonName: "SearchVideos", model: VideoModel.self) else {
            throw NetworkError.jsonDecoder
        }
        
        return model
    }
    
    func getChannel(channelId: String) async throws -> ChannelModel {
        guard let model = Utils.parseJson(jsonName: "Channel", model: ChannelModel.self) else {
            throw NetworkError.jsonDecoder
        }
        
        return model

    }
    
    func getPlaylists(channelId: String) async throws -> PlaylistModel {
        guard let model = Utils.parseJson(jsonName: "Playlists", model: PlaylistModel.self) else {
            throw NetworkError.jsonDecoder
        }
        
        return model
    }
    
    func getPlaylistItems(playlistId: String) async throws -> PlaylistItemModel {
        guard let model = Utils.parseJson(jsonName: "PlaylistItems", model: PlaylistItemModel.self) else {
            throw NetworkError.jsonDecoder
        }
        
        return model
    }
    
    
}
