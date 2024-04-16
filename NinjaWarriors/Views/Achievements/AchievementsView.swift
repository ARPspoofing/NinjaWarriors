//
//  AchievementsView.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 16/4/24.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var achievementManager: AchievementManager
    let columns = [GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    let sortedAchievements = achievementManager.achievements.sorted {
                        $0.isUnlocked && !$1.isUnlocked
                    }
                    ForEach(achievementManager.achievements, id: \.title) { achievement in
                        AchievementRow(achievement: achievement)
                    }
                }
            }
        }.navigationTitle("Achievements")
    }
}