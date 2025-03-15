//
//  ViewController.swift
//  diplom_3
//
//  Created by Сергей Недведский on 3.03.25.
//

import AVFoundation
import AVKit
import SnapKit
import UIKit

final class AddNewCityViewController: UIViewController {

    var city: CurrentWeather?
    var addedNewCity: ((Bool) -> Void)?
    var name: String?

    var isPlaying = false

    private var array: [List] = []

    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            ListFiveWeatherTableViewCell.self,
            forCellReuseIdentifier: ListFiveWeatherTableViewCell.identifer)
        tableView.rowHeight = Constansts.tableRowHeight
        tableView.estimatedRowHeight = .leastNonzeroMagnitude
        tableView.separatorColor = Constansts.mainColorText

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "default_weather")
        return imageView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = Constansts.mainColorText
        return activityIndicator
    }()

    private let videoActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = Constansts.mainColorText
        return activityIndicator
    }()

    private let nameOfCitylabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constansts.mainColorText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constansts.cityTitleSize)
        return label
    }()

    private let tempOfCitylabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constansts.mainColorText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constansts.titleSize)
        return label
    }()

    private let maxMinOfCitylabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = Constansts.mainColorText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constansts.defaultTextSize)
        return label
    }()

    private let descriptionOfCitylabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constansts.mainColorText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constansts.subTitleSize)
        return label
    }()

    private let pressureOfCitylabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constansts.mainColorText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constansts.defaultTextSize)
        return label
    }()

    private let humidityOfCitylabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constansts.mainColorText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constansts.defaultTextSize)
        return label
    }()

    private let fiveDaysLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constansts.mainColorText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constansts.subTitleSize)
        label.text = Constansts.fiveDays
        return label
    }()

    private let addNewCityButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить город", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        return button
    }()

    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constansts.cityPlaceholder
        textField.borderStyle = .roundedRect
        textField.roundCorners()
        return textField
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.isUserInteractionEnabled = true
        button.roundCorners()
        button.setBackgroundImage(UIImage(named: "back"), for: .normal)
        return button
    }()

    private let secondView: UIView = {
        let view = UIView()
        return view
    }()

    private let tableContainerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.roundCorners()
        return view
    }()

    private let presenter: IAddNewCityPresenter = AddNewCityPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        configueUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cleanupVideoResources()
    }

    private func configueUI() {
        guard let city = city else { return }
        guard let description = city.weather.first??.description else { return }
        view.backgroundColor = Constansts.mainBg

        playVideo(description: description)

        view.addSubview(secondView)
        secondView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        secondView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        secondView.addSubview(nameOfCitylabel)
        nameOfCitylabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constansts.stepTop)
            make.left.equalToSuperview().offset(Constansts.step)
            make.right.equalToSuperview().inset(Constansts.step)
        }
        nameOfCitylabel.text = city.name

        secondView.addSubview(tempOfCitylabel)
        tempOfCitylabel.snp.makeConstraints { make in
            make.top.equalTo(nameOfCitylabel.snp.bottom).offset(
                Constansts.smallStep)
            make.left.equalToSuperview().offset(Constansts.step)
            make.right.equalToSuperview().inset(Constansts.step)
        }
        guard let temp = city.main?.temp else { return }
        tempOfCitylabel.text = String(Int(temp)) + Constansts.degreeSymbol

        secondView.addSubview(maxMinOfCitylabel)
        maxMinOfCitylabel.snp.makeConstraints { make in
            make.top.equalTo(tempOfCitylabel.snp.bottom).offset(
                Constansts.smallStep)
            make.left.equalToSuperview().offset(Constansts.step)
            make.right.equalToSuperview().inset(Constansts.step)
        }
        guard let tempMax = city.main?.temp_max,
            let tempMin = city.main?.temp_min,
            let pressure = city.main?.pressure,
            let humidity = city.main?.humidity,
            let wind = city.wind?.speed
        else { return }
        maxMinOfCitylabel.text =
            "Mакс: " + String(Int(tempMax)) + Constansts.degreeSymbol + " / "
            + "Мин: " + String(Int(tempMin)) + Constansts.degreeSymbol + "\n"
            + "\(String(Int(Double(pressure) / Constansts.pressure))) \(Constansts.pressureString)"
            + "\n" + "\(Constansts.humidityString): \(String(humidity))%" + "\n"
            + "\(Constansts.windString): \(String(Int(wind))) \(Constansts.windSpeedString)"

        secondView.addSubview(descriptionOfCitylabel)
        descriptionOfCitylabel.snp.makeConstraints { make in
            make.top.equalTo(maxMinOfCitylabel.snp.bottom).offset(
                Constansts.smallStep)
            make.left.equalToSuperview().offset(Constansts.step)
            make.right.equalToSuperview().inset(Constansts.step)
        }
        descriptionOfCitylabel.text = description

        secondView.addSubview(fiveDaysLabel)
        fiveDaysLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionOfCitylabel.snp.bottom).offset(
                Constansts.largeStepTop)
            make.left.equalToSuperview().inset(Constansts.step)
            make.right.equalToSuperview().inset(Constansts.step)
        }

        backButton.frame = CGRect(
            x: Constansts.step, y: Constansts.stepTop,
            width: Constansts.btnDefaultSize,
            height: Constansts.btnDefaultSize)
        secondView.addSubview(backButton)

        secondView.addSubview(tableContainerView)

        if addedNewCity != nil {
            tableContainerView.snp.makeConstraints { make in
                make.top.equalTo(fiveDaysLabel.snp.bottom).offset(
                    Constansts.step)
                make.left.equalToSuperview().offset(Constansts.step)
                make.right.equalToSuperview().inset(Constansts.step)
                make.bottom.equalToSuperview().inset(Constansts.stepTop)
            }

            secondView.addSubview(addNewCityButton)
            addNewCityButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(Constansts.step)
                make.left.equalToSuperview().offset(Constansts.step)
                make.right.equalToSuperview().inset(Constansts.step)
                make.height.equalTo(Constansts.textFieldHeight)
            }

            let addNewCityAction = UIAction { _ in
                self.addNewCity()
            }
            addNewCityButton.addAction(addNewCityAction, for: .touchUpInside)

            let backAction = UIAction { _ in
                self.dismiss(animated: true)
            }
            backButton.addAction(backAction, for: .touchUpInside)

        } else {
            tableContainerView.snp.makeConstraints { make in
                make.top.equalTo(fiveDaysLabel.snp.bottom).offset(
                    Constansts.step)
                make.left.equalToSuperview().offset(Constansts.step)
                make.right.equalToSuperview().inset(Constansts.step)
                make.bottom.equalToSuperview().inset(Constansts.step)
            }

            let backAction = UIAction { _ in
                self.navigationController?.popViewController(animated: true)
            }
            backButton.addAction(backAction, for: .touchUpInside)
        }

        let blurEffectSecond = UIBlurEffect(style: Constansts.blurEffect)
        let blurEffectViewSecond = UIVisualEffectView(effect: blurEffectSecond)
        blurEffectViewSecond.autoresizingMask = [
            .flexibleWidth, .flexibleHeight,
        ]
        blurEffectViewSecond.alpha = Constansts.alphaEffect
        tableContainerView.addSubview(blurEffectViewSecond)
        blurEffectViewSecond.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableContainerView.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableContainerView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicator.startAnimating()

        guard let name = city.name else { return }
        presenter.getFiveWeather(from: name) { [weak self] data in
            self?.activityIndicator.stopAnimating()
            if let list = data?.list {
                self?.array = list
                self?.tableView.reloadData()
            } else {
                self?.fiveDaysLabel.text = Constansts.emptyFiveDays
                self?.tableContainerView.removeFromSuperview()
            }
        }

    }

    private func addNewCity() {
        guard let name = city?.name else { return }
        presenter.addNewCity(from: name) { [weak self] added in
            self?.addedNewCity?(added)
        }
    }

    private func cleanupVideoResources() {
        player?.pause()
        player = nil
        playerLayer = nil

        if let layers = view.layer.sublayers {
            for layer in layers {
                if let playerLayer = layer as? AVPlayerLayer {
                    playerLayer.removeFromSuperlayer()
                }
            }
        }

        NotificationCenter.default.removeObserver(self)
        URLCache.shared.removeAllCachedResponses()
    }

    private func playVideo(description: String) {
        presenter.setBackgroundVideo(for: description) { [weak self] url in
            if let self = self {
                if let url = url {
                    self.player = AVPlayer(url: url)
                    self.playerLayer = AVPlayerLayer(player: self.player)
                    self.playerLayer.frame = self.view.bounds
                    self.playerLayer.videoGravity = .resizeAspectFill
                    self.view.layer.addSublayer(self.playerLayer)
                    self.videoActivityIndicator.frame = CGRect(
                        x: self.view.frame.width - Constansts.btnDefaultSize
                            - Constansts.step, y: Constansts.stepTop,
                        width: Constansts.btnDefaultSize,
                        height: Constansts.btnDefaultSize)
                    self.view.addSubview(self.videoActivityIndicator)
                    self.videoActivityIndicator.startAnimating()
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(
                            self.videoDidFinishPlaying(notification:)),
                        name: .AVPlayerItemDidPlayToEndTime,
                        object: self.player.currentItem)

                    NotificationCenter.default.addObserver(
                        self, selector: #selector(playerDidBeginPlaying),
                        name: .AVPlayerItemNewAccessLogEntry,
                        object: self.player.currentItem)

                    self.player.volume = 0
                    self.player.play()
                } else {
                    self.view.addSubview(backgroundImageView)
                    self.backgroundImageView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                }
            }
        }
    }

    @objc func videoDidFinishPlaying(notification: Notification) {
        isPlaying = false
        player.seek(to: .zero)
        player.play()
    }

    @objc func playerDidBeginPlaying(notification: Notification) {
        isPlaying = !isPlaying
        isPlaying
            ? self.videoActivityIndicator.stopAnimating()
            : self.videoActivityIndicator.startAnimating()
    }
}

extension AddNewCityViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        print(array.count)
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListFiveWeatherTableViewCell.identifer,
                for: indexPath)
                as? ListFiveWeatherTableViewCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: array[indexPath.row])

        return cell
    }

    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(
        _ tableView: UITableView, willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        cell.backgroundColor = .clear
    }

}
