/*
 * Copyright (c) 2010-2023 Belledonne Communications SARL.
 *
 * This file is part of linphone-iphone
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import SwiftUI
import ContactsUI

struct ContactView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    typealias UIViewControllerType = UINavigationController

    let contact: CNContact

    init(contact: CNContact) {
        self.contact = contact
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ContactView>) -> ContactView.UIViewControllerType {
        let contactViewController = CNContactViewController(for: contact)
        contactViewController.allowsEditing = false
        contactViewController.delegate = context.coordinator

        let navigationController = UINavigationController(rootViewController: contactViewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: ContactView.UIViewControllerType, context: UIViewControllerRepresentableContext<ContactView>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CNContactViewControllerDelegate {
        var parent: ContactView

        init(_ parent: ContactView) {
            self.parent = parent
        }

        func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
            viewController.dismiss(animated: true, completion: {})
        }

        func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
            true
        }
    }
}
