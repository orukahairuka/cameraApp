//
//  ContentView.swift
//  camera12345
//
//  Created by 櫻井絵理香 on 2024/03/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Button{
                //カメラ使えるか、使えんかの判定
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラ使える")
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
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
