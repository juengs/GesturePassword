//
//  SetPasswordController.swift
//  GesturePassword
//
//  Created by 黄伯驹 on 2018/4/21.
//  Copyright © 2018 xiAo_Ju. All rights reserved.
//

public final class SetPatternController: UIViewController {

    private let contentView = UIView()

    private let lockInfoView = LockInfoView()
    private let lockDescLabel = LockDescLabel()
    let lockMainView = LockView()
    
    var firstPassword: String?

    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.widthToSuperview().centerY(to: view, constant: 32)

        initBarButtons()
        initUI()
    }
    
    private func initBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel".localized, style: .plain, target: self, action: #selector(cancelAction))
    }
    
    private func showRedrawBarButton() {
        if firstPassword == nil { return }
        let redraw = UIBarButtonItem(title: "redraw".localized, style: .plain, target: self, action: #selector(redrawAction))
        navigationItem.rightBarButtonItem = redraw
    }

    private func hiddenRedrawBarButton() {
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc
    private func cancelAction() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func redrawAction() {
        hiddenRedrawBarButton()

        lockDescLabel.showNormal(with: "setPasswordTitle".localized)
        lockInfoView.reset()
        lockMainView.reset()
    }

    private func initUI() {
        contentView.addSubview(lockInfoView)
        contentView.addSubview(lockDescLabel)
        contentView.addSubview(lockMainView)

        lockInfoView.topToSuperview()
            .centerXToSuperview()
            .width(to: contentView, multiplier: 1 / 8)
            .height(to: lockInfoView, attribute: .width)

        lockDescLabel.top(to: lockInfoView,
                          attribute: .bottom,
                          constant: 30).centerXToSuperview()
        lockDescLabel.showNormal(with: "setPasswordTitle".localized)

        lockMainView.delegate = self
        lockMainView.top(to: lockDescLabel,
                         attribute: .bottom,
                         constant: 30)
            .centerXToSuperview()
            .bottomToSuperview()
            .height(to: lockMainView, attribute: .width)
    }
}

extension SetPatternController: LockViewDelegate {
    public func lockViewDidTouchesEnd(_ lockView: LockView) {
        LockMediator.setPattern(with: self)
    }
}

extension SetPatternController: SetPatternDelegate {

    func firstDrawedState() {
        lockInfoView.showSelectedItems(lockMainView.password)
        lockDescLabel.showNormal(with: "setPasswordAgainTitle".localized)
    }

    func tooShortState() {
        showRedrawBarButton()
        lockDescLabel.showWarn(with: "setPasswordTooShortTitle".localized)
    }

    func mismatchState() {
        showRedrawBarButton()
        lockDescLabel.showWarn(with: "setPasswordMismatchTitle".localized)
    }

    func successState() {
        cancelAction()
    }
}
