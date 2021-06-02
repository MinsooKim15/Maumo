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
    public var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User?{
        didSet{print("changed")}
    }
    private var handle : AuthStateDidChangeListenerHandle?
    public var userIsAnonymous = true
    public func listen(completion: @escaping ()-> Void){
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
            if let user = user{
                print("User 값 생김")
                self.setUserInfo(uid:user.uid, isAnonymous:user.isAnonymous)
                completion()
            } else{
                // if we don't have a user, set our session to nil
                print("User가 없음")
                self.signInAnonymous()
                completion()
            }
        }
    }
    public func signInAnonymous(){
        Auth.auth().signInAnonymously(){(authResult, error) in
            guard let user = authResult?.user else { return }
            self.userIsAnonymous = user.isAnonymous  // true
            let uid = user.uid
            if error != nil{
                print(error)
            }
            print("익명 로그인 성공")
        }
    }
    private func setUserInfo(uid:String , isAnonymous:Bool){
//        User 데이터를 Firestore에서 가져와서 저장한다.
        let doc_ref = Firestore.firestore().collection("users").document(uid)
        doc_ref.getDocument{(document,error) in
            if document?.exists ?? false{
                do{
                   try self.session = document?.data(as: User.self)
                }catch{
                    print(error)
                }
            }else if isAnonymous{
                self.session = User(uid: uid, firstName: "", lastName: "", email: "",isAnonymous:isAnonymous)
            }
        }
    }
    private func addUserInfo(uid:String, firstName:String, lastName:String, email:String){
        let user = User(uid: uid, firstName: firstName, lastName: lastName, email: email)
//        .document(uid).setData(from:user)
        do{
            let _ = try Firestore.firestore().collection("users").document(uid).setData(from: user)
        }
        catch{
            print(error)
        }
    }
    
    public func signUp(
        email: String,
        password: String,
        firstName: String,
        lastName:String,
        handler : @escaping AuthDataResultCallback){
//        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        Auth.auth().createUser(withEmail: email, password: password){(result, error) in
            if let authResult = result{

                self.addUserInfo(uid:authResult.user.uid,firstName:firstName,lastName: lastName, email:email)
            }
            handler(result,error)
        }
    }

    public func signIn(
        email: String,
        password: String,
        handler : @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail:email, password: password){(result, error) in
            handler(result,error)
        }
    }
    public func getErrorMessage(authError:Error) -> String{
        return AuthErrorCode(rawValue: authError._code)?.errorMessage ?? ""
    }
    public func signOut() -> Bool{
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
}
