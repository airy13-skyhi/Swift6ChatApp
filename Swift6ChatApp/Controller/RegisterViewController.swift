//
//  RegisterViewController.swift
//  Swift6ChatApp
//
//  Created by Manabu Kuramochi on 2021/04/02.
//

import UIKit
import Firebase
import FirebaseAuth


class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SendProfileOKDelegate,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var sendToDBModel = SendToDBModel()
    var urlString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkModel = CheckPermission()
        checkModel.showCheckPermission()
        
        sendToDBModel.sendProfileOKDelegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    
    @IBAction func touroku(_ sender: Any) {
        
        //email,passのtextFieldの空判定
        if emailTextField.text?.isEmpty != true && passwordTextField.text?.isEmpty != true, let image = profileImageView.image {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                
                if error != nil {
                    print(error.debugDescription)
                    return
                    
                }
                
                //取得したimageを再度data型に圧縮
                let data = image.jpegData(compressionQuality: 1.0)
                
                self.sendToDBModel.sendProfileImageData(data: data!)
                
                
                //画面遷移
            }
            
        }
        
        //登録機能
        
        
        //emailTextField,profileImage値
        
        
        
    }
    
    
    func sendProfileOKDelegate(url: String) {
        
        urlString = url
        if urlString.isEmpty != true {
            self.performSegue(withIdentifier: "chat", sender: nil)
        }
        
    }
    
    
    
    
    @IBAction func tapImageView(_ sender: Any) {
        
        //カメラ、アルバムの選択 alert
        
        showAlert()
        
    }
    
    //カメラ立ち上げメソッド
    
    func doCamera(){
        
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    //アルバム
    func doAlbum(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if info[.originalImage] as? UIImage != nil{
            
            //選択した画像の値を取得して入れる
            let selectedImage = info[.originalImage] as! UIImage
            //取得した画像を貼り付ける
            profileImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    //キャンセル処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    //アラート
    func showAlert(){
        
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            
            self.doCamera()
            
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            
            self.doAlbum()
            
        }
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        
        //挙動をcontrollerの上にのっけている
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
