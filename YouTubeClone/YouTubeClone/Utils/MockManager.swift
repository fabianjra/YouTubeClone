//
//  MockManager.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 7/10/22.
//

import Foundation

//Patron Singleton: Se crea una clase y uns intancia fija, para utilizarla como bandera para saber si debe usar el Mock o no.
class MockManager {
    static var shared = MockManager()
    var runWithMock: Bool = false
}
