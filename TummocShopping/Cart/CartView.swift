//
//  CartView.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 24/01/24.
//

import SwiftUI

struct CartView: View {
    @StateObject var viewModel = CartViewModel()
    var body: some View {
        VStack {
            FavouriteHeaderView(title: "Cart")
            ScrollView {
                LazyVStack(spacing: 20,content: {
                    ForEach(viewModel.cartList, id: \.self) { item in
                        CartCellView(item: item, viewModel: viewModel)
                    }
                })
                .padding(.vertical)
            }
            .padding(.bottom,20)
            Spacer()
            if !viewModel.cartList.isEmpty {
                TotalView(viewModel: viewModel)
                CheckOutButton()
            }
            Spacer()
        }
        .onAppear() {
            viewModel.getCartList()
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .toolbar(.hidden)
    }
}

#Preview {
    CartView()
}

struct CartCellView: View {
    var item : ItemsEntity?
    @ObservedObject var viewModel : CartViewModel

    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: item?.icon ?? ""), scale: 1) { image in
                image
                    .resizable()
                    .frame(width: 80)
                    .padding(20)
                
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 80)
                    .padding(20)
            }
            VStack(alignment: .leading) {
                Text(item?.name ?? "")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                Spacer()
                Text("₹" + String(format: "%.2f", item?.price ?? 1.0))
                    .font(.system(size: 14))
            }
            .padding(.vertical,20)
            Spacer()
            VStack(alignment: .trailing) {
                HStack(spacing: 8) {
                    Button(action: {
                        viewModel.subItemQuantity(item: item ?? ItemsEntity())
                    }, label: {
                        Image(systemName: "minus.square.fill")
                            .resizable()
                            .frame(width: 25,height: 25)
                            .foregroundColor(.orange)
                    })
                    Text("\(item?.quantity ?? 0)")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    Button(action: {
                        viewModel.addItemQuantity(item: item ?? ItemsEntity())
                    }, label: {
                        Image(systemName: "plus.app.fill")
                            .resizable()
                            .frame(width: 25,height: 25)
                            .foregroundColor(.orange)
                    })
                }
                Spacer()
                Text("₹" + String(format: "%.2f", Double(item?.quantity ?? 1) * (item?.price ?? 1.0)))
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
            }
            .buttonStyle(.plain)
            .padding(.vertical,20)
            .padding(.trailing)
        }
        .background(.white)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: .gray.opacity(0.2), radius: 10,x: 5,y: 5)
        .frame(height: 100)
        .padding(.horizontal,20)
    }
}

struct TotalView: View {
    @ObservedObject var viewModel : CartViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Sub total")
                    .font(.system(size: 14))
                    .fontWeight(.regular)
                Spacer()
                Text("₹" + String(format: "%.2f", viewModel.calculateTotal()))
                    .font(.system(size: 14))
                    .fontWeight(.regular)
            }
            .padding(10)
            HStack {
                Text("Discount")
                    .font(.system(size: 14))
                    .fontWeight(.regular)
                Spacer()
                Text("-40")
                    .font(.system(size: 14))
                    .fontWeight(.regular)
            }
            .padding(10)
            Divider()
            HStack {
                Text("Total")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                Spacer()
                Text("₹" + String(format: "%.2f", viewModel.calculateTotal() - 40))
                    .font(.system(size: 14))
                    .fontWeight(.regular)
            }
            .padding(10)
        }
        .padding()
        .background(.gray.opacity(0.2))
        .cornerRadius(20)
        .padding(.horizontal,20)
        .padding(.bottom)
    }
}

struct CheckOutButton: View {
    var body: some View {
        Button {
            
        } label: {
            Text("Checkout")
                .font(.system(size: 25))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(.orange)
        .clipShape(.rect(cornerRadius: 10))
        .padding(.horizontal,20)
    }
}
