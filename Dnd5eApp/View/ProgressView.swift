//
//  ProgressView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import SwiftUI
import MBProgressHUD

struct ProgressView: UIViewRepresentable {
    typealias UIViewType = MBProgressHUD

    @Binding var isAnimating: Bool

    func makeUIView(context: UIViewRepresentableContext<ProgressView>) -> MBProgressHUD {
        return MBProgressHUD()
    }

    func updateUIView(_ uiView: MBProgressHUD, context: UIViewRepresentableContext<ProgressView>) {
        isAnimating ? uiView.show(animated: true) : uiView.hide(animated: true)
    }
}
