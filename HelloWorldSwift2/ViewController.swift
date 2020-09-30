//
//  ViewController.swift
//  HelloWorldSwift2
//
//  Created by hiroyuki on 2020/09/30.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func tapSignIn(_ sender: Any) {
    signInDropbox()
  }
  func signInDropbox(){
    // New: OAuth 2 code flow with PKCE that grants a short-lived token with scopes.
    let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["files.content.read"], includeGrantedScopes: false)
    DropboxClientsManager.authorizeFromControllerV2(
      UIApplication.shared,
      controller: self,
      loadingStatusDelegate: nil,
      openURL: { (url: URL) -> Void in UIApplication.shared.openURL(url) },
      scopeRequest: scopeRequest
    )
  }
  
  @IBAction func tapDownload(_ sender: Any) {
    downloadDropboxFile()
  }
  @objc func downloadDropboxFile() {
    let fileName = "/アプリ/HelloWorldSwift2/xxxx.jpg"
    //ダウンロード処理
    if let client = DropboxClientsManager.authorizedClient {
      //ダウンロード先URLを設定
      let destination : (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let UUID = Foundation.UUID().uuidString
        var fileName = ""
        if let suggestedFilename = response.suggestedFilename {
          fileName = suggestedFilename
        }
        let pathComponent = "\(UUID)-\(fileName)"
        return directoryURL.appendingPathComponent(pathComponent)
      }
      print("AAA")
      print(fileName)
      //ダウンロードと画面描画処理
      client.files.download(path: fileName, destination: destination).response { response, error in
        if let (metadata, url) = response {
          print("Downloaded file name: \(metadata.name)")
          do {
            let data = try Data(contentsOf: url)  //urlをData型に変換
            let img = UIImage(data: data)  //Data型に変換したurlをUIImageに変換
            let iv:UIImageView = UIImageView(image:img)  //UIImageをivに変換
            let rect:CGRect = CGRect(x:0, y:0, width:300, height:400)  //サイズを変更
            iv.frame = rect
            self.view.addSubview(iv)  //変換したivをviewに追加
            iv.layer.position = CGPoint(x: self.view.bounds.width/2, y: 400.0)  //表示位置決定
          } catch let err {
            print("Error : \(err.localizedDescription)")
          }
        } else {
          print(error!)
        }
      }
    }
  }
}

