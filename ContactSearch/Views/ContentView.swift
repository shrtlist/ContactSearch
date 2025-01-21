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

    var body: some View {
        NavigationStack {
            List(contactStore.searchResults) { contactAddress in
                ContactAddressRow(contactAddress: contactAddress)
            }
            .searchable(text: $contactStore.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Contacts")
        }
        .onAppear {
            Task {
                await contactStore.fetchContactAddresses()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContactStore())
    }
}
