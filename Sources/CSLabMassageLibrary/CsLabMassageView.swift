//
//  CsLabMassageView.swift
//
//
//  CsLabMassageView by 米田大介 on 2024/02/15.
//

import SwiftUI

struct ChatMessage: Hashable {
    let content: String
    let type: String
}

// チャット表示用のメインビュー
struct CsLabMassageView: View {

    // 現在のチャットが完了しているかどうかを示す変数
    @State private var isCompleting: Bool = false
    
    // ユーザーが入力するテキストを保存する変数
    @State private var text: String = ""
    
    // チャットメッセージの配列
    @State private var chat: [ChatMessage] = [
        ChatMessage(content: "あなたは、ユーザーの質問や会話に回答するロボットです", type:"system")
    ]
    
    // WSSコネクションを行うクラス
    let wss = ChatScreenModel().connect()
    
    // チャット画面のビューレイアウト
    var body: some View {
        VStack {
            // スクロール可能なメッセージリストの表示
            ScrollViewReader { reader in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(chat.indices, id: \.self) { index in
                            MessageView(message: chat[index])
                        }
                    }
                }
            }
            .padding(.top)
            // 画面をタップしたときにキーボードを閉じる
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            // テキスト入力フィールドと送信ボタンの表示
            HStack {
                // テキスト入力フィールド
                TextField("メッセージを入力", text: $text)
                    .disabled(isCompleting) // チャットが完了するまで入力を無効化
                    .font(.system(size: 15)) // フォントサイズを調整
                    .padding(8)
                    .padding(.horizontal, 10)
                    .background(Color.white) // 入力フィールドの背景色を白に設定
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)

                    )
                
                // 送信ボタン
                Button(action: {
                    isCompleting = true
                    // ユーザーのメッセージをチャットに追加
                    chat.append(ChatMessage(content: text, type:"user"))
                    text = "" //テキストフィールドをクリア
                    Task {
                        do {
                            // OpenAIの設定
                        
                                                
                            // チャットの生成
                            isCompleting = false
                        } catch {
                            print("ERROR DETAILS - \(error)")
                        }
                    }
                }) {
                    // 送信ボタンのデザイン
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(self.text == "" ? Color(#colorLiteral(red: 0.75, green: 0.95, blue: 0.8, alpha: 1)) : Color(#colorLiteral(red: 0.2078431373, green: 0.7647058824, blue: 0.3450980392, alpha: 1)))
                }
                // テキストが空またはチャットが完了していない場合はボタンを無効化
                .disabled(self.text == "" || isCompleting)
            }
            
            .padding(.horizontal)
            .padding(.bottom, 8) // 下部のパディングを調整
        }
    }
}

// メッセージのビュー
struct MessageView: View {
    
    var message: ChatMessage
    
    var body: some View {
        HStack {
            if message.type == "user" {
                Spacer()
            } else {
                // ユーザーでない場合はアバターを表示
                AvatarView(imageName: "avatar")
                    .padding(.trailing, 8)
            }
            VStack(alignment: .leading, spacing: 4) {
                // メッセージのテキストを表示
                Text(message.content)
                    .font(.system(size: 14)) // フォントサイズを調整
                    .foregroundColor(message.type == "user" ? .white : .black)
                    .padding(10)
                    .id(999)
                    // ユーザーとAIのメッセージで背景色を変更
                    .background(message.type == "user" ? Color(#colorLiteral(red: 0.2078431373, green: 0.7647058824, blue: 0.3450980392, alpha: 1)) : Color(#colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9176470588, alpha: 1)))
                    .cornerRadius(20) // 角を丸くする
            }
            .padding(.vertical, 5)
            // ユーザーのメッセージの場合は右側にスペースを追加
            if message.type != "user" {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

// アバタービュー
struct AvatarView: View {
    var imageName: String
    
    var body: some View {
        VStack {
            // アバター画像を円形に表示
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            
            // AIの名前を表示
            Text("サポート")
                .font(.caption) // フォントサイズを小さくするためのオプションです。
                .foregroundColor(.black) // テキストの色を黒に設定します。
        }
    }
}

#Preview {
    CsLabMassageView()
}
