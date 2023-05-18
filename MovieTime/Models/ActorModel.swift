//
//  ActorModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 18.05.2023.
//

import Foundation

struct ActorModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let photo: String?
    
    private init(rawData: RawActorDataModel) {
        self.id = rawData.id
        self.name = rawData.name!
        self.photo = rawData.photo
    }
    
    static func processRawData(_ rawData: [RawActorDataModel]) -> [ActorModel] {
        var actors = [ActorModel]()
        for rawActor in rawData {
            if (rawActor.name == nil || rawActor.name!.count == 0) { continue }
            actors.append(ActorModel(rawData: rawActor))
        }
        return actors
    }
}

struct RawActorDataModel: Decodable {
    let id: Int
    let name: String?
    let photo: String?
}

struct RawActorsDataModel: Decodable {
    let docs: [RawActorDataModel]
    let pages: Int
    let page: Int
}
