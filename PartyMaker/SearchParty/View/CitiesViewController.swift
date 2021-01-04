//
//  CitiesTableViewController.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.01.2021.
//

import UIKit

class CitiesViewController: UIViewController {
    
    let tableView = UITableView()
    
    let searchBar = UISearchBar()
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var cities: [String] = ["Абакан", "Азов", "Александров", "Алексин", "Альметьевск", "Анапа", "Ангарск", "Анжеро-Судженск", "Апатиты", "Арзамас", "Армавир", "Арсеньев", "Артем", "Архангельск", "Асбест", "Астрахань", "Ачинск", "Балаково", "Балахна", "Балашиха", "Балашов", "Барнаул", "Батайск", "Белгород", "Белебей", "Белово", "Белогорск (Амурская область)", "Белорецк", "Белореченск", "Бердск", "Березники", "Березовский (Свердловская область)", "Бийск", "Биробиджан", "Благовещенск (Амурская область)", "Бор", "Борисоглебск", "Боровичи", "Братск", "Брянск", "Бугульма", "Буденновск", "Бузулук", "Буйнакск", "Великие Луки", "Великий Новгород", "Верхняя Пышма", "Видное", "Владивосток", "Владикавказ", "Владимир", "Волгоград", "Волгодонск",
                                    "Волжск",
                                    "Волжский",
                                    "Вологда",
                                    "Вольск",
                                    "Воркута",
                                    "Воронеж",
                                    "Воскресенск",
                                    "Воткинск",
                                    "Всеволожск",
                                    "Выборг",
                                    "Выкса",
                                    "Вязьма",
                                    "Гатчина",
                                    "Геленджик",
                                    "Георгиевск",
                                    "Глазов",
                                    "Горно-Алтайск",
                                    "Грозный",
                                    "Губкин",
                                    "Гудермес",
                                    "Гуково",
                                    "Гусь-Хрустальный",
                                    "Дербент",
                                    "Дзержинск",
                                    "Димитровград",
                                    "Дмитров",
                                    "Долгопрудный",
                                    "Домодедово",
                                    "Донской",
                                    "Дубна",
                                    "Евпатория",
                                    "Егорьевск",
                                    "Ейск",
                                    "Екатеринбург",
                                    "Елабуга",
                                    "Елец",
                                    "Ессентуки",
                                    "Железногорск (Красноярский край)",
                                    "Железногорск (Курская область)",
                                    "Жигулевск",
                                    "Жуковский",
                                    "Заречный",
                                    "Зеленогорск",
                                    "Зеленодольск",
                                    "Златоуст",
                                    "Иваново",
                                    "Ивантеевка",
                                    "Ижевск",
                                    "Избербаш",
                                    "Иркутск",
                                    "Искитим",
                                    "Ишим",
                                    "Ишимбай",
                                    "Йошкар-Ола",
                                    "Казань",
                                    "Калининград",
                                    "Калуга",
                                    "Каменск-Уральский",
                                    "Каменск-Шахтинский",
                                    "Камышин",
                                    "Канск",
                                    "Каспийск",
                                    "Кемерово",
                                    "Керчь",
                                    "Кинешма",
                                    "Кириши",
                                    "Киров (Кировская область)",
                                    "Кирово-Чепецк",
                                    "Киселевск",
                                    "Кисловодск",
                                    "Клин",
                                    "Клинцы",
                                    "Ковров",
                                    "Когалым",
                                    "Коломна",
                                    "Комсомольск-на-Амуре",
                                    "Копейск",
                                    "Королев",
                                    "Кострома",
                                    "Котлас",
                                    "Красногорск",
                                    "Краснодар",
                                    "Краснокаменск",
                                    "Краснокамск",
                                    "Краснотурьинск",
                                    "Красноярск",
                                    "Кропоткин",
                                    "Крымск",
                                    "Кстово",
                                    "Кузнецк",
                                    "Кумертау",
                                    "Кунгур",
                                    "Курган",
                                    "Курск",
                                    "Кызыл",
                                    "Лабинск",
                                    "Лениногорск",
                                    "Ленинск-Кузнецкий",
                                    "Лесосибирск",
                                    "Липецк",
                                    "Лиски",
                                    "Лобня",
                                    "Лысьва",
                                    "Лыткарино",
                                    "Люберцы",
                                    "Магадан",
                                    "Магнитогорск",
                                    "Майкоп",
                                    "Махачкала",
                                    "Междуреченск",
                                    "Мелеуз",
                                    "Миасс",
                                    "Минеральные Воды",
                                    "Минусинск",
                                    "Михайловка",
                                    "Михайловск (Ставропольский край)",
                                    "Мичуринск",
                                    "Москва",
                                    "Мурманск",
                                    "Муром",
                                    "Мытищи",
                                    "Набережные Челны",
                                    "Назарово",
                                    "Назрань",
                                    "Нальчик",
                                    "Наро-Фоминск",
                                    "Находка",
                                    "Невинномысск",
                                    "Нерюнгри",
                                    "Нефтекамск",
                                    "Нефтеюганск",
                                    "Нижневартовск",
                                    "Нижнекамск",
                                    "Нижний Новгород",
                                    "Нижний Тагил",
                                    "Новоалтайск",
                                    "Новокузнецк",
                                    "Новокуйбышевск",
                                    "Новомосковск",
                                    "Новороссийск",
                                    "Новосибирск",
                                    "Новотроицк",
                                    "Новоуральск",
                                    "Новочебоксарск",
                                    "Новочеркасск",
                                    "Новошахтинск",
                                    "Новый Уренгой",
                                    "Ногинск",
                                    "Норильск",
                                    "Ноябрьск",
                                    "Нягань",
                                    "Обнинск",
                                    "Одинцово",
                                    "Озерск (Челябинская область)",
                                    "Октябрьский",
                                    "Омск",
                                    "Орел",
                                    "Оренбург",
                                    "Орехово-Зуево",
                                    "Орск",
                                    "Павлово",
                                    "Павловский Посад",
                                    "Пенза",
                                    "Первоуральск",
                                    "Пермь",
                                    "Петрозаводск",
                                    "Петропавловск-Камчатский",
                                    "Подольск",
                                    "Полевской",
                                    "Прокопьевск", "Прохладный",
                                    "Псков",
                                    "Пушкино",
                                    "Пятигорск",
                                    "Раменское",
                                    "Ревда",
                                    "Реутов",
                                    "Ржев",
                                    "Рославль",
                                    "Россошь",
                                    "Ростов-на-Дону",
                                    "Рубцовск",
                                    "Рыбинск",
                                    "Рязань",
                                    "Салават",
                                    "Сальск",
                                    "Самара",
                                    "Санкт-Петербург",
                                    "Саранск",
                                    "Сарапул",
                                    "Саратов",
                                    "Саров",
                                    "Свободный",
                                    "Севастополь",
                                    "Северодвинск",
                                    "Северск",
                                    "Сергиев Посад",
                                    "Серов",
                                    "Серпухов",
                                    "Сертолово",
                                    "Сибай",
                                    "Симферополь",
                                    "Славянск-на-Кубани",
                                    "Смоленск",
                                    "Соликамск",
                                    "Солнечногорск",
                                    "Сосновый Бор",
                                    "Сочи",
                                    "Ставрополь",
                                    "Старый Оскол",
                                    "Стерлитамак",
                                    "Ступино",
                                    "Сургут",
                                    "Сызрань",
                                    "Сыктывкар",
                                    "Таганрог",
                                    "Тамбов",
                                    "Тверь",
                                    "Тимашевск",
                                    "Тихвин",
                                    "Тихорецк",
                                    "Тобольск",
                                    "Тольятти",
                                    "Томск",
                                    "Троицк",
                                    "Туапсе",
                                    "Туймазы",
                                    "Тула",
                                    "Тюмень",
                                    "Узловая",
                                    "Улан-Удэ",
                                    "Ульяновск",
                                    "Урус-Мартан",
                                    "Усолье-Сибирское",
                                    "Уссурийск",
                                    "Усть-Илимск",
                                    "Уфа",
                                    "Ухта",
                                    "Феодосия",
                                    "Фрязино",
                                    "Хабаровск",
                                    "Ханты-Мансийск",
                                    "Хасавюрт",
                                    "Химки",
                                    "Чайковский",
                                    "Чапаевск",
                                    "Чебоксары",
                                    "Челябинск",
                                    "Черемхово",
                                    "Череповец",
                                    "Черкесск",
                                    "Черногорск",
                                    "Чехов",
                                    "Чистополь",
                                    "Чита",
                                    "Шадринск",
                                    "Шали",
                                    "Шахты",
                                    "Шуя",
                                    "Щекино",
                                    "Щелково",
                                    "Электросталь",
                                    "Элиста",
                                    "Энгельс",
                                    "Южно-Сахалинск",
                                    "Юрга",
                                    "Якутск",
                                    "Ялта",
                                    "Ярославль"]
    
    private var filteredCities: [String] = []
    
    private var isFiltering: Bool {
        return !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.tintColor = UIColor.white
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 20
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.placeholder = "Поиск города"
        searchBar.layer.cornerRadius = 20
        searchBar.clipsToBounds = true
        searchBar.delegate = self
//        searchBar.keyboardAppearance = .dark
        
        definesPresentationContext = true // Позволяет отпустить строку поиска, при переходе на другой экран
    
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        self.view.addSubview(blurredEffectView)
        
        let stackView = UIStackView(arrangedSubviews: [searchBar, tableView], axis: .vertical, spacing: 8)
        
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -128)
        ])
        
        moveIn()
    }
    
    private func moveIn() {
        
        // Вроде костыль, но помогает
        navigationController?.navigationBar.isHidden = true
        
        self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.24) {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1.0
        }
    }
    
    private func moveOut() {
        
        // Вроде костыль, но помогает
        navigationController?.navigationBar.isHidden = false
        
        UIView.animate(withDuration: 0.24, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.view.alpha = 0.0
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveOut()
    }
    
    deinit {
        print("deinit", CitiesViewController.self)
    }
}

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let city = isFiltering ? filteredCities[indexPath.row] : cities[indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = city
        
        if isFiltering == false {
            if cities.count == 1 {
                cell.layer.cornerRadius = 20
                cell.clipsToBounds = true
            } else {
                
                if city == cities.first {
                    cell.layer.cornerRadius = 20
                    cell.clipsToBounds = true
                    cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                }
                
                if city == cities.last {
                    cell.layer.cornerRadius = 20
                    cell.clipsToBounds = true
                    cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                }
            }
        } else {
            
            if filteredCities.count == 1 {
                cell.layer.cornerRadius = 20
                cell.clipsToBounds = true
            } else {
                if city == filteredCities.first {
                    cell.layer.cornerRadius = 20
                    cell.clipsToBounds = true
                    cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                }
                
                if city == filteredCities.last {
                    cell.layer.cornerRadius = 20
                    cell.clipsToBounds = true
                    cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredCities.count
        }
        
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let searchPartyVC = self.parent as? SearchPartyViewController {
            searchPartyVC.barView.cityButton.setTitle(cities[indexPath.row], for: .normal)
        }
        
        if let thirdCreatePartyVC = self.parent as? ThirdCreatePartyViewController {
            thirdCreatePartyVC.cityButton.setTitle(cities[indexPath.row], for: .normal)
        }

        moveOut()
    }
}

// MARK: - UISearchBarDelegate
extension CitiesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCities = cities.filter({ $0.hasPrefix(searchText)})
        print(searchText)
        
        tableView.reloadData()
    }
}
