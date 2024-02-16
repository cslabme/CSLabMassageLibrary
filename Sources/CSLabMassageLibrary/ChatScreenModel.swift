//
//  ChatScreenModel.swift
//
//
//  Created by 米田大介 on 2024/02/16.
//

import Foundation

final class ChatScreenModel: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    
    // WebSocketへの接続を行います
    func connect() {
        let channelId = "1"
        let url = URL(string: "wss://op6tgkcltl.execute-api.ap-northeast-1.amazonaws.com/production/ -s abcdefghijklmnopqrstuvwxyg -s" + channelId)!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        // メッセージを受け取った時に呼ばれるハンドラ
        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
    }

    // 接続解除時に実行する関数
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    // メッセージを受け取った時に呼ばれる関数
    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        // 2回目以降の記事で解説
    }

}
