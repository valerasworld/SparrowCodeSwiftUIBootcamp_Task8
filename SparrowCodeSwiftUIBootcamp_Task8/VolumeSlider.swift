//
//  VolumeSlider.swift
//  SparrowCodeSwiftUIBootcamp_Task8
//
//  Created by Валерий Зазулин on 22.03.2024.
//

import SwiftUI

struct VolumeSlider: View {
    
   
    var body: some View {
        ZStack {
            Background()
            
            
        }
    }
    
    
}

fileprivate extension View {
    @ViewBuilder
    func optionalSizingModifiers(size: CGSize, progress: CGFloat, verticalSize: CGFloat, isStretched: Bool) -> some View {
        
        withAnimation(.smooth) {
            self
                .frame(
                    width: size.width,
                    height: progress < 0 ? size.height + (-progress * size.height) : nil
                )
            .scaleEffect(CGSize(width: isStretched ? 0.93 : 1, height: 1))
        }
    }
}

struct Background: View {
    @State var progress: CGFloat = 0.5
    @State var dragOffset: CGFloat = .zero
    @State var lastDragOffset: CGFloat = .zero
    @State var isStretched: Bool = false
    
    let startDate = Date()
    var body: some View {
        TimelineView(.animation) {
            let time = $0.date.timeIntervalSince1970 - startDate.timeIntervalSince1970
            ZStack(alignment: .bottom,
                   content: {
                    LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
                    .blur(radius: progress * 50)
                    LinearGradient(colors: [.orange, .purple], startPoint: .leading, endPoint: .trailing)
                        .frame(width: UIScreen.main.bounds.width + 120, height: UIScreen.main.bounds.height / 1.5)
                        .waveShader(WaveConfiguration(time: time, speed: 5, frequency: 60, amplitude: 10))
                        .rotationEffect(Angle.degrees(10))
                        .blur(radius: progress * 50)
                    LinearGradient(colors: [.purple, .cyan], startPoint: .leading, endPoint: .trailing)
                        .frame(width: UIScreen.main.bounds.width + 120, height: UIScreen.main.bounds.height / 2.5)
                        .waveShader(WaveConfiguration(time: time, speed: -3, frequency: 80, amplitude: 15))
                        .rotationEffect(Angle.degrees(-15))
                        .blur(radius: progress * 50)
                    LinearGradient(colors: [.cyan, .mint], startPoint: .leading, endPoint: .trailing)
                        .frame(width: UIScreen.main.bounds.width + 120, height: UIScreen.main.bounds.height / 3)
                        .waveShader(WaveConfiguration(time: time, speed: -5, frequency: 100, amplitude: 20))
                        .rotationEffect(Angle.degrees(15))
                        .offset(y: 100)
                        .blur(radius: progress * 50)

                GeometryReader {
                    let size = $0.size
                    let verticalSize = size.height
                    let progressValue = (max(progress, .zero)) * verticalSize
                    
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .background(.ultraThinMaterial)
                        
                        Rectangle()
                            .fill(.white)
                            .frame(height: progressValue)
                    }
                    .clipShape(.rect(cornerRadius: 20))
                    .contentShape(.rect(cornerRadius: 20))
                    .optionalSizingModifiers(size: size, progress: progress, verticalSize: verticalSize, isStretched: isStretched)
                    .gesture(
                        DragGesture()
                            .onChanged {
                                let translation = $0.translation
                                let movement = -translation.height + lastDragOffset
                                dragOffset = movement
                                calculateProgress(verticalSize: verticalSize)
                                withAnimation(.smooth) {
                                    if progress > 1 {
                                        isStretched = true
                                    }
                                    if progress <= 1 && progress >= 0 {
                                        isStretched = false
                                    }
                                    if progress < 0 {
                                        isStretched = true
                                    }
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.smooth) {
                                    dragOffset = dragOffset > verticalSize ? verticalSize : (dragOffset < 0 ? 0 : dragOffset)
                                    calculateProgress(verticalSize: verticalSize)
                                    isStretched = false
                                }
                                
                                lastDragOffset = dragOffset
                            }
                    )
                    .frame(
                        maxWidth: size.width,
                        maxHeight: size.height,
                        alignment: progress < 0 ? .top : .bottom
                    )
                }
                .frame(width: 80, height: 180)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            })
            
            .ignoresSafeArea()
        }
    }
    
    func calculateProgress(verticalSize: CGFloat) {
        let topExcessOffset = verticalSize + (dragOffset - verticalSize) * 0.05
        let bottomExcessOffset = dragOffset < 0 ? (dragOffset * 0.05) : dragOffset
        let progress = (dragOffset > verticalSize ? topExcessOffset : bottomExcessOffset) / verticalSize
        self.progress = progress > 1.1 ? 1.1 : progress
        self.progress = progress < -0.1 ? -0.1 : progress
    }
}

extension View {
    @ViewBuilder
    func waveShader(_ configuration: WaveConfiguration) -> some View {
        self
            .modifier(Helper(configuration: configuration))
    }
}

fileprivate struct Helper: ViewModifier {
    var configuration: WaveConfiguration
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 20)
            .background(Color.clear)
            .drawingGroup()
            .distortionEffect(
                .init(function: .init(library: .default, name: "wave"), arguments: [
                    .float(configuration.time),
                    .float(configuration.speed),
                    .float(configuration.frequency),
                    .float(configuration.amplitude)
                ]),
                maxSampleOffset: CGSize(width: 100, height: 100))
    }
}

struct WaveConfiguration {
    var time: TimeInterval
    var speed: CGFloat
    var frequency: CGFloat
    var amplitude: CGFloat
}

#Preview {
    VolumeSlider()
}
