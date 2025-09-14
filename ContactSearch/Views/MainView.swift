//
//  MainView.swift
//  ContactSearch
//
//  Created by Marco Abundo on 1/25/25.
//

import SwiftUI
import ContactsUI

struct MainView: View {
    @Environment(ContactStoreManager.self) var contactStore

    var body: some View {
        VStack {
            switch contactStore.authorizationStatus {
            case .authorized, .limited:  ContactAddressList(contactStore: contactStore)
            case .restricted, .denied: AppSettingsLink()
            case .notDetermined: RequestAccessButton()
            @unknown default:
                fatalError("An unknown error occurred.")
            }
        }
        .onAppear {
            contactStore.fetchAuthorizationStatus()
        }
    }
}

#Preview {
    MainView()
        .environment(ContactStoreManager())
}
