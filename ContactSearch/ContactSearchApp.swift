//
//  ContactSearchApp.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/9/21.
//

import SwiftUI

@main
struct ContactSearchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ContactStore())
        }
    }
}
