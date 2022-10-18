//
//  VideoPresenter.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 17/10/22.
//

import Foundation

protocol VideosViewProtocol: AnyObject {
    func getVideos(videoList: [VideoModel.Item])
}

class VideosPresenter {
    
    private weak var delegate: VideosViewProtocol?
    private var provider: VideosProviderProtocol
    
    init(delegate: VideosViewProtocol, provider: VideosProviderProtocol = VideosProvider()) {
        self.provider = provider
        self.delegate = delegate
        
        #if DEBUG || TARGET_OS_SIMULATOR
        if MockManager.shared.runWithMock {
            self.provider = VideosProviderMock()
        }
        #else
            //Otra accion en caso de que no sea DEBUG o Simulator.
        #endif
    }
    
    @MainActor
    func getVideos() async {
        
        do{
            let videos = try await provider.getVideos(channelId: Constants.channelID).items
            delegate?.getVideos(videoList: videos)
            
        }catch{
            debugPrint("Error getVideos: " + error.localizedDescription)
        }
    }
}
