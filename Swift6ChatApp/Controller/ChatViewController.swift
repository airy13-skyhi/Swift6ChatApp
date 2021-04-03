//
//  ChatViewController.swift
//  Swift6ChatApp
//
//  Created by Manabu Kuramochi on 2021/04/03.
//

import UIKit
import Firebase
import SDWebImage



class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    let db = Firestore.firestore()
    
    var roomName = String()
    var imageString = String()
    
    var messages:[Message] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            
            imageString = UserDefaults.standard.object(forKey: "userImage") as! String
        }
        
        
        if roomName == "" {
            roomName = "All"
        }
        self.navigationItem.title = roomName

    }
    
    
    
    func loadMessages(roomName:String) {
        
        //date 日付から呼び出す
        db.collection(roomName).order(by: "date").addSnapshotListener { (snapShot, error) in
            
            self.messages = []
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            //documentsからfor文を回してdataを取得
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc {
                    
                    //取得データを一つずつ入れていく
                    let data = doc.data()
                    if let sender = data["sender"] as? String, let body = data["body"] as? String, let imageString = data["imageString"] as? String {
                        
                        
                        let newMessage = Message(sender: sender, body: body, imageString: imageString)
                        
                        self.messages.append(newMessage)
                        
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
    }
    
    
    //body = message, date = 日時, imageString = profileImageのurlString, sender = mailAddres
    @IBAction func send(_ sender: Any) {
        
        //Auth.auth()はfirebaseのAuthentication
        if let messageBody = messageTextField.text, let sender = Auth.auth().currentUser?.email {
            
            db.collection(roomName).addDocument(data: ["sender":sender, "body":messageBody, "imageString":imageString, "date":Date().timeIntervalSince1970]) { (error) in
                
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                //非同期処理
                DispatchQueue.main.async {
                    
                    self.messageTextField.text = ""
                    self.messageTextField.resignFirstResponder()
                }
                
                
            }
        }
        
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
