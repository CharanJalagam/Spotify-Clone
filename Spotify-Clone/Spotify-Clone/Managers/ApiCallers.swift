//
//  ApiCallers.swift
//  Spotify-Clone
//
//  Created by apple on 21/01/25.
//

import Foundation

final class ApiCallers{
    static let shared = ApiCallers()
    
    private init(){}
    
    struct Constants{
        static let baseApiUrl = "https://api.spotify.com/v1"
    }
    enum APIError: Error {
        case failedToGetData
    }
    
    //MARK: - Album details
    
    
    public func getAlbumDetails(for album : Album, completion : @escaping (Result<AlbumDetailsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }
                
                do{
//                                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let json = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                                        print(json)
                    completion(.success(json))
                }catch{
                    return completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Playlist details
    
    
    public func getPlaylistDetails(for playlist : UserPlaylist, completion : @escaping (Result<PlaylistDetailsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/playlists/" + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }
                
                do{
                    //                                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let json = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    print(json)
                    completion(.success(json))
                }catch{
                    return completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    
    public func getCurrentUserProfile( completion :@escaping(Result<UserProfile, Error>)-> Void){
        createRequest(with: URL(string: "https://api.spotify.com/v1/me"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let res = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(res))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getNewReleases( completion : @escaping (Result<NewReleasesResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }
                
                do{
                    let json = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    print(json)
                    completion(.success(json))
                }catch{
                    return completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists( completion : @escaping (Result<UserPlaylistResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/me/playlists"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    print(error?.localizedDescription)
                    return completion(.failure(APIError.failedToGetData))
                }
                
                do{
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let json = try JSONDecoder().decode(UserPlaylistResponse.self, from: data)
//                    print(json)
                    completion(.success(json))
                }catch{
                    print(error.localizedDescription)
                    return completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    
    public func getAllCategories( completion : @escaping (Result<AllCategoryResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/browse/categories"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    print(error?.localizedDescription)
                    return completion(.failure(APIError.failedToGetData))
                }
                
                do{
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let json = try JSONDecoder().decode(AllCategoryResponse.self, from: data)
                    //                    print(json)
                    completion(.success(json))
                }catch{
                    print(error.localizedDescription)
                    return completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylist( category : Category, completion : @escaping (Result<FeaturedPlaylistResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/browse/categories/\(category.id)/playlists"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    print(error?.localizedDescription as Any)
                    return completion(.failure(APIError.failedToGetData))
                }
                
                do{
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let json = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    //                    print(json)
                    completion(.success(json))
                }catch{
                    print(error.localizedDescription)
                    return completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    
    
    public func getUserTopItems( completion : @escaping (Result<UserTopItemsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/me/top/tracks"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }
                
                do{
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let json = try JSONDecoder().decode(UserTopItemsResponse.self, from: data)
                    //                    print(json)
                    completion(.success(json))
                }catch{
                    return completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    
    
    public func search( with query : String, completion : @escaping (Result<[SearchResult], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseApiUrl + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            print(request.url?.absoluteString ?? "")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    return completion(.failure(APIError.failedToGetData))
                }
                
                do{
//                                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let json = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    var searchResults : [SearchResult] = []
                    searchResults.append(contentsOf: json.tracks.items.compactMap({$0.map { .track(model: $0) }}))
                    searchResults.append(contentsOf: json.albums.items.compactMap({$0.map { .album(model: $0) }}))
                    searchResults.append(contentsOf: json.playlists.items.compactMap({$0.map { .playlist(model: $0) }}))
                    searchResults.append(contentsOf: json.artists.items.compactMap({$0.map { .artist(model: $0) }}))
                    completion(.success(searchResults))
                }catch{
                    return completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    func createRequest(with url : URL? , type : HTTPMethod , completion : @escaping(URLRequest)-> Void){
        AuthManager.shared.withValidToken { token in
            guard let apiUrl = url else{
                return
            }
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            print(request)
            completion(request)
        }
    }
}
