//
//  SessionStore.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/01.
//


import Foundation
import Firebase
import Combine
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// ViewModel For Authentication

class SessionStore: ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User?
    var handle : AuthStateDidChangeListenerHandle?
    var userIsAnonymous = true
    func listen(completion: @escaping ()-> Void){
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
            if let user = user{
                print("user 변화")
                self.setUserInfo(uid:user.uid)
            } else{
                // if we don't have a user, set our session to nil
                self.session = nil
                completion()
            }
        }
    }

    func setUserInfo(uid:String){
//        User 데이터를 Firestore에서 가져와서 저장한다.
        let doc_ref = Firestore.firestore().collection("users").document(uid)
        doc_ref.getDocument{(document,error) in
            if document?.exists ?? false{
                do{
                   try                 self.session = document?.data(as: User.self)
                }catch{
                    print(error)
                }

            }
        }
    }
    func addUserInfo(uid:String, firstName:String, lastName:String, email:String){
        let user = User(uid: uid, firstName: firstName, lastName: lastName, email: email)
//        .document(uid).setData(from:user)
        do{
            let _ = try Firestore.firestore().collection("users").document(uid).setData(from: user)
        }
        catch{
            print(error)
        }
    }
    
    func signUp(
        email: String,
        password: String,
        firstName: String,
        lastName:String,
        handler : @escaping AuthDataResultCallback){
//        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        Auth.auth().createUser(withEmail: email, password: password){(result, error) in
            if let authResult = result{
                print(authResult.user.uid)
                self.addUserInfo(uid:authResult.user.uid,firstName:firstName,lastName: lastName, email:email)
            }
            if let authError = error{
                print(authError)
                print(authError._code)
                print(AuthErrorCode(rawValue: authError._code)?.errorMessage)
                self.signUpErrorMessage = AuthErrorCode(rawValue: authError._code)?.errorMessage ?? ""
                print(self.signUpErrorMessage)
            }
        }
    }

    func signIn(
        email: String,
        password: String,
        handler : @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail:email, password: password){(result, error) in
            
            if let authError = error{
                print(authError)
                print(authError._code)
                print(AuthErrorCode(rawValue: authError._code)?.errorMessage)
                self.signUpErrorMessage = AuthErrorCode(rawValue: authError._code)?.errorMessage ?? ""
                print(self.signUpErrorMessage)
            }
            
        }
    }
    func signOut() -> Bool{
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch{
            return false
        }
    }
    func unbind () {
        if let handle = handle{
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // SignUpView용 Variables
    @Published var signUpErrorMessage : String = ""
    func cleanErrorMessage(){
        signUpErrorMessage = ""
    }
}
