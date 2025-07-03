//
//  AuthManager.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import Foundation

final public class AuthManager{
    
    static let shared = AuthManager()
    private var refreshingToken = false
    struct Constants{
        static let clientID = "6124fa9ada1e464dbcd9b7874282c5e2"
        static let clientSecret = "e61c9c2d0af4443da5877b12c33d54d2"
        static let ApiTokenUrl = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io/"
        static let scope = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-top-read"
    }
    
    private init() {}
    
    var SignInURL: URL? {

        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scope)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSIgnedIn: Bool {
        return acessToken != nil
    }
    
    private var acessToken : String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken : String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var expirationDate : Date? {
        return UserDefaults.standard.object(forKey: "expires_in") as? Date
    }
    
    private var shouldRenewToken : Bool {
        guard let exp = expirationDate else{
            return false
        }
        return Date().addingTimeInterval(TimeInterval(300)) >= exp
    }
    
    public func exchangeCodeForToken(code: String, completion : @escaping((Bool)-> Void)){
        guard let url = URL(string: Constants.ApiTokenUrl) else{
            return
        }
        var component = URLComponents()
        component.queryItems = [ URLQueryItem(name: "grant_type", value: "authorization_code"),URLQueryItem(name: "code", value: code),URLQueryItem(name: "redirect_uri", value: "https://www.iosacademy.io/"),]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = component.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data =  basicToken.data(using: .utf8)
        guard let  basic64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        let task: Void = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data , error == nil else {
                completion(false)
                return
            }
            
            do {
                let df = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(df)
                let json = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.cacheToken(result : json)
                completion(true)
            }catch{
                completion(false)
            }
        }.resume()
    }
    
    private var onRefreshBLocks = [((String) -> Void)]()
    
    public func withValidToken(completion : @escaping(String) -> Void){
        
        guard !refreshingToken else{
            onRefreshBLocks.append(completion)
            return
        }
        
        if shouldRenewToken{
            
            refreshAccessToken { success in
                if let token = self.acessToken ,success {
                    completion(token)
                }
            }
        }
        else if let token = acessToken{
            completion(token)
        }
    }
    
    public func refreshAccessToken(completion: ((Bool) -> Void)?) {
        
        guard !refreshingToken else { return }
        
        guard shouldRenewToken else {
            completion?(true)
            return
        }
        
        guard let referhToken = self.refreshToken else {
            print("No refresh token found. User must sign in again.")
            completion?(false)
            return
        }
        
        guard let url = URL(string: Constants.ApiTokenUrl) else { return }
        
        refreshingToken = true
        
        var component = URLComponents()
        component.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: referhToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = component.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        guard let basic64String = data?.base64EncodedString() else {
            completion?(false)
            return
        }
        
        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            self.refreshingToken = false
            
            guard let data = data, error == nil else {
                print("Failed to refresh token: \(error?.localizedDescription ?? "Unknown error")")
                completion?(false)
                return
            }
            
            do {
                let json = try JSONDecoder().decode(AuthResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.onRefreshBLocks.forEach { $0(json.access_token) }
                    self.onRefreshBLocks.removeAll()
                    self.cacheToken(result: json)
                }
                
                completion?(true)
            } catch {
                print("Error decoding refresh token response: \(error)")
                completion?(false)
            }
        }
        
        task.resume()
    }

    
    private func cacheToken(result : AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }

        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expires_in")

    }
    
    func signOut(completion: (Bool)-> Void){
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        UserDefaults.standard.setValue(nil, forKey: "expires_in")
        completion(true)
    }
}
