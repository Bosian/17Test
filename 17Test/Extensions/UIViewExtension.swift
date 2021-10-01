//
//  UIViewExtension.swift
//  BrandApp
//
//  Created by Bobson on 2016/2/19.
//  Copyright © 2016年 Bobson. All rights reserved.
//

import UIKit

// MARK: - Associated Object
private var gradientTopKey: Void?
private var gradientBottomKey: Void?
private var gradientLayerKey: Void?

private var dottedLineColorKey: Void?
private var dottedLineWidthKey: Void?
private var dottedLinePatternKey: Void?
private var dottedLineLayerKey: Void?
private var isDottedLineVerticalKey: Void?
private var dottedLineOffsetKey: Void?

extension UIView {
    
    /**
     陰影效果 位移
     */
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }

        set {
            self.layer.shadowOffset = newValue
        }
    }

    /**
     陰影效果 透明度
     */
    @IBInspectable public var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }

        set {
            self.layer.shadowOpacity = newValue
        }
    }

    /**
     陰影效果 半徑
     */
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }

        set {
            self.layer.shadowRadius = newValue
        }
    }

    /**
     陰影效果 顏色
     */
    @IBInspectable public var shadowColor: UIColor? {
        get {
            guard let cgColor = self.layer.shadowColor else {
                return nil
            }

            return UIColor(cgColor: cgColor)
        }

        set {
            self.layer.shadowColor = newValue?.cgColor
            self.layer.masksToBounds = false
        }
    }

    /**
     加入陰影效果
     */
    public func shadow(_ shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat, shadowColor: CGColor?) {
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor
    }

    /**
     框線粗細
     */
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }

        set {
            self.layer.borderWidth = newValue
        }
    }

    /**
     框線效果 顏色
     */
    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let cgColor = self.layer.borderColor else {
                return nil
            }

            return UIColor(cgColor: cgColor)
        }

        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }

    /**
     外框 圓角半徑
     */
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }

        set {
            self.layer.cornerRadius = newValue

            if newValue != 0 {
                self.layer.masksToBounds = true
                self.clipsToBounds = true
            }
        }
    }

    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {

        // Fix corner is not full length
        layoutIfNeeded()

        let path: UIBezierPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let maskLayer: CAShapeLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }

    @IBInspectable public var maskToBound: Bool {
        get {
            return self.layer.masksToBounds
        }

        set {
            self.layer.masksToBounds = newValue
        }
    }

    @IBInspectable open var gradientTop: UIColor? {
        get {
            return objc_getAssociatedObject(self, &gradientTopKey) as? UIColor
        }

        set {
            objc_setAssociatedObject(self, &gradientTopKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateGradientLayer()
        }
    }

    @IBInspectable open var gradientBottom: UIColor? {
        get {
            return objc_getAssociatedObject(self, &gradientBottomKey) as? UIColor
        }

        set {
            objc_setAssociatedObject(self, &gradientBottomKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateGradientLayer()
        }
    }

    private var gradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &gradientLayerKey) as? CAGradientLayer
        }

        set {
            objc_setAssociatedObject(self, &gradientLayerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }

    open func updateGradientLayer() {

        guard let gradientTop = gradientTop?.cgColor,
            let gradientBottom = gradientBottom?.cgColor else {

            return
        }

        let gradientLayer: CAGradientLayer
        if let gradientLayerUnwrapped = self.gradientLayer {
            gradientLayer = gradientLayerUnwrapped
        } else {
            gradientLayer = CAGradientLayer()
            gradientLayer.colors = [gradientTop, gradientBottom]

            self.layer.addSublayer(gradientLayer)

            self.gradientLayer = gradientLayer
        }

        self.setNeedsLayout()
        self.layoutIfNeeded()

        gradientLayer.frame = self.bounds
    }
    
    @objc public func toPDF(
        path: URL,
        didBeginPDFContext: ((_ pdfContext: CGContext, _ pdfPageBounds: CGRect, _ pageOriginY: CGFloat) -> CGFloat)?,
        willEndPDFContext: ((_ pdfContext: CGContext, _ pdfPageBounds: CGRect, _ pageOriginY: CGFloat) -> Void)?
        ) {
        
        let view: UIView = self
        view.setNeedsLayout()
        
        let pdfPageBounds: CGRect = view.bounds
        let pdfData: NSMutableData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        UIGraphicsBeginPDFPage()

        guard let pdfContext: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }

        var pageOriginY: CGFloat = pdfPageBounds.size.height
        
        if let y: CGFloat = didBeginPDFContext?(pdfContext, pdfPageBounds, pageOriginY) {
            pageOriginY = y
        }

        view.layer.render(in: pdfContext)
        
        willEndPDFContext?(pdfContext, pdfPageBounds, pageOriginY)
        
        UIGraphicsEndPDFContext()

        pdfData.write(to: path, atomically: true)
    }
    
    @IBInspectable public var dottedLineColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &dottedLineColorKey) as? UIColor
        }
        
        set {
            objc_setAssociatedObject(self, &dottedLineColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateDottedLine()
        }
    }
    
    @IBInspectable public var dottedLineWidth: CGFloat {
        get {
            return objc_getAssociatedObject(self, &dottedLineWidthKey) as? CGFloat ?? 0.0
        }
        
        set {
            objc_setAssociatedObject(self, &dottedLineWidthKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateDottedLine()
        }
    }
    
    @IBInspectable public var dottedLinePattern: CGPoint {
        get {
            return objc_getAssociatedObject(self, &dottedLinePatternKey) as? CGPoint ?? CGPoint.zero
        }
        
        set {
            objc_setAssociatedObject(self, &dottedLinePatternKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateDottedLine()
        }
    }
    
    public var isDottedLineVertical: Bool {
        get {
            return objc_getAssociatedObject(self, &isDottedLineVerticalKey) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &isDottedLineVerticalKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateDottedLine()
        }
    }
    
    public var dottedLineOffset: CGFloat {
        get {
            return objc_getAssociatedObject(self, &dottedLineOffsetKey) as? CGFloat ?? CGFloat.zero
        }
        
        set {
            objc_setAssociatedObject(self, &dottedLineOffsetKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateDottedLine()
        }
    }
    
    private var dottedLineLayer: CAShapeLayer? {
        get {
            return objc_getAssociatedObject(self, &dottedLineLayerKey) as? CAShapeLayer
        }
        
        set {
            objc_setAssociatedObject(self, &dottedLineLayerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            updateDottedLine()
        }
    }
    
    public func updateDottedLine() {
        
        let dottedLineLayer: CAShapeLayer
        if let dottedLineLayerUnwrapped = self.dottedLineLayer {
            dottedLineLayer = dottedLineLayerUnwrapped
        } else {
            dottedLineLayer = CAShapeLayer()
            self.layer.addSublayer(dottedLineLayer)
            self.dottedLineLayer = dottedLineLayer
        }
        
        func updateUI() {
            dottedLineLayer.strokeColor = dottedLineColor?.cgColor
            dottedLineLayer.lineWidth = dottedLineWidth
            
            let lineDashPattern: [NSNumber] = [NSNumber(value: Double(dottedLinePattern.x)), NSNumber(value: Double(dottedLinePattern.y))]
            dottedLineLayer.lineDashPattern = lineDashPattern // 7 is the length of dash, 3 is length of the gap.
        }
        
        updateUI()
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let startPoint: CGPoint
        let endPoint: CGPoint
        if isDottedLineVertical {
            startPoint = CGPoint(x: dottedLineOffset, y: 0)
            endPoint = CGPoint(x: dottedLineOffset, y: self.bounds.size.height)
        } else {
            startPoint = CGPoint(x: 0, y: dottedLineOffset)
            endPoint = CGPoint(x: self.bounds.size.width, y: dottedLineOffset)
        }

        let path = CGMutablePath()
        path.addLines(between: [startPoint, endPoint])
        dottedLineLayer.path = path
    }
    
    public static func fromNib<T: UIView>() -> T? {

        guard let view = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T else {
            assertionFailure("Should not be nil")
            return nil
        }

        return view
    }
    
    public var safeTopAnchor: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.topAnchor
    }

    public var safeLeadingAnchor: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.leadingAnchor
    }

    public var safeTrailingAnchor: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.trailingAnchor
    }

    public var safeBottomAnchor: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.bottomAnchor
    }
}
