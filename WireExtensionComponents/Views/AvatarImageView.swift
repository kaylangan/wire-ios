//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import UIKit

/**
 * A view that displays the avatar of a user, either as text initials or as an image.
 */

open class AvatarImageView: UIControl {

    /**
     * The different, mutually-exclusive forms of avatars
     */

    public enum Avatar {
        case image(UIImage)
        case text(String)
    }

    /**
     * The different shapes of avatars.
     */

    public enum Shape {
        case rectangle, circle, relative
    }

    // MARK: - Properties

    /// The avatar to display.
    public internal(set) var avatar: Avatar? {
        didSet {
            updateAvatar()
        }
    }

    /// The shape of the avatar
    public var shape: Shape = .circle {
        didSet {
            updateShape()
        }
    }

    /// The background color for the image.
    public var imageBackgroundColor: UIColor? {
        get { return imageView.backgroundColor }
        set { imageView.backgroundColor = newValue }
    }

    /// The view that contains the avatar.
    public let container = RoundedView()

    private let imageView = UIImageView()
    private let initialsLabel = UILabel()

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
        configureConstraints()
    }

    private func configureSubviews() {
        isOpaque = false
        imageView.isOpaque = false
        imageView.contentMode = .scaleAspectFill

        initialsLabel.textColor = .white
        initialsLabel.font = .systemFont(ofSize: 11, contentSizeCategory: .small, weight: .light)

        container.clipsToBounds = true

        imageView.isAccessibilityElement = false
        initialsLabel.isAccessibilityElement = false

        addSubview(container)
        container.addSubview(imageView)
        container.addSubview(initialsLabel)

        updateAvatar()
        updateShape()
    }

    private func configureConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // containerView
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.widthAnchor.constraint(equalTo: container.heightAnchor),

            // imageView
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            // initials
            initialsLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
    }

    // MARK: - Events

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .touchUpInside)
    }

    // MARK: - Content

    /// Updates the displayed avatar.
    private func updateAvatar() {
        switch avatar {
        case .image(let image)?:
            imageView.image = image
            initialsLabel.text = nil
            imageView.isHidden = false
            initialsLabel.isHidden = true

        case .text(let text)?:
            imageView.image = nil
            initialsLabel.text = text
            imageView.isHidden = true
            initialsLabel.isHidden = false

        case .none:
            imageView.image = nil
            initialsLabel.text = nil
            imageView.isHidden = true
            initialsLabel.isHidden = true
        }
    }

    /// Updates the shape of the displayed avatar.
    private func updateShape() {
        switch shape {
        case .circle:
            container.shape = .circle
        case .rectangle:
            container.shape = .rectangle
        case .relative:
            container.shape = .relative(multiplier: 1/6, dimension: .height)
        }
    }

}
