//
//  CheckUser.swift
//  CheckUser
//
//  Created by Mister Okine on 30/07/2021.
//

import Foundation
import Firebase

func checkUser(completion: @escaping (Bool,String,String,String,String)->Void){
     
    let db = Firestore.firestore()
    
    db.collection("Users").getDocuments { (snap, err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
        
        for i in snap!.documents{
            
            if i.documentID == Auth.auth().currentUser?.uid{
                
                completion(true,i.get("Username") as! String,i.documentID,i.get("ProfilePic") as! String,i.get("About") as! String)
                return
            }
        }
        
        completion(false,"No Username","No Unique Identification","No Profile Pic","No About")
    }
    
}
