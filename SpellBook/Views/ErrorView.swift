//
//  ErrorView.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 23.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI

/// Somple error view
struct ErrorView: View {

  var body: some View {
    VStack {
      Text("Something gone wrong...")
        .foregroundColor(.orange)
      Image("error")
        .resizable()
        .scaledToFit()
        .padding()
    }
  }
}

struct ErrorView_Previews: PreviewProvider {
  static var previews: some View {
    return ErrorView()
  }
}

