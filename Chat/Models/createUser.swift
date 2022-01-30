//
//  createUser.swift
//  createUser
//
//  Created by Mister Okine on 30/07/2021.
//

import Foundation
import Firebase
import FirebaseStorage

func CreateUser(name: String,about : String,imagedata : Data,completion : @escaping (Bool)-> Void){
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage().reference()
    
    let uid = Auth.auth().currentUser?.uid

    
    storage.child("ProfilePic").child(uid!).putData(imagedata, metadata: nil) { (_, err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
        
        storage.child("ProfilePic").child(uid!).downloadURL { (url, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            db.collection("Users").document(uid!).setData(["Username":name,"About":about,"ProfilePic":"\(url!)","uid":uid!]) { (err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }

                completion(true)
                
                UserDefaults.standard.set(true, forKey: "status")
                
                UserDefaults.standard.set(name, forKey: "Username")
                
                UserDefaults.standard.set(about, forKey: "About")

                UserDefaults.standard.set(uid, forKey: "uid")
                
                UserDefaults.standard.set("\(url!)", forKey: "Profilepic")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                }
            }
        }
    }
}
