//
//  HomePresenter.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func getData(list: [[Any]])
}

class HomePresenter{
    
    var provider: HomeProviderProtocol
    weak var delegate: HomeViewProtocol?
    private var objectList: [[Any]] = []
    
    //Al tener un provider ya asignado, no hace falta pasarle un valor cuando se instancia.
    init(provider: HomeProviderProtocol = HomeProvider(), delegate: HomeViewProtocol) {
        self.provider = provider
        self.delegate = delegate
    }
    
    func getVideo() async{
        
        objectList.removeAll()
        
        do {
            let channel = try await provider.getChannel(channelId: Constants.channelID).items
            let playlists = try await provider.getPlaylist(channelId: Constants.channelID).items
            let videos = try await provider.getVideos(searchString: "", channelId: Constants.channelID).items
            let playlistItems = try await provider.getPlaylistItems(playlistId: playlists.first?.id ?? "").items
            
            objectList.append(channel)
            objectList.append(playlists)
            objectList.append(videos)
            objectList.append(playlistItems)
            
        } catch {
            print(error) //TODO: Util.
        }
    }
}
