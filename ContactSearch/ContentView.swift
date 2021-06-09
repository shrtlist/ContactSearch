//
//  ContentView.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/9/21.
//

import SwiftUI
import Contacts

struct ContentView: View {
    @ObservedObject var contactStore = ContactStore()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List(searchResults) { contactAddress in
                VStack(alignment: .leading) {
                    Text(contactAddress.formattedName)

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
        let contacts = contactStore.contacts

        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.formattedName.contains(searchText) }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContactStore())
    }
}
