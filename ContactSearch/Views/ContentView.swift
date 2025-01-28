//
//  ContentView.swift
//  ContactSearch
//
//  Created by Marco Abundo on 1/27/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var storeManager = ContactStoreManager()

    var body: some View {
        MainView()
            .environmentObject(storeManager)
    }
}

#Preview {
    ContentView()
        .environmentObject(ContactStoreManager())
}
