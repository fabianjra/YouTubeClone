//
//  HomePresenter.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func getData(list: [[Any]], sectionTitleList: [String]) //Se hace un array, de un array de Anys, porque vienen diferentes tipos de datos.
}

class HomePresenter{
    
    var provider: HomeProviderProtocol
    weak var delegate: HomeViewProtocol?
    private var objectList: [[Any]] = []
    
    //Para saber cual es el titulo de cada uno de los Section, del TableView.
    private var sectionTitleList: [String] = []
    
    //Al tener un provider ya asignado, no hace falta pasarle un valor cuando se instancia.
    init(provider: HomeProviderProtocol = HomeProvider(), delegate: HomeViewProtocol) {
        
        self.provider = provider
        self.delegate = delegate
        
        //Si se esta debuguenado o ejectua desde un simulador.
        #if DEBUG || TARGET_OS_SIMULATOR
        if MockManager.shared.runWithMock {
            self.provider = HomeProviderMock()
        }
        #else
        //Otra accion en caso de que no sea DEBUG o Simulator.
        #endif
    }
    
    //Se llama HomeObjects porque se estan obteniendo todos los objetos del inicio.
    
    /*
     A MainActor is a globally unique actor who performs his tasks on the main thread. It should be used for properties, methods, instances,
     and closures to perform tasks on the main thread. Proposal SE-0316 Global Actors introduced the main actor as its an example of a global
     actor, and it inherits the GlobalActor protocol.
     */
    @MainActor
    func getHomeObjects() async{
        
        //Se elimina el objeto, antes de llamar al servicio para que todo quede vacio.
        objectList.removeAll()
        sectionTitleList.removeAll()
        
        async let channel = try await provider.getChannel(channelId: Constants.channelID).items
        async let playlists = try await provider.getPlaylists(channelId: Constants.channelID).items
        async let videos = try await provider.getVideos(searchString: "", channelId: Constants.channelID).items
        //async let playlistItems = try await provider.getPlaylistItems(playlistId: playlists.first?.id ?? "").items
        
        do {
            //La forma en la que trabaja el Async Await, es que primero hace el llamado al channel y solamente cuando realice la llamada y traiga datos, pasa al siguiente llamado. (llamada en cascada).
            //Lo correcto, es realizar esos llamados agrupados en uno solo.
            //let channel = try await provider.getChannel(channelId: Constants.channelID).items
            //let playlists = try await provider.getPlaylists(channelId: Constants.channelID).items
            //let videos = try await provider.getVideos(searchString: "", channelId: Constants.channelID).items
            //let playlistItems = try await provider.getPlaylistItems(playlistId: playlists.first?.id ?? "").items
            
            //***************************************************//
            //Forma correcta de hacer los llamados al servicio:
            
            //Entre parantesis se le da un alias a cada una de las variables que se llaman con el Try.
            //Resumen: Se declaran 3 variables y se hace un solo Await de los llamados, para asignarlas a cada una de las variables.
            let (responseChannel, responsePlaylist, responseVideos) = await (try channel, try playlists, try videos)
            
            //Index: 0
            objectList.append(responseChannel)
            sectionTitleList.append("") //Llenar un valor para el titulo de esta section.
            
            //Obtiene el ID del primer item del playlist, para poder asignarlo por parametro al llamado del metodo.
            if let playlistId = responsePlaylist.first?.id, let playlistItems = await getPlaylistItems(playlistId: playlistId) {
                
                //Se pide el ".items" porque en el metodo "getPlaylistItems" no se esta pidiendo el .items
                //Index: 1
                objectList.append(playlistItems.items.filter({$0.snippet.title != "Private video"})) //Quita los videos privados.
                sectionTitleList.append(responsePlaylist.first?.snippet.title ?? "")
            }
            
            //Index: 2
            objectList.append(responseVideos)
            sectionTitleList.append("Uploads")
            
            //Index: 3
            objectList.append(responsePlaylist)
            sectionTitleList.append("Playlist creados")
            
            //Se le pasa el objeto al delegate:
            delegate?.getData(list: objectList, sectionTitleList: sectionTitleList)
            
        } catch {
            CatchException(err: error)
        }
    }
    
    //Se crea un metodo para llamar al PlaylistItems, ya que depende de la respuesta de Playlist.
    //Se pone la respuesta como opcional, porque puede ser que por algun motivo no exista el o los items de la respuesta.
    func getPlaylistItems(playlistId: String) async -> PlaylistItemModel?{
        do{
            let playlistItems = try await provider.getPlaylistItems(playlistId: playlistId)
            return playlistItems
        }catch{
            CatchException(err: error)
            return nil
        }
    }
}
