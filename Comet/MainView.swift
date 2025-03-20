//
//  MainView.swift
//  Comet
//
//  Created by 小序 on 3/19/25.
//


//
//  MainView.swift
//  Comet
//
//  Created by 小序 on 3/15/25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 2  // 默认打开 "生成" 页面

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

            GenerateView() // 生成页
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28)) // 放大主按钮
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
        .accentColor(.red) // 让 Tab 选中颜色变为红色，更符合 UI 风格
    }
}

// 预览
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
