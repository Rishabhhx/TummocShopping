//
//  ProfileView.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 06/02/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            Form {
                Section("Profile Image") {
                    HStack {
                        Spacer()
                        PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                            viewModel.profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120,height: 120)
                                .background(.black.opacity(0.02))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                }
                Section("Name") {
                    TextField(text: $viewModel.firstName) {
                        Text("First Name")
                    }
                    TextField(text: $viewModel.lastName) {
                        Text("Lasr Name")
                    }
                }
                Section("Address") {
                    TextField(text: $viewModel.address1) {
                        Text("Address Lane 1")
                    }
                    TextField(text: $viewModel.address2) {
                        Text("Address Lane 2")
                    }
                    TextField(text: $viewModel.city) {
                        Text("City")
                    }
                    TextField(text: $viewModel.state) {
                        Text("State")
                    }
                    TextField(text: $viewModel.pincode) {
                        Text("Pin code")
                    }
                }
                Button {
                    viewModel.saveButtonPressed()
                } label: {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    ProfileView()
}
