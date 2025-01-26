//
//  MainView.swift
//  ContactSearch
//
//  Created by Marco Abundo on 1/25/25.
//

import SwiftUI
import ContactsUI

struct MainView: View {
    @EnvironmentObject var contactStore: ContactStore

    var body: some View {
        VStack {
            switch contactStore.authorizationStatus {
            case .authorized, .limited:  ContactAddressList()
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
        .environmentObject(ContactStore())
}
