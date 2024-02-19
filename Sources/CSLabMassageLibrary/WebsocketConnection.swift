//
//  WebsocketConnection.swift
//
//
//  Created by 米田大介 on 2024/02/17.
//

import Foundation
import UIKit
import SwiftUI

class WebsocketConnection: UIViewController, URLSessionTaskDelegate, URLSessionWebSocketDelegate {
    
    var urlSession: URLSession?
    var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
        let url = URL(string: "wss://wvw7jraigf.execute-api.ap-northeast-1.amazonaws.com/production?roomId=1234567")!

        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        webSocketTask = urlSession?.webSocketTask(with: url)
        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
    }
    
    public enum Message {
      case data(Data)
      case string(String)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
      print("Web Socket did connect")
        
     }
      
     func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
      print("Web Socket did disconnect. Close code: \(closeCode). Reason: \(String(describing: reason))")
     }
    
    // メッセージを受け取った時に呼ばれる関数
    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        switch incoming {
        case let .success(message): // 正しく受け取れている場合
            print("メッセージの受信")
            // メッセージの種類に応じて処理分け（今回はテキストのみ）
            switch message {
            case let .string(msg):
                let arr:[String] = msg.components(separatedBy: ":")
                let type = arr[0]
                let text = arr[1]
                print(message)
                CsLabMassageView().msgresive(text: text)
                
                break
            case let .data(data):
                print(data)
            @unknown default:
                print("unknown \(message)")
            }
            break
        case let .failure(err):
            print(err)
            break
        }
        webSocketTask?.receive(completionHandler: onReceive)
    }
    

    @IBAction func presentSwiftUIView() {
        print("TAP")
    }
    
    public func sendmassage(roomID:String, message:String){
        webSocketTask?.send(.string(makeMessage(roomID:roomID, message:message)), completionHandler: { error in
            if error != nil {
                // エラーの場合
                print(error)
            }else{
                print("メッセージの送信")
                print(self.makeMessage(roomID:roomID, message:message))
            }
        })
    }
    
    public func makeMessage(roomID:String, message:String) -> String {
        // Dictionaryの準備
        var json = Dictionary<String, String>()
        json["action"] = "sendmessage"
        json["message"] = message
        json["type"] = "user"
        json["roomId"] = roomID
        let formatter = ISO8601DateFormatter()
        json["createDate"] = formatter.string(from: Date())
        do {
            // Dictionaryを文字列化
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            return String(bytes: jsonData, encoding: .utf8)!
        } catch (let e) {
            print(e)
        }
        return "" // エラーの場合
    }

}

