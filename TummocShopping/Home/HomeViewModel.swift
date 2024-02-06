//
//  HomeViewModel.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 24/01/24.
//

import CoreData
import UIKit

class HomeViewModel: ObservableObject {
    @Published var showPopUp : Bool = false
    @Published var changeBack : Bool = false
    @Published var pushToFav : Bool = false
    @Published var pushToCart : Bool = false
    @Published var listData : ListData?
    @Published var model : [CategoryEntity] = []
    @Published var pushToProfile : Bool = false

    let manager = CoreDataManager.shared

    func getData() {
        if let path = Bundle.main.path(forResource: "shopping", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                let decoder = JSONDecoder()
                listData = try decoder.decode(ListData.self, from: data)
                if UserDefaults.standard.value(forKey: "dataFetch") is Bool {
                    getAllItems()
                } else {
                    UserDefaults.standard.set(true, forKey: "dataFetch")
                    clearPreviousData()
                    createItem()
                    getAllItems()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
}

extension HomeViewModel {
    
    func getAllItems() {
        do {
            let fetchRequest = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
            model = try manager.context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    func createItem() {
        guard let category = listData?.categories else {return}
        for list in category {
            let data = CategoryEntity(context: manager.context)
            data.id = "\(list.id ?? 0)"
            data.name = list.name
            guard let totalItem = list.items else {return}
            for item in totalItem {
                let itemData = ItemsEntity(context: manager.context)
                itemData.id = "\(item.id ?? 0)"
                itemData.name = item.name
                itemData.icon = item.icon
                itemData.price = item.price ?? 0.0
                itemData.isFavourite = false
                data.addToItems(itemData)
            }
        }
        manager.saveItem()
    }
    
    func updateItemMakeFavourite(item: ItemsEntity, fav: Bool) {
        item.isFavourite = fav
        addOrRemoveFavList(item: item, fav: fav)
    }
    
    func updateItemQuantity(item: ItemsEntity) {
        do {
            let fetchRequest = NSFetchRequest<CartEntity>(entityName: "CartEntity")
            let cartData = try manager.context.fetch(fetchRequest)
            if let cartFirst = cartData.first {
                item.quantity += 1
                cartFirst.addToItems(item)
            } else {
                let data = CartEntity(context: manager.context)
                item.quantity += 1
                data.addToItems(item)
            }
            manager.saveItem()
            getAllItems()
        } catch {
            print(error)
        }   
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
            } else {
                let data = FavouriteEntity(context: manager.context)
                data.addToItems(item)
            }
            manager.saveItem()
            getAllItems()
        } catch {
            print(error)
        }
    }
    
    func clearPreviousData() {
        do {
            let fetchRequest = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
            let categories = try manager.context.fetch(fetchRequest)
            for category in categories {
                manager.context.delete(category)
            }
            manager.saveItem()
        } catch {
            print("Failed to clear previous data: \(error)")
        }
    }
}
