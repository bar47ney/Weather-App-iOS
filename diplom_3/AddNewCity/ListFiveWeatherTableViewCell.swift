//
//  ListTableViewCell.swift
//  diplom_1
//
//  Created by Сергей Недведский on 19.01.25.
//

import Kingfisher
import SnapKit
import UIKit

final class ListFiveWeatherTableViewCell: UITableViewCell {

    static var identifer: String { "\(Self.self)" }

    private let timeLabel: UILabel = {
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
        timeLabel.text = nil
        tempOfCitylabel.text = nil
        weatherImageView.image = nil
    }

    private func configureUI() {
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constansts.step)
            make.left.equalToSuperview().offset(Constansts.step)
            make.bottom.equalToSuperview().offset(-Constansts.step)
        }
        
        contentView.addSubview(tempOfCitylabel)
        tempOfCitylabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constansts.step)
            make.left.equalTo(timeLabel.snp.right).offset(Constansts.step)
            make.bottom.equalToSuperview().offset(-Constansts.step)
            make.width.height.equalTo(timeLabel)
        }
        
        contentView.addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constansts.step)
            make.left.equalTo(tempOfCitylabel.snp.right).offset(Constansts.step)
            make.bottom.equalToSuperview().offset(-Constansts.step)
            make.right.equalToSuperview().offset(-Constansts.step)
            make.width.height.equalTo(timeLabel)
        }
    }

    func configure(with day: List) {
        let formatter = DateFormatter()
        formatter.dateFormat = Constansts.timeFormatFrom
        guard let date = formatter.date(from: day.dt_txt) else { return }
        formatter.dateFormat = Constansts.timeFormatTo
        let stringDate = formatter.string(from: date)
        timeLabel.text = "\(stringDate)h"
        
        tempOfCitylabel.text = String(Int(day.main.temp)) + Constansts.degreeSymbol
        
        guard let icon = day.weather.first?.icon else { return }
        let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
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
}
