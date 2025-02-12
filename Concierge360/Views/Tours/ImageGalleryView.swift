import SwiftUI

struct ImageGalleryView: View {
    let images: [String]
    @Binding var isPresented: Bool
    @State private var selectedIndex: Int
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var showControls = true
    
    init(images: [String], selectedIndex: Int, isPresented: Binding<Bool>) {
        self.images = images
        self._selectedIndex = State(initialValue: selectedIndex)
        self._isPresented = isPresented
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            // Gallery Content
            ZStack {
                // Images
                TabView(selection: $selectedIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        ZoomableImage(
                            image: images[index],
                            scale: $scale,
                            offset: $offset,
                            showControls: $showControls
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Controls Overlay
                if showControls {
                    VStack {
                        // Top Bar
                        HStack {
                            // Close Button
                            Button(action: { closeGallery() }) {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: "xmark")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            Spacer()
                            
                            // Image Counter
                            Text("\(selectedIndex + 1) / \(images.count)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 50)
                        
                        Spacer()
                        
                        // Bottom Bar
                        ImageStrip(
                            images: images,
                            selectedIndex: $selectedIndex
                        )
                        .padding(.bottom, 40)
                    }
                    .transition(.opacity)
                }
            }
        }
        .statusBar(hidden: true)
    }
    
    private func closeGallery() {
        withAnimation(.spring(dampingFraction: 0.8)) {
            isPresented = false
        }
    }
}

// MARK: - Supporting Views
private struct ZoomableImage: View {
    let image: String
    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    @Binding var showControls: Bool
    @State private var lastScale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0
    
    var body: some View {
        let magnificationGesture = MagnificationGesture()
            .updating($gestureScale) { currentState, gestureState, _ in
                gestureState = currentState
            }
            .onEnded { value in
                let newScale = lastScale * value
                scale = min(max(newScale, 1), 4)
                lastScale = scale
            }
        
        let dragGesture = DragGesture()
            .onChanged { value in
                if scale > 1 {
                    offset = value.translation
                }
            }
            .onEnded { value in
                if scale > 1 {
                    offset = value.translation
                } else {
                    withAnimation {
                        offset = .zero
                    }
                }
            }
        
        let tapGesture = TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    if scale > 1 {
                        scale = 1
                        offset = .zero
                    } else {
                        scale = 2
                    }
                    lastScale = scale
                }
            }
        
        let singleTapGesture = TapGesture()
            .onEnded {
                withAnimation {
                    showControls.toggle()
                }
            }
        
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(scale * gestureScale)
            .offset(offset)
            .gesture(SimultaneousGesture(magnificationGesture, dragGesture))
            .gesture(tapGesture)
            .gesture(singleTapGesture)
    }
}

private struct ImageStrip: View {
    let images: [String]
    @Binding var selectedIndex: Int
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedIndex == index ? Color.white : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedIndex = index
                                }
                            }
                            .id(index)
                    }
                }
                .padding(.horizontal, 20)
            }
            .onChange(of: selectedIndex) { newIndex in
                withAnimation {
                    proxy.scrollTo(newIndex, anchor: .center)
                }
            }
        }
        .background(.ultraThinMaterial)
    }
} 