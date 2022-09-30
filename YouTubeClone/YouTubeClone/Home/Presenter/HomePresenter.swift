//
//  HomePresenter.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func getData(list: [[Any]]) //Se hace un array, de un array de Anys, porque vienen diferentes tipos de datos.
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
    
    //Se llama HomeObjects porque se estan obteniendo todos los objetos del inicio.
    func getHomeObjects() async{
        
        objectList.removeAll()
        
        do {
            //La forma en la que trabaja el Async Await, es que primero hace el llamado al channel y solamente cuando realice la llamada y traiga datos, pasa al siguiente llamado. (llamada en cascada).
            //Lo correcto, es realizar esos llamados agrupados en uno solo.
            
            let channel = try await provider.getChannel(channelId: Constants.channelID).items
            let playlists = try await provider.getPlaylists(channelId: Constants.channelID).items
            let videos = try await provider.getVideos(searchString: "", channelId: Constants.channelID).items
            let playlistItems = try await provider.getPlaylistItems(playlistId: playlists.first?.id ?? "").items
            
            objectList.append(channel)
            objectList.append(playlists)
            objectList.append(videos)
            objectList.append(playlistItems)
            
        } catch {
            CatchException(err: error)
        }
    }
}
