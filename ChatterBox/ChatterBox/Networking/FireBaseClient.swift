//
//  FireBaseClient.swift
//  ChatterBox
//
//  Created by Navdeep  Singh on 6/8/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import Foundation
import Firebase

typealias FetchResult = Result<[Int], NetworkingErrors>
typealias QueryCompletion = (_ result : FetchResult) -> Void
typealias UserAuthenticationResponse = (_ user: User? ,_ error : Error?) -> Void
typealias RegisterationComplete = (_ isCreated : Bool) -> Void

class FireBaseClient {
    
    var array : [Int] = []
    
    func createUserWithEmail(email : String, password : String, completion : @escaping UserAuthenticationResponse){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let err = error{
                print("Error")
                print(err.localizedDescription)
                completion(nil, error! as Error)
            } else {
                completion(user! , nil)
            }
        }
    }
    
}
