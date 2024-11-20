//
//  RemoteService.swift
//  SoccerLover
//
//  Created by Mahmoud  on 19/11/2024.
//

import Foundation
import RxSwift
import Alamofire

protocol RemoteService {
    func fetchCompetitions<T: Codable>(from url: FootballAPI, model: T.Type) -> Observable<T>
}

class NetworkManager: RemoteService {
    private let disposeBag = DisposeBag()
    private var apiKey = "5aac14846e7946d59c49e7b4ed4b82b8"
    static let shared = NetworkManager()
    private init(){}
    func fetchCompetitions<T: Codable>(from url: FootballAPI, model: T.Type)-> Observable<T> {
        guard let urlString = url.url()else{return Observable.error(SoccerError.invalidEndPoint)}
        return Observable.create { observer in
            let request = AF.request(urlString, headers: ["X-Auth-Token":"5aac14846e7946d59c49e7b4ed4b82b8"])
                .validate()
                .responseData { response in
                    switch response.result{
                    case .success(let data):
                                           if data.isEmpty{
                                               observer.onError(SoccerError.noData)
                                           }else{
                                               do{
                                                   let decodedData = try JSONDecoder().decode(T.self, from: data)
                                                   observer.onNext(decodedData)
                                                   observer.onCompleted()
                                               } catch let DecodingError.dataCorrupted(context) {
                                                   print("Data corrupted: \(context.debugDescription)")
                                               } catch let DecodingError.keyNotFound(key, context) {
                                                   print("Key '\(key)' not found: \(context.debugDescription)")
                                               } catch let DecodingError.typeMismatch(type, context) {
                                                   print("Type '\(type)' mismatch: \(context.debugDescription)")
                                               } catch let DecodingError.valueNotFound(value, context) {
                                                   print("Value '\(value)' not found: \(context.debugDescription)")
                                               } catch {
                                                   print("Decoding failed: \(error.localizedDescription)")
                                               }
                                           }
                                           case .failure(_):
                                           observer.onError(SoccerError.apiError)
                                       }
                                           
                                   }
                               return Disposables.create {
                                   request.cancel()
                               }
                           }
                       }
                   }



    
