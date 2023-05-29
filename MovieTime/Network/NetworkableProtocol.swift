//
//  NetworkableProtocol.swift
//  MovieTime
//
//  Created by Артём Грищенко on 29.05.2023.
//

import Moya

protocol NetworkableProtocol {
    var provider: MoyaProvider<KinopoiskAPI> { get }
    func fetchPersons(_ query: String, completion: @escaping (Result<PersonListDTO, Error>) -> Void)
}
