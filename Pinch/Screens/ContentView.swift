//
//  ContentView.swift
//  Pinch
//
//  Created by kirshi on 2/13/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTY
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = true
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 0
    
    //MARK: - FUNCTION
    
    func resetImage(){
        withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    //MARK: - CONTENT
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                
                Image(pages[pageIndex].imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .opacity(isAnimating ? 1 : 0)
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .offset(imageOffset)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()){
                            if imageScale == 1 {
                                imageScale = 5
                            } else {
                                resetImage()
                            }
                        }
                    }
                    .gesture(DragGesture().onChanged { gesture in
                        withAnimation(.linear(duration: 1)) {
                            imageOffset = gesture.translation
                        }
                    }.onEnded({ _ in
                        if(imageScale == 1){
                            resetImage()
                        }
                    }))
                    .gesture(MagnificationGesture()
                        .onChanged({ value in
                            withAnimation(.linear(duration: 1)) {
                                if imageScale >= 1 && imageScale <= 5 {
                                    imageScale = value
                                } else if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                        })
                            .onEnded({ _ in
                                if imageScale > 5{
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImage()
                                }
                            }))
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .overlay (
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            .overlay (
                Group {
                    HStack {
                        Button {
                            withAnimation {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImage()
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.system(size: 36))
                        }
                        Button {
                            resetImage()
                        } label: {
                            Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                                .font(.system(size: 36))
                        }
                        Button {
                            withAnimation {
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.system(size: 36))
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            .overlay(
                HStack(spacing: 12) {
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    ForEach(pages) { page in
                        Image(page.thumbnailImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                            }
                    }
                    
                    Spacer()
                }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                , alignment: .topTrailing
            )
        } //: NAVIGATION
        .navigationViewStyle(.stack)
        .onAppear {
            isAnimating = true
        }
    }
}


//MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
