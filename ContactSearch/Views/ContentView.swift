//
//  ContentView.swift
//  ContactSearch
//
//  Created by Marco Abundo on 1/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var storeManager = ContactStoreManager()

    var body: some View {
        MainView()
            .environment(storeManager)
    }
}

#Preview {
    ContentView()
        .environment(ContactStoreManager())
}
