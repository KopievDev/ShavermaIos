//
//  SpinerView.swift
//  VeLo Player
//
//  Created by Иван Копиев on 12.03.2024.
//

import UIKit

final class SpinnerView: Component {

    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }

    var color: UIColor = .staticWhite

    private var poses: [Pose] {
        [
            Pose(0.0, 0.000, 0.7),
            Pose(0.6, 0.500, 0.5),
            Pose(0.6, 1.000, 0.3),
            Pose(0.6, 1.500, 0.1),
            Pose(0.2, 1.875, 0.1),
            Pose(0.2, 2.250, 0.3),
            Pose(0.2, 2.625, 0.5),
            Pose(0.2, 3.000, 0.7),
        ]
    }

    override var layer: CAShapeLayer { super.layer as! CAShapeLayer }

    override class var layerClass: AnyClass { CAShapeLayer.self }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = 3
        layer.lineCap = .round
        setPath()
        startAnimation()
    }

    func startAnimation() {
        layer.removeAllAnimations()
        animate()
    }


    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }

    private func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }
        guard let last = times.last else { return }
        times.append(last)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
    }

    private func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        layer.add(animation, forKey: animation.keyPath)
    }
}

