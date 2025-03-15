//
//  ListTableViewCell.swift
//  diplom_1
//
//  Created by Сергей Недведский on 19.01.25.
//

import Kingfisher
import SnapKit
import UIKit

class ListTableViewCell: UITableViewCell {

    static var identifer: String { "\(Self.self)" }

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = Constansts.mainColorText
        return activityIndicator
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constansts.mainColorText
        return label
    }()

    private let tempOfCitylabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constansts.mainColorText
        label.textAlignment = .center
        return label
    }()

    private let weatherImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.roundCorners()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        tempOfCitylabel.text = nil
        weatherImageView.image = nil
    }

    private func configureUI() {

        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constansts.step)
            make.left.equalToSuperview().offset(Constansts.step)
            make.bottom.equalToSuperview().offset(-Constansts.step)
        }
        
        contentView.addSubview(tempOfCitylabel)
        tempOfCitylabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constansts.step)
            make.left.equalTo(nameLabel.snp.right).offset(Constansts.step)
            make.bottom.equalToSuperview().offset(-Constansts.step)
            make.width.height.equalTo(nameLabel)
        }
        
        contentView.addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constansts.step)
            make.left.equalTo(tempOfCitylabel.snp.right).offset(Constansts.step)
            make.bottom.equalToSuperview().offset(-Constansts.step)
            make.right.equalToSuperview().offset(-Constansts.step)
            make.width.height.equalTo(nameLabel)
        }

        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(weather: CurrentWeather) {
        nameLabel.text = weather.name
        guard let temp = weather.main?.temp else { return }
        tempOfCitylabel.text = String(Int(temp)) + Constansts.degreeSymbol
        guard let iconName = weather.weather.first??.icon else { return }
        let url = URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png")
        let processor = DownsamplingImageProcessor(size: weatherImageView.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: Constansts.cornerRadius)
        weatherImageView.kf.indicatorType = .activity
        weatherImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])

    }

    func playAnimate() {
        activityIndicator.startAnimating()
    }

    func stopAnimate() {
        activityIndicator.stopAnimating()
    }
}
