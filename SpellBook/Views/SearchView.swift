//
//  SearchView.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 19.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchTerm: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .foregroundColor(.orange)
                .frame(width: 25, height: 25)
                .padding(.trailing, 5)
            TextField("type spell here...", text: $searchTerm).accessibility(identifier: "SpellSearchView")
        }.padding([.horizontal, .top], 15)
    }
}
