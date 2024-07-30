//
//  Philippines.swift
//  Philippines
//
//  Created by Don Jose on 7/29/24.
//

import SwiftUI

struct Philippines: View {
    var body: some View {
        GeometryReader { proxy in
            let portrait = proxy.size.width < proxy.size.height
            
            Group {
                Stripes()
                Triangle()
                Sun()
                Stars()
                SunRays()
            }
            .aspectRatio(portrait ? 0.5 : 2, contentMode: .fit)
            .position(x: proxy.size.width * 0.5,
                      y: proxy.size.height * 0.5)
        }
    }
}

#Preview {
    Philippines()
}

struct SunRays: View {
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let side = min(width,height) / 90 * 19
            let hypotenuse = sqrt(side * side + side * side)
            let center = min(width,height) / 90 * 28
            let portrait = width < height
            let position = portrait
            ? CGPoint(x: width * 0.5, y: center)
            : CGPoint(x: center, y: height * 0.5)
            
            ForEach(0 ..< 8) { item in
                SunRay()
                    .frame(width: hypotenuse, height: hypotenuse)
                    .clipped()
                    .rotationEffect(.degrees(Double(item) * 45))
                    .foregroundStyle(Color.GoldenYellow)
            }
            .position(position)
        }
    }
}

struct SunRay: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let startingAngle = 45.0
            let gapAngle = 3.75
            let computeAngle = { (angles: (start: Double,
                                           end: Double)) -> (Double,Double) in
                ((startingAngle + angles.start).toRadians,
                 (startingAngle + angles.end).toRadians)
            }
            let point = { (angle: Double) -> CGPoint in
                let x = rect.midX + cos(angle) * rect.width
                let y = rect.midY + sin(angle) * rect.width
                
                return .init(x: x, y: y)
            }
            let angles: [(Double,Double)] = [
                (-gapAngle * 3, -gapAngle * 2),
                (-gapAngle, gapAngle),
                (gapAngle * 3, gapAngle * 2)]
            
            for index in (0 ..< 3) {
                let (startAngle, endAngle) = computeAngle(angles[index])
                
                path.addLines([.init(x: rect.midX, y: rect.midY),
                               point(startAngle),
                               point(endAngle)])
            }
        }
    }
}

struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            for item in (0 ..< 5) {
                let angle = Double(144 * item).toRadians
                let point = CGPoint(x: rect.midX + cos(angle) * rect.midX,
                                    y: rect.midY + sin(angle) * rect.midY)
                
                if item == 0 { path.move(to: point)}
                else { path.addLine(to: point)}
            }
            path.closeSubpath()
        }
    }
}

struct Stars: View {
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let portrait = width < height
            let diameter = min(width,height) / 9
            let angle = (30.0).toRadians
            let sizes = { (size: CGFloat) ->
                (CGFloat, CGFloat, CGFloat) in
                let side = size * 0.5
                return (side, tan(angle) * side, cos(angle) * side)
            }
            let (side, center, hypotenuse) =
            portrait ? sizes(width) : sizes(height)
            let location = portrait
            ? [90.0, 210.0, 330.0] : [0.0, 240.0, 120.0]
            
            ForEach (location.indices, id: \.self) { index in
                let angle = location[index].toRadians
                let cosX = cos(angle) * hypotenuse
                let sinY = sin(angle) * hypotenuse
                let position = portrait
                ? CGPoint(x: side + cosX, y: center + sinY)
                : CGPoint(x: center + cosX, y: side + sinY)
                
                Star()
                    .frame(width: diameter, height: diameter)
                    .foregroundStyle(Color.GoldenYellow)
                    .rotationEffect(.radians(angle))
                    .position(position)
            }

            // LINYA
//            if portrait {
//                Path { path in
//                    path.move(to: .zero)
//                    path.addLine(to: .init(x: width/2, y: center))
//                    path.move(to: .init(x: width/2, y: center))
//                    path.addLine(to: .init(x: width, y: 0))
//                }
//                .stroke(Color.red, lineWidth: 1)
//            }
//            else {
//                Path { path in
//                    path.move(to: .zero)
//                    path.addLine(to: .init(x: center, y: height/2))
//                    path.move(to: .init(x: center, y: height/2))
//                    path.addLine(to: .init(x: 0, y: height))
//                }
//                .stroke(Color.red, lineWidth: 1)
//            }
        }
    }
}

struct Sun: View {
    var body: some View {
        GeometryReader { proxy in
            let portrait = proxy.size.width < proxy.size.height
            let diameter = min(proxy.size.width,proxy.size.height) * 0.2
            let center = min(proxy.size.width,proxy.size.height) / 90 * 28
            let position = CGPoint(x: portrait ? proxy.size.width * 0.5 : center,
                                   y: portrait ? center : proxy.size.height * 0.5)
            
            Circle()
                .frame(width: diameter, height: diameter)
                .foregroundStyle(Color.GoldenYellow)
                .position(position)
        }
    }
}

struct Triangle: View {
    var body: some View {
        GeometryReader { proxy in
            let portrait = proxy.size.width < proxy.size.height
            let side1 = portrait
            ? proxy.size.width * 0.5
            : proxy.size.height * 0.5
            let hypotenuse = portrait ? proxy.size.width : proxy.size.height
            let side2 = sqrt(hypotenuse * hypotenuse - side1 * side1)
            let points: [CGPoint] = portrait
            ? [.zero,
               .init(x: proxy.size.width, y: 0),
               .init(x: proxy.size.width * 0.5,
                     y: side2)]
            : [.zero,
               .init(x: 0, y: proxy.size.height),
               .init(x: side2,
                     y: proxy.size.height * 0.5)]
            
            Path { path in
                path.addLines(points)
                path.closeSubpath()
            }
            .fill(Color.LibertyEqualityFraternity)
        }
    }
}

struct Stripes: View {
    var stripes: some View {
        Group {
            Color.RoyalBlue
            Color.Scarlet
        }
    }
    var body: some View {
        GeometryReader { proxy in
            let portrait = proxy.size.width < proxy.size.height
            
            if portrait { HStack (spacing: 0) { stripes}}
            else { VStack (spacing: 0) { stripes}}
        }
    }
}

extension Double {
    var toRadians: Double {
        self * (Double.pi / 180)
    }
}

extension Color {
    // Sun      - Unity, Freedom, People's Democracy, and Sovereignty
    // Sun rays - Provinces of Manila, Bulacan, Cavite, Pampanga, Bataan, Laguna, Batangas, and NuevaEcija
    // Star     - Luzon, Visayas, and Mindanao
    
    // RGB      - 252-209-22
    static let GoldenYellow = Color(#colorLiteral(red: 0.9934179187, green: 0.8445430398, blue: 0.09630902857, alpha: 1))
    
    // RGB      - 0-56-168
    // Peace, Truth, and Justice
    static let RoyalBlue = Color(#colorLiteral(red: 0, green: 0.2196078431, blue: 0.6588235294, alpha: 1))
    
    // RGB      - 206-17-38
    // Patriotism and Valor
    static let Scarlet = Color(#colorLiteral(red: 0.8078431373, green: 0.06666666667, blue: 0.1490196078, alpha: 1))
    
    // RGB      - 255-255-255
    // Liberty, Equality, and Fraternity
    static let LibertyEqualityFraternity = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
}
