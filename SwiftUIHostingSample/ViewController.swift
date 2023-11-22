import SwiftUI
import UIKit

final class ViewController: UIViewController {

    private let allSwiftUIViewController = AllSwiftUIViewController()
    private let embeddingViewController = EmbeddingViewController()
    private var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // スタックビューを初期化
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

        // AllSwiftUIViewControllerをスタックビューに追加
        add(asChildViewController: allSwiftUIViewController, to: stackView)

        // EmbeddingViewControllerをスタックビューに追加
        add(asChildViewController: embeddingViewController, to: stackView)

        let vStack: UIStackView = {
            let vStack = UIStackView()
            vStack.axis = .vertical
            vStack.distribution = .fill
            vStack.alignment = .fill
            vStack.spacing = 0
            return vStack
        }()

        let presentModalButton = UIButton(type: .system)
        presentModalButton.setTitle("Present Modal", for: .normal)
        presentModalButton.addTarget(self, action: #selector(presentModalViewController), for: .touchUpInside)

        [presentModalButton, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            vStack.addArrangedSubview($0)
        }

        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)

        // スタックビューのレイアウト制約を設定
        NSLayoutConstraint.activate([
            presentModalButton.heightAnchor.constraint(equalToConstant: 60),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc func presentModalViewController() {
        let modalViewController = ModalViewController()
        present(modalViewController, animated: true, completion: nil)
    }

    private func add(asChildViewController viewController: UIViewController, to stackView: UIStackView) {
        // 子ViewControllerを追加
        addChild(viewController)
        stackView.addArrangedSubview(viewController.view)
        viewController.didMove(toParent: self)

        // Auto Layoutの制約を子ビューに追加
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
}

final class AllSwiftUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow

        let swiftUIView = VStack(spacing: 0) {
            Color.yellow.frame(maxHeight: .infinity)
            ContentView { _ in}
        }

        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

final class EmbeddingViewController: UIViewController {

    private var hostingController: UIHostingController<ContentView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 縦向きのスタックビューを作成
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // スタックビューの制約を設定
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(yellowView)

        let swiftUIView = ContentView { height in
            self.hostingController?.view.invalidateIntrinsicContentSize()
        }
        let hostingController = UIHostingController(rootView: swiftUIView)
        self.hostingController = hostingController

        addChild(hostingController)
        stackView.addArrangedSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // UIHostingControllerのビューの制約を設定
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    }
}
