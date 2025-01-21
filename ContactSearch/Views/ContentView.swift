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
            Group {
                if contactStore.isLoading {
                    ProgressView()
                } else if contactStore.searchResults.isEmpty {
                    ScrollView {
                        ContentUnavailableView.init("No results", systemImage: "person.crop.circle")
                    }
                } else {
                    List(contactStore.searchResults) { contactAddress in
                        ContactAddressRow(contactAddress: contactAddress)
                    }
                }
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
