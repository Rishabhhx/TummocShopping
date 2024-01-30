//
//  FavouriteViewModel.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 28/01/24.
//

import Foundation
import CoreData

class FavouriteViewModel: ObservableObject {
    
    @Published var favList : [ItemsEntity] = []
    @Published var favData : [FavouriteEntity] = []
    let manager = CoreDataManager.shared
    
    func getFavList() {
        let fetchRequest = NSFetchRequest<FavouriteEntity>(entityName: "FavouriteEntity")
        do {
            favData = try manager.context.fetch(fetchRequest)
            if let totalItems = favData.first?.items?.allObjects as? [ItemsEntity] {
                favList = totalItems
            }
        } catch {
            print(error)
        }
    }
    
    func updateItemMakeFavourite(item: ItemsEntity) {
        item.isFavourite = false
        removeFavList(item: item)
    }
    
    func removeFavList(item: ItemsEntity) {
        if let favFirst = favData.first {
            favFirst.removeFromItems(item)
            manager.saveItem()
            getFavList()
        }
    }
}
