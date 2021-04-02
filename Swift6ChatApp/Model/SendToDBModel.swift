//
//  SendToDBModel.swift
//  Swift6ChatApp
//
//  Created by Manabu Kuramochi on 2021/04/02.
//

import Foundation
import FirebaseStorage


//画像をstorageserverへ送信処理
class SendToDBModel {
    
    
    init() {
        
        
    }
    
    func sendProfileImageData(data:Data) {
        
        //data型をUIImage型に変換
        let image = UIImage(data: data)
        let profileImage = image?.jpegData(compressionQuality: 0.1)
        
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        
        //定数化した値をFirebaseStorageに送信(put)
        imageRef.putData(Data(profileImage!), metadata: nil) { (metaData, error) in
            
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            
            //FirebaseStorageからurl値を返される
            imageRef.downloadURL { (url, error) in
                
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                //absoluteStringでstring型に変換 アプリ内保存
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
                
                
            }
            //値が入るまではここから呼ばれる２
            
        }
        //値が入るまではここから呼ばれる１
        
        
    }
    
    
}


