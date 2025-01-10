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
                VStack(alignment: .leading) {
                    Text(contactAddress.fullName)

                    if let postalAddressLabeledValue = contactAddress.postalAddressLabeledValue {
                        let addressString = postalAddressLabeledValue.value.addressString
                        Text(addressString)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Contacts")
        }
        .onAppear(perform: {
            contactStore.fetchContacts()
        })
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
