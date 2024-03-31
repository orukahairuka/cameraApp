//
//  ContentView.swift
//  camera12345
//
//  Created by 櫻井絵理香 on 2024/03/27.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    //撮影した写真を保持する状態変数,始めは写真持ってないからnilとなる
    @State var captureImage: UIImage? = nil
    @State var isShowSheet = false
    //フォトライブラリーで選択した写真を管理
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    var body: some View {
        VStack {
            Spacer()
            if let captureImage {
                //撮影写真表示
                Image(uiImage: captureImage)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            Button{
                //カメラ使えるか、使えんかの判定
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラ使える")
                    isShowSheet.toggle()
                } else {
                    print("カメラ使えない")
                }
            } label: {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(.blue)
                    .foregroundColor(.white)
            }
            .padding()
            .sheet(isPresented: $isShowSheet) {
                ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
            }
            //フォトライブラリーから選択する
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                //テキスト表示
                Text("フォトライブラリーから選択する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .padding()
            }
            .onChange(of: photoPickerSelectedImage) { PhotosPickerItem in
                PhotosPickerItem?.loadTransferable(type: Data.self) { result in
                    switch result {
                    case.success(let data):
                        if let data{
                            captureImage = UIImage(data: data)
                        }
                    case .failure(_):
                        return
                    }

                }
                // 画像のDataから一時ファイルを作成し、そのURLをShareLinkに渡す
                if let captureImage = captureImage, let imageData = captureImage.jpegData(compressionQuality: 1.0) {
                    if let imageURL = saveImageDataToTemporaryFile(imageData: imageData) {
                        ShareLink(item: imageURL) {
                            Text("SNSに投稿する")
                        }
                    }
                }
            }
        }
    }

    func saveImageDataToTemporaryFile(imageData: Data) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let imageURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        do {
            try imageData.write(to: imageURL)
            return imageURL
        } catch {
            print("Error saving image to temporary file: \(error)")
            return nil
        }
    }



}
