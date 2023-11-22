import UIKit
import SwiftUI

final class ModalViewController: UIViewController {

    private var height: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        if let spc = sheetPresentationController {
            spc.detents = [.custom(resolver: { context in
                self.height
            })]

            spc.preferredCornerRadius = 30
            spc.prefersGrabberVisible = true
        }

        let hostingController = UIHostingController(
            rootView: ContentView(color: .purple) { [weak self] height in

                guard let self else { return }

                self.height = height

                if let spc = sheetPresentationController {
                    spc.animateChanges {
                        spc.invalidateDetents()
                    }

                }
            }
        )

        hostingController.view.backgroundColor = .purple

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
