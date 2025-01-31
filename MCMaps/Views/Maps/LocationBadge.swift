//
//  LocationBadge.swift
//  MCMaps
//
//  Created by Marquis Kurt on 01-02-2025.
//

import CubiomesKit
import SwiftUI

struct LocationBadge: View {
    var location: CGPoint

    private var locationLabel: String {
        let xPos = String(Int(location.x))
        let yPos = String(Int(location.y))
        
        return "X: \(xPos), Z: \(yPos)"
    }

    init(location: CGPoint) {
        self.location = location
    }

    init(location: Point3D<Int32>) {
        self.location = CGPoint(x: Double(location.x), y: Double(location.z))
    }
    
    var body: some View {
        HStack {
            Label(locationLabel, systemImage: "location.fill")
                .padding(2)
                .padding(.vertical, 1)
                .padding(.horizontal, 4)
        }
        .background(Capsule().fill(.thinMaterial))
        .padding(8)
    }
}

#Preview {
    Group {
        LocationBadge(location: .init(x: 99, y: 99))
    }
    .background(Color.blue)

}
