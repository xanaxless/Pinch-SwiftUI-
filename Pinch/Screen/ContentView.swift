//
//  ContentView.swift
//  Pinch
//
//  Created by Yerkebulan Serikov on 16.04.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    
    func resetImageState(){
        withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.clear
                
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1:0)
                    .offset(imageOffset)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .scaleEffect(imageScale)
                    .onTapGesture(count:2) {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        }else{
                             resetImageState()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = gesture.translation
                                }
                            }
                            .onEnded{ gesture in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                                
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged{ value in
                                withAnimation(.linear(duration:1)){
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5{
                                        imageScale = 5
                                    }
                                }
                                
                            }
                            .onEnded { value in
                                if imageScale > 5{
                                    imageScale = 5
                                }else if imageScale <= 1 {
                                    resetImageState()
                                }
                                
                            }
                    )
                
            }
            .navigationTitle("Pinch and Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isAnimating = true
            }
            .overlay(
            InfoPanelView(scale: imageScale, offset: imageOffset)
                .padding(.horizontal)
                .padding(.top, 30)
            , alignment: .top
            )
            .overlay(
                Group{
                    HStack{
                        Button {
                            withAnimation(.spring()){
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1{
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        Button {
                            withAnimation(.spring()){
                                if imageScale < 5{
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }

                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            .overlay(
                HStack(spacing: 12){
                    Image(systemName: "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height:40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                
                , alignment: .topTrailing
            )
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
