//
//  PlayVideoPresenter.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 24/10/22.
//

import Foundation

protocol PlayVideoViewProtocol: AnyObject, BaseViewProtocol{
    func getRelatedVideosFinished()
}

//Es MainActor por los llamados a los servicios.
@MainActor class PlayVideoPresenter {
    
    private var provider : PlayVideoProviderProtocol
    private weak var delegate : PlayVideoViewProtocol?
    
    var relatedVideoList : [[Any]] = [] //En la primera posicion va a estar la informacion del video, channel y comentarios. En la segunda, los videos relacionados.
    var channelModel : ChannelModel.Item?
    
    //Inyeccion de dependencias.
    init(delegate : PlayVideoViewProtocol, provider : PlayVideoProviderProtocol = PlayVideoProvider()){
        self.delegate = delegate
        self.provider = provider
        #if DEBUG
        if MockManager.shared.runWithMock{
            self.provider = PlayVideoProviderMock()
        }
        #endif
    }
    
    func getVideos(_ videoId: String) async{
        do{
            
            /*
             The defer statement allow you to define an action that will be executed after the rest of the operation you want to be done,
             i.e. at the end of the scope.
             
             defer in Swift 2.0 is like a finally, that means swift ensures you to execute that defer code at the end of current function scope.
             Here are the some points that i need to know:
             1) No matter even guard will returns
             2) we can write multiple defer scopes
             */
            defer {
                delegate?.loadingView(.hide)
            }
            
            delegate?.loadingView(.show)
            
            let response = try await provider.getVideo(videoId)
            relatedVideoList.append(response.items)
            
            await getChannelAndRelatedVideos(videoId, response.items.first?.snippet?.channelId ?? "")

            //Le notifica a la vista que ya se hizo el llamado, para que pueda hacer otras acciones.
            delegate?.getRelatedVideosFinished()
            
        }catch{
            Log.WriteCatchExeption(error: error)
            delegate?.showError(error.localizedDescription, callback: {
               
                //Se agrega el callback del boton "retry".
                Task { [weak self] in
                    await self?.getVideos(videoId)
                }
            })
        }
    }
    
    func getChannelAndRelatedVideos(_ videoId : String, _ channelId : String) async{
        async let relatedVideos = try await provider.getRelatedVideos(videoId) //llamado al API.
        async let channel = try await provider.getChannel(channelId) //Llamado al channel por API.
        
        do{
            
            /*
             The defer statement allow you to define an action that will be executed after the rest of the operation you want to be done,
             i.e. at the end of the scope.
             
             defer in Swift 2.0 is like a finally, that means swift ensures you to execute that defer code at the end of current function scope.
             Here are the some points that i need to know:
             1) No matter even guard will returns
             2) we can write multiple defer scopes
             */
            defer {
                delegate?.loadingView(.hide)
            }
            
            delegate?.loadingView(.show)
            
            let (responseRelatedVideos, responseChannel) = await (try relatedVideos, try channel) //Una unica consulta fusionada.
            
            //Se filtran los videos, para no dejar los videos que no tengan informacion.
            let filterRelatedVideos = responseRelatedVideos.items.filter({$0.snippet != nil})
            
            relatedVideoList.append(filterRelatedVideos)
            channelModel = responseChannel.items.first
            
        }catch{
            Log.WriteCatchExeption(error: error)
            delegate?.showError(error.localizedDescription, callback: nil)
        }
        
    }
    
  
}
