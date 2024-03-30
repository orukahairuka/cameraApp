//
//  ImagePickerView.swift
//  camera12345
//
//  Created by 櫻井絵理香 on 2024/03/27.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    //UIImagePickerContorleerが表示されたかどうか
    @Binding var isShowSheet: Bool
    //撮影s他写真を格納する変数
    @Binding var captureImage: UIImage?

    //Coordinatorでコントローラのdelegateを管理
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView

        //イニシャライザ
        init(parent: ImagePickerView) {
            self.parent = parent
        }

        //撮影が終わった時に呼ばれるdelegateメソッド
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //撮影した写真をcaptureImageに保存
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.captureImage = originalImage
            }
            parent.isShowSheet.toggle()
        }

        //キャンセルボタンが選択された時の呼ばれるdelegateメソッド
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShowSheet.toggle()
        }
    }
    //Coordinatorを作成SwiftUIによって自動的に呼び出し
    func makeCoordinator() -> Coordinator {
        //Cooodinatorクラスのインスタンスを生成
        Coordinator(parent: self)
    }

    //Viewを生成する時に実行
    func makeUIViewController(context: Context) -> some UIViewController {
        //UIImagePiclerControlerのインスタンスを生成
        let myImagePickerController = UIImagePickerController()
        //sourceTypeにcameraを設定
        myImagePickerController.sourceType = .camera
        //delegate設定
        myImagePickerController.delegate = context.coordinator
        //UIImagePickerControllerを返す
        return myImagePickerController

    }

    //viewが更新された時に実行
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //処理なし
    }
}

