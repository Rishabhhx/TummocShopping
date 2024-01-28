//
//  CartViewModel.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 28/01/24.
//

import Foundation
import CoreData

class CartViewModel: ObservableObject {
    @Published var cartList : [ItemsEntity] = []
    
    let manager = CoreDataManager.shared
    
    func getCartList() {
        cartList = []
        let fetchRequest = NSFetchRequest<CartEntity>(entityName: "CartEntity")
        do {
            let data = try manager.context.fetch(fetchRequest)
            if let totalItems = data.first?.items?.allObjects as? [ItemsEntity] {
                for item in totalItems {
                    cartList.append(item)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func calculateTotal() -> Double {
        return cartList.compactMap{$0.price * Double($0.quantity)}.reduce(0, +)
    }
    
    func addItemQuantity(item: ItemsEntity) {
        do {
            let fetchRequest = NSFetchRequest<CartEntity>(entityName: "CartEntity")
            let cartData = try manager.context.fetch(fetchRequest)
            if let cartFirst = cartData.first {
                if let totalItems = cartFirst.items?.allObjects as? [ItemsEntity] {
                    item.quantity += 1
                    cartFirst.addToItems(item)
                }
            } else {
                let data = CartEntity(context: manager.context)
                item.quantity += 1
                data.addToItems(item)
            }
            manager.saveItem()
            getCartList()
        } catch {
            print(error)
        }
    }
    
    func subItemQuantity(item: ItemsEntity) {
        do {
            let fetchRequest = NSFetchRequest<CartEntity>(entityName: "CartEntity")
            let cartData = try manager.context.fetch(fetchRequest)
            if let cartFirst = cartData.first {
                if let totalItems = cartFirst.items?.allObjects as? [ItemsEntity] {
                    item.quantity -= 1
                    if item.quantity <= 0 {
                        item.quantity = 0
                        cartFirst.removeFromItems(item)
                    }
                }
            }
            manager.saveItem()
            getCartList()
        } catch {
            print(error)
        }
    }
}
