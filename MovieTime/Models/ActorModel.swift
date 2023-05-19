//
//  ActorModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 18.05.2023.
//

import Foundation

struct PersonModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let photo: String?

    private init(rawData: RawPersonModel) {
        self.id = rawData.id
        self.name = rawData.name!
        self.photo = rawData.photo
    }

    init(id: Int, name: String, photo: String?) {
        self.id = id
        self.name = name
        self.photo = photo
    }

    static func processRawData(_ rawData: [RawPersonModel]) -> [PersonModel] {
        var persons = [PersonModel]()
        for rawPersons in rawData {
            if rawPersons.name == nil || rawPersons.name!.count == 0 { continue }
            persons.append(PersonModel(rawData: rawPersons))
        }
        return persons
    }
}

struct RawPersonModel: Decodable {
    let id: Int
    let name: String?
    let photo: String?
}

struct RawPersonsResultModel: Decodable {
    let docs: [RawPersonModel]
    let pages: Int
    let page: Int
}
