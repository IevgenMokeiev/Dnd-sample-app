//
//  SearchView.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 19.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI

/// Search view which consists of image and text field
/// - Properties:
///     - searchTerm: A binding to sync with text field text
struct SearchView: View {

    @Binding var searchTerm: String

    var body: some View {
        HStack {
            Image("search")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding(.trailing, 5)
            TextField("type spell here...", text: $searchTerm)
                .accessibility(identifier: "SpellSearchView")
        }
        .padding([.horizontal, .top], 15)
    }
}
