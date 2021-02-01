//
//  ListViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2020/12/29.
//

import UIKit

class ListViewController: UIViewController {

    // MARK: - Properities
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var warningPlusButton: UIButton!
    @IBOutlet weak var filterWarningLabel: UILabel!
    
    var filteredEmotion: Int?
    var filteredDepth: Int?
    var widthSize: CGFloat = 0.0
    var secondWidthSize: CGFloat = 0.0
    var receivedData: [Diary] = []
    var date = ""
    var filter: [String] = []
    var pattern: Bool = false
    var standardYear: Int = 0
    var standardMonth: Int = 0
    var year: Int = 2010
    var month: Int = 5
    var modalView: ListFilterModalViewController? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        self.listTableView.rowHeight  = UITableView.automaticDimension
        self.listTableView.estimatedRowHeight = 266
        self.listTableView.dataSource = self
        self.listTableView.separatorStyle = .none
        widthSize = CGFloat(self.view.bounds.width * (325/414))
        secondWidthSize = CGFloat(self.view.bounds.width * (237/414))
//        setData()
        setDate()
        standardYear = year
        standardMonth = month
        setNavigationBarButton()
        self.modalView = ListFilterModalViewController()
        self.modalView?.modalPassDataDelegate = self
        warningLabel.text = "아직 작성된 일기가 없습니다.\n새로운 문장을 만나러 가볼까요?"
        warningLabel.isHidden = true
        warningPlusButton.isHidden = true
        filterWarningLabel.text = "검색된 결과가 없습니다"
        filterWarningLabel.isHidden = true
        connectServer(userID: String(APIConstants.userId), year: String(year), month: String(month), order: "filter", day: nil, emotionID: nil, depth: nil)
    }

    func connectServer(userID: String,
                       year: String,
                       month: String,
                       order: String,
                       day: Int?,
                       emotionID: Int?,
                       depth: Int?) {
        DiariesService.shared.getDiaries(userId: userID,
                                         year: year,
                                         month: month,
                                         order: order,
                                         day: day,
                                         emotionId: emotionID,
                                         depth: depth) {
            (networkResult) -> (Void) in
            switch networkResult {

            case .success(let data):
                if let diary = data as? [Diary] {
                    print(self.pattern)
                    print(self.receivedData.count)
                    self.receivedData = diary
                    self.listTableView.reloadData()
                    if self.pattern == false && diary.count == 0 && self.year == self.standardYear && self.month ==  self.standardMonth{
                        self.filterWarningLabel.isHidden = true
                        self.warningLabel.isHidden = false
                        self.warningPlusButton.isHidden = false
                    } else if self.pattern == true && diary.count == 0 {
                        print(1)
                        self.filterWarningLabel.isHidden = false
                        self.warningLabel.isHidden = true
                        self.warningPlusButton.isHidden = true

                    } else {
                        self.warningLabel.isHidden = true
                        self.warningPlusButton.isHidden = true
                        self.filterWarningLabel.isHidden = true
                    }
                }
                
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    @objc func tapEmptySpace(_ sender: UITapGestureRecognizer) {
        guard let tagNumber = sender.view?.tag else {
            return
        }
        let indexPath = IndexPath(row: 0, section: 1)
        guard let cell = listTableView.cellForRow(at: indexPath) as? ListFilterTableViewCell else {
            return
        }
        filter.remove(at: tagNumber)
        cell.filterCollectionView.reloadData()
        
        if filter.count == 0 {
            pattern.toggle()
            listTableView.reloadData()
            setNavigationBarButton()
        }
    }
    
    // MARK: - Register TableView Cell
    
    private func registerXib() {
        let listcellnib = UINib(nibName: "ListTableViewCell", bundle: nil)
        listTableView.register(listcellnib, forCellReuseIdentifier: "ListTableViewCell")
        listTableView.register(UINib(nibName: "ListDateTableViewCell", bundle: nil), forCellReuseIdentifier: "ListDateTableViewCell")
        listTableView.register(UINib(nibName: "ListFilterTableViewCell", bundle: nil), forCellReuseIdentifier: "ListFilterTableViewCell")
        listTableView.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyTableViewCell")

    }
    
    private func setNavigationBarButton() {
        let statButton = UIBarButtonItem(image: Constants.Design.Image.listBtnGraph, style: .plain, target: self, action: #selector(touchStatButton))
        statButton.tintColor = .black
        let backButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
        backButton.tintColor = .black
        let filterButton: UIBarButtonItem
        if year == standardYear && month == standardMonth && filter.count == 0 {
            filterButton = UIBarButtonItem(image: Constants.Design.Image.listBtnFilterBlack, style: .plain, target: self, action: #selector(touchFilterButton))
            filterButton.tintColor = .black
        } else {
            filterButton = UIBarButtonItem(image: Constants.Design.Image.listBtnFilterBlue, style: .plain, target: self, action: #selector(touchFilterButton))
        }
        self.navigationItem.rightBarButtonItems = [statButton, filterButton]
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func touchFilterButton() {
        showModal()
    }
    @objc func touchStatButton() {
        let statStoryboard = UIStoryboard(name: Constants.Name.statisticsStoryboard, bundle: nil)
        
        guard let statViewController = statStoryboard.instantiateViewController(identifier: Constants.Identifier.statisticsViewController) as? StatisticsViewController else {
            return
        }
        
        self.navigationController?.pushViewController(statViewController, animated: true)
    }
    @objc func touchBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func setDate() {
        date = "\(year)년 \(month)월"
        
    }
    
    func showModal() {
        modalView?.selectedYear = self.year
        modalView?.selectedMonth = self.month
        modalView?.width = view.bounds.width
        modalView?.height = view.bounds.height
        modalView?.emotion = self.filteredEmotion
        modalView?.depth = self.filteredDepth
        modalView?.modalPresentationStyle = .custom
        modalView?.transitioningDelegate = self
        
        self.present(modalView!, animated: true, completion:nil)
    }
    
    // filter x버튼 클릭시 발생하는 함수
    @objc func touchCancelButton(sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 1)
        guard let buttonAccessibilityLabel = sender.accessibilityLabel else {
            return
        }
        if buttonAccessibilityLabel.contains("m") || buttonAccessibilityLabel == "심해" {
            filteredDepth = nil
        } else {
            filteredEmotion = nil
        }
        guard let cell = listTableView.cellForRow(at: indexPath) as? ListFilterTableViewCell else {
            return
        }
        filter.remove(at: sender.tag)
        if filter.count == 0 {
            pattern.toggle()
            setNavigationBarButton()
        }
        connectServer(userID: String(APIConstants.userId),
                      year: String(year),
                      month: String(month),
                      order: "filter",
                      day: nil,
                      emotionID: filteredEmotion,
                      depth: filteredDepth)
        cell.filterCollectionView.reloadData()
        
    }
    
    @objc func touchMoreButton(sender: UIButton) {
        let diaryStoryboard = UIStoryboard(name: Constants.Name.diaryStoryboard, bundle: nil)
        
        guard let diaryViewController = diaryStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryViewController) as? DiaryViewController else {
            return
        }
        
        diaryViewController.diaryId = sender.tag
        
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    @IBAction func touchWarningPlusButton(_ sender: Any) {
        let diaryStoryboard = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
        guard let moodViewController = diaryStoryboard.instantiateViewController(identifier: Constants.Identifier.moodViewController) as? MoodViewController else {
            return
        }
        moodViewController.listNoDiary = true
        self.navigationController?.pushViewController(moodViewController, animated: true)
    }
    
}

// MARK: - TableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? receivedData.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListDateTableViewCell") as? ListDateTableViewCell else {
                return UITableViewCell()
            }
            cell.setDate(date)
            cell.selectionStyle = .none
            return cell
        case 1:
            if pattern {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListFilterTableViewCell") as? ListFilterTableViewCell else {
                return UITableViewCell()
                }
                cell.filterCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterCollectionViewCell")
                cell.filterCollectionView.delegate = self
                cell.filterCollectionView.dataSource = self
                cell.selectionStyle = .none
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
                
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell else {
                return UITableViewCell()
            }
            
            
            cell.setCell(diary: self.receivedData[indexPath.row])
            cell.quoteSpacing(self.receivedData[indexPath.row].sentence.contents)
            cell.journalView.round(corners: [.topLeft, .bottomLeft], cornerRadius: 20)
            cell.journaltext(self.receivedData[indexPath.row].contents, self.widthSize)
            cell.setLabelUnderline(self.widthSize, self.secondWidthSize)
            cell.moreButton.tag = self.receivedData[indexPath.row].id
            cell.moreButton.addTarget(self, action: #selector(touchMoreButton(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
                
            return cell
        default:
            return UITableViewCell()
            }
        }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filterOptionCellWidth = filter[indexPath.row].size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]).width + 34
        return CGSize(width: Int(filterOptionCellWidth), height: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.view.frame.width * 8/375
    }
}

// MARK: - UICollectionViewDataSource

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapEmptySpace(_:)))
        cell.filterLabel.text = filter[indexPath.row]
        // index 값을 tag에 넣어서 배열에 쉽게 접근
        cell.cancelButton.tag = indexPath.row
        cell.cancelButton.accessibilityLabel = filter[indexPath.row]
        cell.cancelButton.addTarget(self, action: #selector(touchCancelButton(sender:)), for: .touchUpInside)
        cell.filterTouchAreaView.tag = indexPath.row
        cell.filterTouchAreaView.accessibilityLabel = filter[indexPath.row]
        cell.filterTouchAreaView.addGestureRecognizer(tapRecognizer)
        return cell
    }
}

extension ListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ListViewController: ModalPassDataDelegate {
    func sendData(year: Int, month: Int, emotion: Int?, depth: Int?, filterArray: [String], filteredStatus: Bool) {
        self.year = year
        self.month = month
        setDate()
        self.filter = filterArray
        self.pattern = filterArray.count == 0 ? false : true
        if year == standardYear && month == standardMonth && filterArray.count == 0 {
            setNavigationBarButton()
            connectServer(userID: String(APIConstants.userId),
                          year: String(year),
                          month: String(month),
                          order: "filter",
                          day: nil,
                          emotionID: nil,
                          depth: nil)
            let indexPath = IndexPath(row: 0, section: 1)
            guard let cell = listTableView.cellForRow(at: indexPath) as? ListFilterTableViewCell else {
                return
            }
            cell.filterCollectionView.reloadData()
        } else {
            self.filteredDepth = depth
            self.filteredEmotion = emotion
            setNavigationBarButton()
            connectServer(userID: String(APIConstants.userId),
                          year: String(year),
                          month: String(month),
                          order: "filter",
                          day: nil,
                          emotionID: emotion,
                          depth: depth)
            self.listTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 1)
            guard let cell = listTableView.cellForRow(at: indexPath) as? ListFilterTableViewCell else {
                return
            }
            cell.filterCollectionView.reloadData()
        }
        self.modalView = ListFilterModalViewController()
        self.modalView?.modalPassDataDelegate = self
    }
}

