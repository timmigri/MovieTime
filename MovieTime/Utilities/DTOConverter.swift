//
//  DTOConverter.swift
//  MovieTime
//
//  Created by Артём Грищенко on 30.05.2023.
//

import Foundation

class DTOConverter {
    static func convert(_ dto: PersonListDTO) -> [PersonModel] {
        var persons = [PersonModel]()
        for person in dto.docs {
            guard let name = person.name else { continue }
            if name.count == 0 { continue }
            persons.append(PersonModel(
                id: person.id,
                name: name,
                photo: person.photo
            ))
        }
        return persons
    }
}
