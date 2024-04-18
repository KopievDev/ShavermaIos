// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Assets {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let banner = ImageAsset(name: "Banner")
  internal static let disabledButtonColor = ColorAsset(name: "DisabledButtonColor")
  internal static let disabledTextColor = ColorAsset(name: "DisabledTextColor")
  internal static let _18 = ImageAsset(name: "18+")
  internal static let attach = ImageAsset(name: "Attach")
  internal static let attention1 = ImageAsset(name: "Attention 1")
  internal static let attention = ImageAsset(name: "Attention")
  internal static let backArrow = ImageAsset(name: "Back arrow")
  internal static let back1 = ImageAsset(name: "Back-1")
  internal static let back = ImageAsset(name: "Back")
  internal static let bag = ImageAsset(name: "Bag")
  internal static let box = ImageAsset(name: "Box")
  internal static let calendar = ImageAsset(name: "Calendar")
  internal static let callCenterLock = ImageAsset(name: "Call center lock")
  internal static let cardWithoutMagnetic = ImageAsset(name: "Card without magnetic")
  internal static let cart = ImageAsset(name: "Cart")
  internal static let chat = ImageAsset(name: "Chat")
  internal static let chevroneDown = ImageAsset(name: "Chevrone down")
  internal static let chevroneRight = ImageAsset(name: "Chevrone right")
  internal static let circleAttention = ImageAsset(name: "Circle attention")
  internal static let clearText = ImageAsset(name: "Clear text")
  internal static let clear = ImageAsset(name: "Clear")
  internal static let clock = ImageAsset(name: "Clock")
  internal static let close = ImageAsset(name: "Close")
  internal static let coins = ImageAsset(name: "Coins")
  internal static let comission = ImageAsset(name: "Comission")
  internal static let contactBook = ImageAsset(name: "Contact book")
  internal static let contactsBook = ImageAsset(name: "Contacts book")
  internal static let copy2 = ImageAsset(name: "Copy 2")
  internal static let copy = ImageAsset(name: "Copy")
  internal static let delete = ImageAsset(name: "Delete")
  internal static let delivery = ImageAsset(name: "Delivery")
  internal static let doc = ImageAsset(name: "Doc")
  internal static let document = ImageAsset(name: "Document")
  internal static let done = ImageAsset(name: "Done")
  internal static let dowloadFile = ImageAsset(name: "Dowload file")
  internal static let error = ImageAsset(name: "Error")
  internal static let eyeClosed = ImageAsset(name: "Eye closed")
  internal static let eyeOpen = ImageAsset(name: "Eye open")
  internal static let faceID = ImageAsset(name: "Face ID")
  internal static let faceid = ImageAsset(name: "Faceid")
  internal static let file = ImageAsset(name: "File")
  internal static let flashlight = ImageAsset(name: "Flashlight")
  internal static let forward1 = ImageAsset(name: "Forward 1")
  internal static let forward = ImageAsset(name: "Forward")
  internal static let four = ImageAsset(name: "Four")
  internal static let gift = ImageAsset(name: "Gift")
  internal static let glasses = ImageAsset(name: "Glasses")
  internal static let hasNotification = ImageAsset(name: "Has notification")
  internal static let history = ImageAsset(name: "History")
  internal static let idCard = ImageAsset(name: "ID card")
  internal static let image = ImageAsset(name: "Image")
  internal static let info = ImageAsset(name: "Info")
  internal static let inputText = ImageAsset(name: "Input text")
  internal static let input = ImageAsset(name: "Input")
  internal static let key = ImageAsset(name: "Key")
  internal static let loaderAnimated = ImageAsset(name: "Loader animated")
  internal static let loader = ImageAsset(name: "Loader")
  internal static let lock = ImageAsset(name: "Lock")
  internal static let mail = ImageAsset(name: "Mail")
  internal static let minus = ImageAsset(name: "Minus")
  internal static let moreInfoDots = ImageAsset(name: "More info dots")
  internal static let nfc = ImageAsset(name: "NFC")
  internal static let noneBgPlus = ImageAsset(name: "None bg plus")
  internal static let noneIconBank = ImageAsset(name: "None icon bank")
  internal static let notFilled = ImageAsset(name: "Not filled")
  internal static let notification = ImageAsset(name: "Notification")
  internal static let notifications = ImageAsset(name: "Notifications")
  internal static let ofline = ImageAsset(name: "Ofline")
  internal static let ok = ImageAsset(name: "Ok")
  internal static let one = ImageAsset(name: "One")
  internal static let online = ImageAsset(name: "Online")
  internal static let password = ImageAsset(name: "Password")
  internal static let phoneCheck = ImageAsset(name: "Phone check")
  internal static let phone = ImageAsset(name: "Phone")
  internal static let pinCodeKeyboard = ImageAsset(name: "Pin code keyboard")
  internal static let plasticCard = ImageAsset(name: "Plastic card")
  internal static let plus = ImageAsset(name: "Plus")
  internal static let qrScanning = ImageAsset(name: "QR scanning")
  internal static let question = ImageAsset(name: "Question")
  internal static let ratio = ImageAsset(name: "Ratio")
  internal static let `repeat` = ImageAsset(name: "Repeat")
  internal static let replaceContent = ImageAsset(name: "Replace content")
  internal static let requisitesCard = ImageAsset(name: "Requisites card")
  internal static let rubble1 = ImageAsset(name: "Rubble 1")
  internal static let rubble = ImageAsset(name: "Rubble")
  internal static let search = ImageAsset(name: "Search")
  internal static let sendMessage = ImageAsset(name: "Send message")
  internal static let send = ImageAsset(name: "Send")
  internal static let settings1 = ImageAsset(name: "Settings-1")
  internal static let settings = ImageAsset(name: "Settings")
  internal static let simpleCancel = ImageAsset(name: "Simple cancel")
  internal static let simpleDocument = ImageAsset(name: "Simple document")
  internal static let smartphone = ImageAsset(name: "Smartphone")
  internal static let squarePlus = ImageAsset(name: "Square plus")
  internal static let starFilled = ImageAsset(name: "Star filled")
  internal static let star = ImageAsset(name: "Star")
  internal static let tap = ImageAsset(name: "Tap")
  internal static let thisPhone = ImageAsset(name: "This phone")
  internal static let three = ImageAsset(name: "Three")
  internal static let timer = ImageAsset(name: "Timer")
  internal static let touchID = ImageAsset(name: "Touch ID")
  internal static let two = ImageAsset(name: "Two")
  internal static let unlock = ImageAsset(name: "Unlock")
  internal static let user = ImageAsset(name: "User")
  internal static let walletWithCoins = ImageAsset(name: "Wallet with coins")
  internal static let wallet = ImageAsset(name: "Wallet")
  internal static let wildberries = ImageAsset(name: "Wildberries")
  internal static let mapPin = ImageAsset(name: "mapPin")
  internal static let orangeButtonColor = ColorAsset(name: "OrangeButtonColor")
  internal static let primaryBaseColor = ColorAsset(name: "PrimaryBaseColor")
  internal static let secondaryTextColor = ColorAsset(name: "SecondaryTextColor")
  internal static let staticWhiteColor = ColorAsset(name: "StaticWhiteColor")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
