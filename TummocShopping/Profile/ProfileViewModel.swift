//
//  ProfileViewModel.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 06/02/24.
//

import SwiftUI
import CoreData
import PhotosUI

//extension UIImage : Transferable {
//    public static var transferRepresentation: some TransferRepresentation {
//        DataRepresentation(importedContentType: .image, importing: {
//            UIImage(data: $0) ?? UIImage()
//        })
//    }
//}
@MainActor
class ProfileViewModel : ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var address1: String = ""
    @Published var address2: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var pincode: String = ""
    @Published var profileImage: Image = Image(systemName: "person")
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            if let selectedItem {
                Task {
                    try await loadTransferable(from: selectedItem)
                }
            }
        }
    }
    @Published var profileUiImage: UIImage?
    
    var manager = CoreDataManager.shared
    var profileData : [ProfileEntity] = []
    
    init() {
        fetchProfile()
    }
    
    func fetchProfile() {
        let fetch = NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
        do {
            profileData = try manager.context.fetch(fetch)
            firstName = profileData.first?.firstName ?? ""
            lastName = profileData.first?.lastName ?? ""
            address1 = profileData.first?.address1 ?? ""
            address2 = profileData.first?.address2 ?? ""
            city = profileData.first?.city ?? ""
            state = profileData.first?.state ?? ""
            pincode = profileData.first?.pincode ?? ""
            if let img = profileData.first?.profileImage {
                profileImage = Image(uiImage: UIImage(data: img) ?? UIImage())
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.profileUiImage = uiImage
                    self.profileImage = Image(uiImage: uiImage)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func saveButtonPressed() {
        if let profile = profileData.first {
            profile.firstName = firstName
            profile.lastName = lastName
            profile.address1 = address1
            profile.address2 = address2
            profile.city = city
            profile.state = state
            let jpegData = profileUiImage?.jpegData(compressionQuality: 1.0)
            profile.profileImage = jpegData
        } else {
            let data = ProfileEntity(context: manager.context)
            data.firstName = firstName
            data.lastName = lastName
            data.address1 = address1
            data.address2 = address2
            data.city = city
            data.state = state
            data.pincode = pincode
            let jpegData = profileUiImage?.jpegData(compressionQuality: 1.0)
            data.profileImage = jpegData
        }
        manager.saveItem()
    }
}
