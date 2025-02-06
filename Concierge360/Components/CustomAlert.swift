import SwiftUI

struct CustomAlert: View {
    @Binding var show: Bool
    @State var animateCircle = false
    var icon: UIImage = .checkmarkx
    var text = "Error"
    var gradientColor: Color = .red
    var circleAColor: Color = .green
    var details: String  = "Something went wrong"
    var corner:CGFloat = 30
    
    var body: some View {
        ZStack {
            // Arkaplan overlay
            if show {
                // Arka plan sis efekti
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        /// buraya birseyler ekleriz sonra
                    }
            }
            
            // Mevcut alert tasarımı
            VStack {
                Spacer()
                ZStack {
                    /*
                    RoundedRectangle(cornerRadius: corner)
                        .frame(height: 300)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.clear,.clear, gradientColor]), startPoint: .top, endPoint: .bottom).opacity(0.4))
                        .offset(y: show ? 0 : 700)
                     */

                    ZStack {
                        RoundedRectangle(cornerRadius: corner).foregroundStyle(.white)
                            .frame(height: 300)
                            .shadow(color: .black.opacity(0.01), radius: 20, x: 0.0, y: 0.0)
                            .shadow(color: .black.opacity(0.1), radius: 30, x: 0.0, y: 0.0)
                        VStack(spacing: 20) {
                            ZStack {
                                Circle().stroke(lineWidth: 2).foregroundStyle(circleAColor)
                                    .frame(width: 105, height: 105)
                                    .scaleEffect(animateCircle ? 1.3 : 0.90)
                                    .opacity(animateCircle ? 0 : 1)
                                    .animation(.easeInOut(duration: 2).delay(1).repeatForever(autoreverses: false), value: animateCircle)
                                Circle().stroke(lineWidth: 2).foregroundStyle(circleAColor)
                                    .frame(width: 105, height: 105)
                                    .scaleEffect(animateCircle ? 1.3 : 0.90)
                                    .opacity(animateCircle ? 0 : 1)
                                    .animation(.easeInOut(duration: 2).delay(1.5).repeatForever(autoreverses: false), value: animateCircle)
                                    .onAppear() {
                                        animateCircle.toggle()
                                    }
                                Image(uiImage: icon)
                            }
                            VStack {
                                Text(text).bold().font(.system(size: 30))
                                Text(details).opacity(0.5)
                            }
                            .padding(.horizontal, 20)
                            .foregroundStyle(.black)
                        }
                    }
                    .padding(.horizontal,10)
                    .offset(y: show ? 0 : 700)
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onChange(of: show) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        show = false
                    }
                }
            }
        }
    }
}

#Preview {
    CustomAlert(show: .constant(true))
}
