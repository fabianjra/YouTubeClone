//
//  VideosProviderMock.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 17/10/22.
//

import Foundation

class VideosProviderMock: VideosProviderProtocol {
    func getVideos(channelId: String) async throws -> VideoModel {
        
        //Se le pasa el nombre del archivo y el tipo de dato al que lo va a convertir.
        guard let model = Utils.parseJson(jsonName: "VideoList", model: VideoModel.self) else {
            throw NetworkError.jsonDecoder
        }
        
        return model
    }
}
