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
    
    let manager = CoreDataManager.shared
    
    func getFavList() {
        favList = []
        let fetchRequest = NSFetchRequest<FavouriteEntity>(entityName: "FavouriteEntity")
        do {
            let data = try manager.context.fetch(fetchRequest)
            if let totalItems = data.first?.items?.allObjects as? [ItemsEntity] {
                for item in totalItems {
                    favList.append(item)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func updateItemMakeFavourite(item: ItemsEntity, fav: Bool) {
        item.isFavourite = fav
        addOrRemoveFavList(item: item, fav: fav)
    }
    
    func addOrRemoveFavList(item: ItemsEntity, fav: Bool) {
        do {
            let fetchRequest = NSFetchRequest<FavouriteEntity>(entityName: "FavouriteEntity")
            let favData = try manager.context.fetch(fetchRequest)
            if let favFirst = favData.first {
                if fav {
                    favFirst.addToItems(item)
                } else {
                    favFirst.removeFromItems(item)
                }
            }
        } catch {
            print(error)
        }
        manager.saveItem()
        getFavList()
    }
}
