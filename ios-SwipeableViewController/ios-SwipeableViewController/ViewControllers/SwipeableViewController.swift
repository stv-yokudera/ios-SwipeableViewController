//
//  SwipeableViewController.swift
//  ios-SwipeableViewController
//
//  Created by OkuderaYuki on 2017/12/31.
//  Copyright © 2017年 OkuderaYuki. All rights reserved.
//

import UIKit

protocol SwipeableProtocol: class {

    var maxVerticalChange: CGFloat { get }
    var minDistance: CGFloat { get }
    var minDuration: CGFloat { get }
    var minSpeed: CGFloat { get }

    var startPoint: CGPoint? { get set }
    var startTime: TimeInterval? { get set }

    func detectSwiped(speed: CGFloat)
}

class SwipeableViewController: UIViewController, SwipeableProtocol {

    let maxVerticalChange: CGFloat = 150.0
    let minDistance: CGFloat = 50.0
    let minDuration: CGFloat = 0.1
    let minSpeed: CGFloat = 100.0

    var startPoint: CGPoint?
    var startTime: TimeInterval?

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // TODO: Check what was tapped

        // Avoid multi-touch gesture
        if touches.count > 1 {
            return
        }

        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self.view)
        startPoint = location
        startTime = touch.timestamp
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard let touch = touches.first, let startPoint = startPoint, let startTime = startTime else {
            return
        }

        let location = touch.location(in: self.view)

        let dx = location.x - startPoint.x
        let dy = location.y - startPoint.y
        print("dx: \(dx)")
        print("dy: \(dy)")

        if dy >= 0 {
            print("Swiped down.")
            return
        }

        let verticalChange = sqrt(dx * dx)
        if verticalChange >= maxVerticalChange {
            print("Vertical change too large.")
            return
        }

        let distance = sqrt(dx * dx + dy * dy)
        print("distance: \(distance)")

        if distance >= minDistance {
            // Determine time difference from start of the gesture
            let dt = CGFloat(touch.timestamp - startTime)
            print("dt: \(dt)")
            if dt > minDuration {
                // Determine gesture speed in points/sec
                let speed = CGFloat(distance) / dt
                print("speed: \(speed)")
                if speed >= minSpeed {
                    // Swipe detected
                    detectSwiped(speed: speed)
                } else {
                    print("The speed is too slow.")
                }
            } else {
                print("The duration of the swipe is too short.")
            }
        } else {
            print("The distance is too short.")
        }
    }

    func detectSwiped(speed: CGFloat) {
        print("Swipe detected!")
        print("Swipe speed: \(speed)")
    }
}
