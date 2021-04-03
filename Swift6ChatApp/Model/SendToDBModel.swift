//
//  SendToDBModel.swift
//  Swift6ChatApp
//
//  Created by Manabu Kuramochi on 2021/04/02.
//

import Foundation
import FirebaseStorage


protocol SendProfileOKDelegate {
    
    
    func sendProfileOKDelegate(url:String)
    
}

//画像をstorageserverへ送信処理
class SendToDBModel {
    
    
    var sendProfileOKDelegate:SendProfileOKDelegate?
    
    
    init() {
        
        
    }
    
    func sendProfileImageData(data:Data) {
        
        //data型をUIImage型に変換
        let image = UIImage(data: data)
        //data型に圧縮
        let profileImageData = image?.jpegData(compressionQuality: 0.1)
        //保存先(profileImage folder)
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        
        //定数化した値をFirebaseStorageに送信(put)　data型を飛ばす
        imageRef.putData(profileImageData!, metadata: nil) { (metaData, error) in
            
            
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
                
                
                self.sendProfileOKDelegate?.sendProfileOKDelegate(url: url!.absoluteString)
            }
            //値が入るまではここから呼ばれる２
            
        }
        //値が入るまではここから呼ばれる１
        
        
    }
    
    
}


