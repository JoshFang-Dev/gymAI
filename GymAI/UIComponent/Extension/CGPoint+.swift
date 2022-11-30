//
//  CGPoint+.swift
//  GymAI
//
//  Created by Josh Fang on 2022-10-20.
//

import SwiftUI

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
