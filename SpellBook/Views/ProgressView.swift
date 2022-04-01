//
//  ProgressView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI
import MBProgressHUD

/// Simple progress view to be shown during data loading
struct ProgressView: UIViewRepresentable {
  typealias UIViewType = MBProgressHUD

  var isAnimating: Bool

  func makeUIView(context: UIViewRepresentableContext<ProgressView>) -> MBProgressHUD {
    let hud = MBProgressHUD()
    hud.label.text = "Loading..."
    hud.contentColor = .orange
    return hud
  }

  func updateUIView(_ uiView: MBProgressHUD, context: UIViewRepresentableContext<ProgressView>) {
    isAnimating ? uiView.show(animated: true) : uiView.hide(animated: true)
  }
}
