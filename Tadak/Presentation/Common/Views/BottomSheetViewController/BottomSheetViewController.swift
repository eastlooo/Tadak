//
//  BottomSheetViewController.swift
//  Tadak
//
//  Created by 정동천 on 2022/10/02.
//

import UIKit
import SnapKit

class BottomSheetViewController: UIViewController {
    
    // MARK: Propeties
    private let defaultHeight: CGFloat
    private let dismissibleHeight: CGFloat
    private let maxDimmedAlpha: CGFloat
    private var currentContainerHeight: CGFloat
    
    lazy var holderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer()
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        panGesture.addTarget(self, action: #selector(handlePanGesture))
        return panGesture
    }()
    
    // MARK: Lifecycle
    init(
        containerHeight: CGFloat,
        dismissibleHeight: CGFloat,
        maxDimmedAlpha: CGFloat
    ) {
        self.defaultHeight = containerHeight
        self.dismissibleHeight = dismissibleHeight
        self.maxDimmedAlpha = maxDimmedAlpha
        self.currentContainerHeight = containerHeight
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowContainer()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag {
            updateContainerHeight(-defaultHeight, animated: flag) {
                super.dismiss(animated: flag, completion: completion)
            }
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    // MARK: Actions
    @objc
    private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            guard newHeight < defaultHeight else { return }
            updateContainerHeight(newHeight, animated: false)
            
        case .ended:
            if newHeight < dismissibleHeight {
                self.dismiss(animated: true)
            } else {
                updateContainerHeight(defaultHeight, animated: true)
                self.currentContainerHeight = defaultHeight
            }

        default:
            break
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        holderView.addGestureRecognizer(panGesture)
    }
    
    private func layout() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.layer.cornerRadius = 45
        containerView.layer.cornerCurve = .continuous
        containerView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(defaultHeight)
            $0.bottom.equalToSuperview().offset(defaultHeight)
        }
        
        containerView.addSubview(holderView)
        holderView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.greaterThanOrEqualTo(0)
        }
    }
}

// MARK: Animations
private extension BottomSheetViewController {
    
    func updateContainerHeight(_ height: CGFloat,
                               animated: Bool,
                               completion: (() -> Void)? = nil) {
        let alpha = height / defaultHeight * maxDimmedAlpha
        let offset = defaultHeight - height
        
        if animated {
            UIView.animate(withDuration: 0.4) {
                self.dimmedView.alpha = alpha
                self.containerView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(offset)
                }
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                completion?()
            }
        } else {
            self.dimmedView.alpha = alpha
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(offset)
            }
            self.view.layoutIfNeeded()
            completion?()
        }
    }
    
    func animateShowContainer() {
        updateContainerHeight(defaultHeight, animated: true)
    }
}
