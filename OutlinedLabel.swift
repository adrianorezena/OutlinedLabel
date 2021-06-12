//
//  OutlinedLabel.swift
//  OutlinedLabel
//
//  Created by Adriano Rezena on 12/06/21.
//

import UIKit


@IBDesignable
class OutlinedLabel: UILabel {
    

    private let gradientLayer = CAGradientLayer()

    
    // MARK: - Text properties
    var textGradientColors: [UIColor]? = nil {
        didSet {
            setupGradient()
        }
    }
    
    var textGradientLocations: [NSNumber]? = nil {
        didSet {
            setupGradient()
        }
    }
    
    var textGradientStartPoint: CGPoint? = nil {
        didSet {
            setupGradient()
        }
    }
    
    var textGradientEndPoint: CGPoint? = nil {
        didSet {
            setupGradient()
        }
    }
    
    
    // MARK: - Outline properties
    @IBInspectable
    var outlineWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var outlineColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    var outlineGradientColors: [UIColor]? = nil {
        didSet {
            setupGradient()
        }
    }
    
    
    var outlineGradientLocations: [NSNumber]? = nil {
        didSet {
            setupGradient()
        }
    }
    
    
    var outlineGradientStartPoint: CGPoint? = nil {
        didSet {
            setupGradient()
        }
    }
    
    var outlineGradientEndPoint: CGPoint? = nil {
        didSet {
            setupGradient()
        }
    }

    
    // MARK: - Lifecycle
    override func drawText(in rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let textColor = self.textColor

        let c = UIGraphicsGetCurrentContext()
        
        // Outline
        c?.setLineWidth(outlineWidth)
        c?.setLineJoin(.round)
        c?.setTextDrawingMode(.stroke)
        self.textAlignment = .center

        if let outlineGradientColors = outlineGradientColors {
            let textColorGradient = CAGradientLayer()
            let imageTextColor = makeGradientImage(
                gradientLayer: textColorGradient,
                colors: outlineGradientColors,
                locations: outlineGradientLocations,
                startPoint: outlineGradientStartPoint,
                endPoint: outlineGradientEndPoint,
                bounds: bounds)
            
            self.textColor = UIColor(patternImage: imageTextColor)
        } else {
            self.textColor = outlineColor
        }

        super.drawText(in:rect)

        // Shadow
        if let shadowColor = shadowColor {
            super.shadowColor = shadowColor
            super.shadowOffset = shadowOffset
            super.drawText(in:rect)
        }
        
        c?.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in:rect)

        self.shadowOffset = shadowOffset
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if gradientLayer.frame != bounds {
            setupGradient()
        }

    }
    
    
    // MARK: - Private
    private func setupGradient() {
        if let colors = textGradientColors {
            let pattern = makeGradientImage(
                gradientLayer: gradientLayer,
                colors: colors,
                locations: textGradientLocations,
                startPoint: textGradientStartPoint,
                endPoint: textGradientEndPoint,
                bounds: bounds)
            textColor = UIColor(patternImage: pattern)
        }
    }
    
    
    private func makeGradientImage(gradientLayer: CAGradientLayer, colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil, bounds: CGRect) -> UIImage {
        gradientLayer.colors = colors.compactMap({ $0.cgColor })
        
        if let locations = locations {
            gradientLayer.locations = locations
        }

        gradientLayer.frame = bounds
        
        
        if let startPoint = startPoint {
            gradientLayer.startPoint = startPoint
        }
        
        if let endPoint = endPoint {
            gradientLayer.endPoint = endPoint
        }
        
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, true, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        } else {
            return UIImage()
        }

    }
    
}

