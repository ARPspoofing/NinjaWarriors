//
//  CanvasView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 15/3/24.
//

import Foundation
import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @State private var isShowingEntityOverlay = false

    @State private var matchId: String
    @State private var playerId: String
    @State private var joystickPosition: CGPoint = .zero
    @State private var renderedImage: Image?

    init(matchId: String, currPlayerId: String) {
        self.matchId = matchId
        self.playerId = currPlayerId
        self.viewModel = CanvasViewModel(matchId: matchId, currPlayerId: currPlayerId)
    }

    var body: some View {
        ZStack {
            Image("grass-stone")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                GeometryReader { geometry in
                    ZStack {
                        Text("\(viewModel.entities.count)")
                        if let positions = viewModel.positions, positions.count > 0 {
                            ForEach(Array(viewModel.entities.enumerated()), id: \.element.id) { index, entity in
                                VStack {
                                    Group {
                                        if let renderedImage = renderedImage {
                                            renderedImage
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 50)
                                                .position(positions[index])
                                        } else {
                                            Text("Loading...")
                                        }
                                    }
                                    .onAppear {
                                        renderImage(for: entity)
                                    }
                                }
                            }
                        }
                    }
                    if let currPlayer = viewModel.getCurrPlayer() {
                        JoystickView(
                            setInputVector: { vector in
                                viewModel.gameWorld.setInput(vector, for: currPlayer)
                            }, location: CGPoint(x: 200, y: geometry.size.height - 300))
                        .frame(width: 200, height: 200)
                        VStack {
                            Spacer()
                            HStack {
                                ZStack {
                                    Button(action: {
                                        isShowingEntityOverlay.toggle()
                                    }, label: {
                                        Image(systemName: "eye")
                                        .accessibilityLabel("Toggle Entity Overlay")})
                                    .padding()
                                    .background(Color.blue.opacity(0.7))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                }
                                HStack {
                                    ForEach(viewModel.getSkills(for: currPlayer), id: \.key) { key, value in
                                        Button(action: {
                                            viewModel.activateSkill(forEntity: currPlayer, skillId: key)
                                        }, label: {
                                            Text("\(key) \(String(format: "%.1f", value.cooldownRemaining))")
                                        })
                                        .padding()
                                        .background(Color.white.opacity(0.7))
                                    }
                                }
                            }.frame(maxWidth: .infinity, maxHeight: 100)
                                .background(Color.red.opacity(0.5))
                        }
                    }
                    EntityOverlayView(entities: viewModel.entities,
                                      componentManager: viewModel.gameWorld.entityComponentManager)
                    .zIndex(-1)
                    .opacity(isShowingEntityOverlay ? 1 : 0)

                }
                .onAppear {
                    viewModel.addListeners()
                }
            }
        }
    }

    private func renderImage(for entity: Entity) {
        if let spriteComponent = viewModel.gameWorld.entityComponentManager.getComponent(ofType: Sprite.self, for: entity) {
            renderedImage = Image(spriteComponent.image)
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(matchId: "SampleMatchID", currPlayerId: "SamplePlayerID")
    }
}
