//
//  EffectView.swift
//  camera12345
//
//  Created by 櫻井絵理香 on 2024/03/31.
//

import SwiftUI

struct EffectView: View {
    @Binding var isShowSheet: Bool
    let captureImage: UIImage?
    @State var showImage: UIImage?
    let filterArray = [
        "CIPhotoEffectMono",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    @State var filterSelectNumber = 0

    var body: some View {
        VStack {
            Spacer()
            if let showImage {
                Image(uiImage: showImage)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            Button {
                let filterName = filterArray[filterSelectNumber]

                filterSelectNumber += 1
                if filterSelectNumber == filterArray.count {
                    filterSelectNumber = 0
                }
                //元々の画像の回転角度を取得
                let rotate = captureImage?.imageOrientation
                //UIImage形式の画像をCIImage形式に変換

                let inputImage = CIImage(image: captureImage!)

                //フィルタの種類を引数で指定された種類を指定してCIFilterのインスタンスを取得
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                //フィルタ加工のパラメータを初期化
                effectFilter.setDefaults()
                //インスタンスにフィルタ加工する元画像を設定
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                //フィルタ加工を行う情報を生成
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                //CIContextのインスタンスを取得
                let ciContext = CIContext(options: nil)
                //フィルタ加工後の画像をCIContext上に描画し、結果をcgImageとしてCGImage形式の画像を取得
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                    return
                }

                showImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate!)

            } label: {
                 Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(.blue)
                    .foregroundColor(.white)
            }
            .padding()


            //showImageをアンラップする,showImageが加工後の画像だから、加工したらシェアできる
            if let showImage = showImage {
                let shareImage = Image(uiImage: showImage)
                ShareLink(item: shareImage, subject: nil, message: nil, preview: SharePreview("Photo", image: shareImage)) {
                    Text("シェア")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .multilineTextAlignment(.center)
                        .background(.blue)
                        .foregroundColor(.white)
                }
            }
            Button {
                isShowSheet.toggle()
            } label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(.blue)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .onAppear {
            //加工前の撮影した写真を加工後の写真に写す
            showImage = captureImage
        }
    }
}
