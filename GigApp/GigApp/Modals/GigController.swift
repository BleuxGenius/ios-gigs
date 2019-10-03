//
//  GigController.swift
//  GigApp
//
//  Created by Lambda_School_Loaner_167 on 10/2/19.
//  Copyright © 2019 Dani. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class GigController {
    
  
//    MARK: - PROPERTIES
    
// first set the baseUrl
    private let baseUrl =  URL(string: "https://lambdagigs.vapor.icloud/api")!
    
    var bearer: Bearer?
//    MARK: - METHODS
    
//    create the function for sign up
    func signUp(with user: User, completionClosure: @escaping (Error?) -> Void) {
        
//        Build the URL
        let requestURL = baseUrl
        .appendingPathComponent("users")
        .appendingPathComponent("signup")
    
//        build the request
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
    
        
//    2: Tell the API that the body is in JSON format
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
//        ENCODE USER
    let encoder = JSONEncoder()
        
    do {
    let userJSON = try encoder.encode(user)
    request.httpBody = userJSON
    } catch {
    NSLog("Error encoding user object: \(error)")
    }
        
//        Perform the request (data task)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
//        handled Errors
        if let error = error {
            NSLog("Error encoding user object: \(error)")
            completionClosure(error)
        }
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
            let statusCodeError = NSError(domain: "com.DanielleBlackwell.GigApp", code: response.statusCode, userInfo: nil)
                completionClosure(statusCodeError)
                return
            }
            
//            nil means there was no error, everything succecced.
            completionClosure(nil)
        }.resume()
    }
    
//     create function for sign in
    
    func signIn(with user: User, completionClosure: @escaping (Error?) -> Void) {
        
        let requestURL =
            baseUrl.appendingPathComponent("users").appendingPathComponent("login")
//        build the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
//  Tell the API that the body is in JSON Format
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        encode the user
        do{
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user object while signing in: \(error)")
            completionClosure(error)
            return
        }
//        perform the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completionClosure(error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.DanielleBlackwell.GigsApp", code: response.statusCode, userInfo: nil)
                completionClosure(statusCodeError)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.DanielleBlackwell.GigsApp", code: -1, userInfo: nil)
                completionClosure(noDataError)
                return
            }
            
//             Decode token to Bearer
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completionClosure(error)
                return
            }
            
            completionClosure(nil)
        }.resume()
        
    }
    
    
}

