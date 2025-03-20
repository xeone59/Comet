//
//  HomeView.swift
//  Comet
//
//  Created by 小序 on 3/18/25.
//


import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 2 // 默认选中 "生成" 页面

    var body: some View {
        TabView(selection: $selectedTab) {
            RecommendationView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("推荐")
                }
                .tag(0)

            RankingView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("排行榜")
                }
                .tag(1)

            GenerateView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                    Text("生成")
                }
                .tag(2)

            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("收藏")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("个人资料")
                }
                .tag(4)
        }
        .accentColor(.pink) // 设置 Home Bar 选中颜色
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
