//
//  CardScanViewController.swift
//  CreditCardValidator
//
//  Created by ablai erzhanov on 25.04.2022.
//

import AVFoundation
import CoreImage
import UIKit
import Vision

@available(iOS 13.0, *)
internal class CardScanner: UIViewController {
    // MARK: - Private Properties
    private let captureSession = AVCaptureSession()
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: self.captureSession)
        preview.videoGravity = .resizeAspect
        return preview
    }()

    private let device = AVCaptureDevice.default(for: .video)

    private var viewGuide: PartialTransparentView!

    private var creditCardNumber: String?

    private let videoOutput = AVCaptureVideoDataOutput()

    // MARK: - Public Properties
    public var closeButton = IokaButton(imageName: "Close", tintColor: .white)
    public var confirmButton = IokaButton(state: .enabled, title: IokaLocalizable.everythingRight, backgroundColor: colors.primary)
    public var cardScanExplainedLabel = IokaLabel(title: IokaLocalizable.cardScanExplained, iokaFont: typography.subtitleSemiBold, iokaTextColor: colors.nonadaptableText, iokaTextAlignemnt: .center)
    public var cardScanImageView = IokaImageView(imageName: "CardScanExplained")
    public var checkCardNumberLabel = IokaLabel(title: IokaLocalizable.checkCardNymber, iokaFont: typography.subtitleSemiBold, iokaTextColor: colors.nonadaptableText, iokaTextAlignemnt: .center)
    public var cardNumberLabel = IokaLabel(iokaFont: typography.heading, iokaTextColor: colors.nonadaptableText, iokaTextAlignemnt: .center)
    public var scanAgainButton = IokaButton(title: IokaLocalizable.scanAgain, backgroundColor: .clear)

    // MARK: - Instance dependencies
    private var resultsHandler: (_ number: String?) -> Void?

    // MARK: - Initializers
    init(resultsHandler: @escaping (_ number: String?) -> Void) {
        self.resultsHandler = resultsHandler
        super.init(nibName: nil, bundle: nil)
    }

    public class func getScanner(resultsHandler: @escaping (_ number: String?) -> Void) -> UIViewController {
        let viewScanner = CardScanner(resultsHandler: resultsHandler)
        viewScanner.modalPresentationStyle = .overFullScreen
        return viewScanner
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        view = UIView()
    }

    deinit {
        stop()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        captureSession.startRunning()

        let buttomItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(scanCompleted))
        buttomItem.tintColor = .white
        navigationItem.leftBarButtonItem = buttomItem
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }

    // MARK: - Add Views
    private func setupCaptureSession() {
        addCameraInput()
        addPreviewLayer()
        addVideoOutput()
        addGuideView()
    }

    private func addCameraInput() {
        guard let device = device else { return }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
    }

    private func addPreviewLayer() {
        view.layer.addSublayer(previewLayer)
    }

    private func addVideoOutput() {
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as NSString: NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "my.image.handling.queue"))
        captureSession.addOutput(videoOutput)
        guard let connection = videoOutput.connection(with: AVMediaType.video),
            connection.isVideoOrientationSupported else {
            return
        }
        connection.videoOrientation = .portrait
    }

    private func addGuideView() {
        let widht = UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.2)
        let height = widht - (widht * 0.45)
        let viewX = (UIScreen.main.bounds.width / 2) - (widht / 2)
        let viewY = (UIScreen.main.bounds.height / 2) - (height / 2) - 100

        viewGuide = PartialTransparentView(rectsArray: [CGRect(x: viewX, y: viewY, width: widht, height: height)])


        [closeButton,viewGuide, cardScanImageView, cardScanExplainedLabel, checkCardNumberLabel, cardNumberLabel, confirmButton, scanAgainButton].forEach { self.view.addSubview($0) }


        viewGuide.fillView(self.view)
        view.bringSubviewToFront(viewGuide)
        cardScanExplainedLabel.anchor(left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 85, paddingBottom: 74, paddingRight: 85)
        cardScanImageView.centerX(in: self.view, bottom: cardScanExplainedLabel.topAnchor, paddingBottom: 20, width: 80, height: 80)
        checkCardNumberLabel.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 180, paddingLeft: 30, paddingRight: 30)
        cardNumberLabel.anchor(top: self.checkCardNumberLabel.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 4, paddingLeft: 30, paddingRight: 30)
        confirmButton.anchor(left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingLeft: 16, paddingBottom: 74, paddingRight: 16, height: 56)
        scanAgainButton.anchor(left: self.view.leftAnchor, bottom: confirmButton.topAnchor, right: self.view.rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: 56)
        closeButton.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, paddingTop: 72, paddingLeft: 0, width: 56, height: 56)

        [confirmButton, scanAgainButton, cardNumberLabel, closeButton, cardScanExplainedLabel, cardScanImageView, checkCardNumberLabel].forEach { view.bringSubviewToFront($0) }


        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        [confirmButton, scanAgainButton, cardNumberLabel, checkCardNumberLabel].forEach { $0.isHidden = true }

        confirmButton.addTarget(self, action: #selector(scanCompleted), for: .touchUpInside)
        scanAgainButton.addTarget(self, action: #selector(clearCardData), for: .touchUpInside)

        view.backgroundColor = .black
    }

    @objc private func clearCardData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.handleScanResultViews(isShow: false)
            self.creditCardNumber = nil
            self.viewGuide.removeBorderForRect()
        }
    }

    // MARK: - Completed process
    @objc func scanCompleted() {
        resultsHandler(creditCardNumber)
        stop()
        dismiss()
    }

    @objc func handleDismiss() {
        dismiss()
    }

    private func handleScanResultViews(isShow: Bool) {
        [confirmButton, scanAgainButton, cardNumberLabel, checkCardNumberLabel].forEach { $0.isHidden = !isShow }
        [cardScanExplainedLabel, cardScanImageView].forEach { $0.isHidden = isShow }
    }

    private func stop() {
        captureSession.stopRunning()
    }

    private func dismiss() {
        dismiss(animated: true)
    }

    // MARK: - Payment detection
    private func handleObservedPaymentCard(in frame: CVImageBuffer) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.extractPaymentCardData(frame: frame)
        }
    }

    private func extractPaymentCardData(frame: CVImageBuffer) {
        let ciImage = CIImage(cvImageBuffer: frame)
        let widht = UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.2)
        let height = widht - (widht * 0.45)
        let viewX = (UIScreen.main.bounds.width / 2) - (widht / 2)
        let viewY = (UIScreen.main.bounds.height / 2) - (height / 2) - 100 + height

        let resizeFilter = CIFilter(name: "CILanczosScaleTransform")!

        // Desired output size
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        // Compute scale and corrective aspect ratio
        let scale = targetSize.height / ciImage.extent.height
        let aspectRatio = targetSize.width / (ciImage.extent.width * scale)

        // Apply resizing
        resizeFilter.setValue(ciImage, forKey: kCIInputImageKey)
        resizeFilter.setValue(scale, forKey: kCIInputScaleKey)
        resizeFilter.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        let outputImage = resizeFilter.outputImage

        let croppedImage = outputImage!.cropped(to: CGRect(x: viewX, y: viewY, width: widht, height: height))

        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false

        let stillImageRequestHandler = VNImageRequestHandler(ciImage: croppedImage, options: [:])
        try? stillImageRequestHandler.perform([request])

        guard let texts = request.results, texts.count > 0 else {
            // no text detected
            return
        }

        let arrayLines = texts.flatMap({ $0.topCandidates(20).map({ $0.string }) })

        for line in arrayLines {

            let trimmed = line.replacingOccurrences(of: " ", with: "")

            if creditCardNumber == nil &&
                trimmed.count >= 15 &&
                trimmed.count <= 16 &&
                trimmed.isOnlyNumbers {
                creditCardNumber = line
                DispatchQueue.main.async {
                    self.cardNumberLabel.text = line
                    self.handleScanResultViews(isShow: true)
                    self.viewGuide.createBorderForRect()
                    self.tapticFeedback()
                }
                continue
            }
        }
    }

    private func tapticFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
@available(iOS 13.0, *)
extension CardScanner: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }

        handleObservedPaymentCard(in: frame)
    }
}

// MARK: - Extensions
private extension String {
    var isOnlyNumbers: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
}
