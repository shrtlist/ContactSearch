//
//  ContentView.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/9/21.
//

import SwiftUI
import Contacts

struct ContentView: View {
    @EnvironmentObject var contactStore: ContactStore
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List(searchResults) { contactAddress in
                ContactAddressRow(contactAddress: contactAddress)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Contacts")
        }
        .onAppear {
            Task {
                await contactStore.fetchContactAddresses()
            }
        }
    }

    var searchResults: [ContactAddress] {
        let contactAddresses = contactStore.contactAddresses

        if searchText.isEmpty {
            return contactAddresses
        } else {
            return contactAddresses.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContactStore())
    }
}
