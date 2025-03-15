//
//  ExampleViewController.swift
//  lesson_26
//
//  Created by Сергей Недведский on 23.01.25.
//

import SnapKit
import UIKit

class WeatherViewController: UIViewController {
    private var array = StorageManagaer.shared.loadCities()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            ListTableViewCell.self,
            forCellReuseIdentifier: ListTableViewCell.identifer)
        tableView.rowHeight = Constansts.tableRowHeight
        tableView.estimatedRowHeight = .leastNonzeroMagnitude
        tableView.separatorColor = Constansts.mainColorText

        tableView.delegate = self
        tableView.dataSource = self

        tableView.layer.masksToBounds = true
        tableView.roundCorners()

        return tableView
    }()

    private let mainTitlelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constansts.mainColorText
        label.textAlignment = .left
        label.font = UIFont.systemFont(
            ofSize: Constansts.titleSize, weight: .bold)
        label.text = Constansts.mainTitle
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = Constansts.mainColorText
        return activityIndicator
    }()

    private let nameOfCitylabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()

    private let emptylabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constansts.mainColorText
        label.text = Constansts.emptyCities
        label.textAlignment = .center
        return label
    }()

    private let addNewCityButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constansts.cityPlaceholder
        textField.borderStyle = .roundedRect
        textField.roundCorners()
        return textField
    }()

    private let secondView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let thirdView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let textFiledView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let tableContainerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.roundCorners()
        return view
    }()

    private let presenter: IWeatherPresenter = WeatherPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        configueUI()
        registerNotification()
    }

    private func configueUI() {
        thirdView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(thirdView)
        checkTimeForView()
        
        self.cityTextField.delegate = self
        
        view.addSubview(secondView)
        secondView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        secondView.addSubview(mainTitlelabel)
        mainTitlelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constansts.stepTop)
            make.left.equalToSuperview().offset(Constansts.step)
            make.right.equalToSuperview().inset(Constansts.step)
            make.height.equalTo(Constansts.textFieldHeight)
        }

        secondView.addSubview(cityTextField)
        cityTextField.snp.makeConstraints { make in
            make.top.equalTo(mainTitlelabel.snp.bottom).offset(Constansts.step)
            make.left.equalToSuperview().offset(Constansts.step)
            make.right.equalToSuperview().inset(Constansts.step)
            make.height.equalTo(Constansts.textFieldHeight)
        }

        secondView.addSubview(tableContainerView)
        tableContainerView.backgroundColor = .clear
        tableContainerView.snp.makeConstraints { make in
            make.top.equalTo(cityTextField.snp.bottom).offset(Constansts.step)
            make.left.equalToSuperview().inset(Constansts.step)
            make.right.equalToSuperview().inset(Constansts.step)
            make.bottom.equalToSuperview().inset(Constansts.step)
        }

        let blurEffectSecond = UIBlurEffect(style: Constansts.blurEffect)
        let blurEffectViewSecond = UIVisualEffectView(effect: blurEffectSecond)
        blurEffectViewSecond.autoresizingMask = [
            .flexibleWidth, .flexibleHeight,
        ]
        blurEffectViewSecond.alpha = Constansts.alphaEffect;
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
            make.edges.equalToSuperview()
        }

        let addNewCityAction = UIAction { _ in
            self.addNewCity()
        }
        addNewCityButton.addAction(addNewCityAction, for: .touchUpInside)
    }

    @objc func willEnterForeground() {
        tableView.reloadData()
        checkTimeForView()
    }

    private func addNewCity() {
        print("new")
    }

    @objc func tapDetected() {
        view.endEditing(true)
    }

    private func checkTimeForView(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = Constansts.timeFormatToView
        guard let hours = Int(formatter.string(from: date)) else { return }
        if(hours > Constansts.checkThemeTimeFrom || hours < Constansts.checkThemeTimeTo){
            thirdView.image = UIImage(named: "night")
        } else{
            thirdView.image = UIImage(named: "day")
        }
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardChangedFrame(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardChangedFrame(_:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func keyboardChangedFrame(_ notification: Notification) {
        let tapDetected = UITapGestureRecognizer(
            target: self, action: #selector(tapDetected))
        if notification.name == UIResponder.keyboardWillHideNotification {
            textFiledView.removeGestureRecognizer(tapDetected)
            textFiledView.removeFromSuperview()
        } else if notification.name == UIResponder.keyboardWillShowNotification
        {
            view.addSubview(textFiledView)
            textFiledView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            textFiledView.addGestureRecognizer(tapDetected)
        }
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = textField.text {
            if !name.isEmpty {
                activityIndicator.startAnimating()
                presenter.getCurrentWeather(from: name) {
                    [weak self] weather, code in
                    self?.activityIndicator.stopAnimating()
                    if let weather = weather {
                        let controller = AddNewCityViewController()
                        controller.city = weather
                        controller.addedNewCity = { [weak self] added in
                            if added {
                                self?.array = StorageManagaer.shared
                                    .loadCities()
                                self?.tableView.reloadData()
                                self?.dismiss(animated: true)
                            } else {
                                self?.dismiss(animated: true)
                                self?.tableView.reloadData()
                                self?.showAlert(
                                    title: "Внимание!",
                                    message: "Город уже есть")
                            }
                        }
                        self?.present(controller, animated: true)
                    } else {
                        if code == 404 {
                            self?.showAlert(
                                title: Constansts.error,
                                message: Constansts.cityError,
                                type: .alert
                            )
                        } else {
                            self?.showAlert(
                                title: Constansts.error,
                                message: Constansts.networkError,
                                type: .alert
                            )
                        }
                    }
                }
            }
        }
        textField.resignFirstResponder()
        return true
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        if array.count == 0 {
            tableContainerView.addSubview(emptylabel)
            emptylabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            emptylabel.removeFromSuperview()
        }
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListTableViewCell.identifer, for: indexPath)
                as? ListTableViewCell
        else {
            return UITableViewCell()
        }

        cell.playAnimate()
        presenter.getCurrentWeather(from: array[indexPath.row].name) {
            [weak self] weather, code in
            cell.stopAnimate()
            if let weather = weather {
                cell.configure(weather: weather)
            } else {
                self?.showAlert(
                    title: Constansts.error,
                    message: Constansts.networkError,
                    type: .alert,
                    handlerOK: { _ in
                        tableView.reloadData()
                    },
                    cancelBtn: true,
                    handlerCancel: { _ in
                        if let url = URL(string: "App-Prefs:root=WIFI") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(
                                    url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                )

            }

        }

        return cell
    }

    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
        cell.playAnimate()
        let controller = AddNewCityViewController()
        presenter.getCurrentWeather(from: array[indexPath.row].name) {
            [weak self] weather, code in
            cell.stopAnimate()
            if let weather = weather {
                controller.city = weather
                self?.navigationController?.pushViewController(
                    controller, animated: true)
            } else {
                self?.showAlert(
                    title: Constansts.error,
                    message: Constansts.networkError,
                    type: .alert,
                    handlerOK: { _ in
                        tableView.reloadData()
                    },
                    cancelBtn: true,
                    handlerCancel: { _ in
                        if let url = URL(string: "App-Prefs:root=WIFI") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(
                                    url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                )

            }

        }
    }

    func tableView(
        _ tableView: UITableView, willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        cell.backgroundColor = .clear
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive, title: "Удалить"
        ) { (action, view, completionHandler) in
            self.presenter.deleteCity(city: self.array[indexPath.row]) {
                [weak self] array in
                self?.array = array
                self?.tableView.reloadData()
            }
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
