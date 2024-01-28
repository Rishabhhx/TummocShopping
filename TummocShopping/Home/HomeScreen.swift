//
//  HomeScreen.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 24/01/24.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HomeScreenHeader(pushToFav: $viewModel.pushToFav,pushToCart: $viewModel.pushToCart)
                    ScrollView(.vertical,showsIndicators: false) {
                        LazyVStack {
                            ForEach((viewModel.model), id: \.self) {item in
                                CardsView(viewModel: viewModel, category: item)
                            }
                        }
                        .padding(.bottom,50)
                    }
                    .padding(.top,20)
                    Spacer()
                }
                .ignoresSafeArea()
                CategoriesMenuView(showPopUp: $viewModel.showPopUp, changeBack: $viewModel.changeBack, viewModel: viewModel)
                CategoriesButtonView(showPopUp: $viewModel.showPopUp, changeBack: $viewModel.changeBack)
            }
            .onAppear() {
                viewModel.getData()
            }
            .navigationBarHidden(true)
            .navigationTitle("")
            .toolbar(.hidden)
        }
    }
}


#Preview {
    HomeScreen()
}

struct HomeScreenHeader: View {
    @Binding var pushToFav: Bool
    @Binding var pushToCart: Bool
    var body: some View {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        HStack {
            HStack(spacing: 15) {
                Image(systemName: "line.3.horizontal")
                Text("My Store")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
            }
            .padding(.leading, 20)
            Spacer()
            HStack(spacing: 15) {
                Button(action: {
                    pushToFav.toggle()
                }, label: {
                    Image(systemName: "heart")
                })
                .navigationDestination(isPresented: $pushToFav) {
                    FavouriteView()
                }
                Button(action: {
                    pushToCart.toggle()
                }, label: {
                    Image(systemName: "cart")
                })
                .navigationDestination(isPresented: $pushToCart) {
                    CartView()
                }
            }
            .padding(.trailing, 20)
        }
        .foregroundColor(.black)
        .padding(.top,height+20)
        .padding(.bottom,25)
        .background(LinearGradient(colors: [.orange.opacity(1),.yellow.opacity(0.6)], startPoint: .top, endPoint: .bottom))
        .clipShape(.rect(bottomLeadingRadius: 20, bottomTrailingRadius: 20))
    }
}

struct CardsView: View {
    
    @State var showFull = false
    @State var title: String = "Food"
    @ObservedObject var viewModel: HomeViewModel
    
    var category : CategoryEntity?
    var row: [GridItem] = [
        GridItem(.flexible())]
    var coloumn: [GridItem] = [
        GridItem(.flexible()),GridItem(.flexible())]
    
    var body: some View {
        VStack {
            HStack {
                Text(category?.name ?? "")
                    .font(.system(size: 22))
                    .fontWeight(.medium)
                Spacer()
                if showFull {
                    Button(action: {
                        showFull.toggle()
                    }, label: {
                        Image(systemName: "chevron.up")
                    })
                    .buttonStyle(.plain)
                } else {
                    Button(action: {
                        showFull.toggle()
                    }, label: {
                        Image(systemName: "chevron.down")
                    })
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal,20)
            Divider()
                .padding(.horizontal,20)
            if showFull {
                LazyVGrid(columns: coloumn,spacing: 20) {
                    if let totalItems = category?.items?.allObjects as? [ItemsEntity] {
                        ForEach(totalItems, id: \.self) { item in
                            ItemCardView(item: item, viewModel: viewModel)
                        }
                    }
                }
                .padding(20)
            } else {
                ScrollView(.horizontal,showsIndicators: false) {
                    LazyHGrid(rows: row,spacing: 20) {
                        if let totalItems = category?.items?.allObjects as? [ItemsEntity] {
                            ForEach(totalItems, id: \.self) { item in
                                ItemCardView(item: item, viewModel: viewModel)
                            }
                        }          
                    }
                    .padding(20)
                }
                .frame(height: 230)
            }
        }
        .padding(.vertical)
    }
}

struct ItemCardView: View {
    var item : ItemsEntity?
    @ObservedObject var viewModel : HomeViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                VStack {
                    AsyncImage(url: URL(string: item?.icon ?? ""), scale: 1) { image in
                        image
                            .resizable()
                            .frame(width: 100,height: 100)
                            .padding(.top,6)
                        
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 100,height: 100)
                            .padding(.top,6)
                    }
                    Spacer()
                        HStack {
                            VStack(alignment:.leading,spacing: 0) {
                                Text(item?.name ?? "")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                Text("₹" + String(format: "%.2f", item?.price ?? 1.0))
                                    .font(.system(size: 12))
                                    .fontWeight(.regular)
                            }
                            Spacer()
                            Button(action: {
                                viewModel.updateItemQuantity(item: item ?? ItemsEntity())
                            }, label: {
                                Image(systemName: "plus.app.fill")
                                    .resizable()
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(.orange)
                            })
                            .buttonStyle(.plain)
                        }
                        .padding(.bottom)
                        .padding(.horizontal)
                }
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.updateItemMakeFavourite(item: item ?? ItemsEntity(), fav: !(item?.isFavourite ?? false))
                        }, label: {
                            Image(systemName: item?.isFavourite ?? false ? "heart.fill" : "heart")
                                .resizable()
                                .foregroundColor(item?.isFavourite ?? false ? .red : .black)
                                .frame(width: 15,height: 15)
                        })
                        .buttonStyle(.plain)
                    }
                    .padding(.all, 7)
                    Spacer()
                }
            }
        }
        .background(.white)
        .frame(width: 150,height: 180)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: .gray.opacity(0.2), radius: 10,x: 5,y: 5)
    }
}

struct CategoriesButtonView: View {
    @Binding var showPopUp : Bool
    @Binding var changeBack : Bool

    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                withAnimation {
                    showPopUp.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        changeBack.toggle()
                    }
                }
            }, label: {
                Label(
                    title: { Text("Categories")
                        .bold()},
                    icon: { Image(systemName: "square.grid.2x2") }
                )
                .padding(10)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(10)
            })
            .offset(y: showPopUp ? 200 : 0)
            .buttonStyle(.plain)
            .padding(8)
        }
    }
}
extension PresentationDetent {
    static let small = Self.height(290)
}

struct CategoriesMenuView: View {
    @Binding var showPopUp : Bool
    @Binding var changeBack : Bool
    @ObservedObject var viewModel : HomeViewModel

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                ForEach(viewModel.model, id: \.self) { category in
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                showPopUp.toggle()
                            }
                        }
                        withAnimation {
                            changeBack.toggle()
                        }
                    }, label: {
                        Text(category.name ?? "")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .padding(.horizontal,20)
                    })
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .frame(height: 200)
            .background(.white)
            .cornerRadius(30)
            .padding(.horizontal,40)
            Button(action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        showPopUp.toggle()
                    }
                }
                withAnimation {
                    changeBack.toggle()
                }
            }, label: {
                ZStack {
                    Circle()
                        .fill(.orange)
                        .frame(width: 50, height: 50)
                    Text("X")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
            })
            .buttonStyle(.plain)
        }
        .background(changeBack ? .black.opacity(0.4) : .clear)
        .offset(y: showPopUp ? 0 : 2000)
        .animation(.easeInOut, value: showPopUp)
    }
}
