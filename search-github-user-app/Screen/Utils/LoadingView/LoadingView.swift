//
//  LoadingView.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet weak private var loadingFrameView: UIView!
    @IBOutlet weak private var indicator: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
        setup()
    }

    private func loadNib() {
        let view = Bundle.main.loadNibNamed("LoadingView",
                                            owner: self,
                                            options: nil)?.first as? UIView

        view?.frame = self.bounds
        self.addSubview(view!)
    }

    private func setup() {
        self.backgroundColor = .gray.withAlphaComponent(0.5)
        loadingFrameView.layer.cornerRadius = 18
    }

    func startAnimatingIndicator() {
        indicator.startAnimating()
    }

    func stopAnimatingIndicator() {
        indicator.stopAnimating()
    }
}
