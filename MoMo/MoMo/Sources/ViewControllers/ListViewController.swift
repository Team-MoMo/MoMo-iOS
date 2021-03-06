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
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
        button.tintColor = .black
        return button
    }()
    
    private lazy var statButton: UIButton = {
        let button: UIButton = UIButton.init(type: .custom)
        button.setImage(Constants.Design.Image.listBtnGraph, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(touchStatButton), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button: UIButton = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(touchFilterButton), for: .touchUpInside )
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Constant
    
    let zeplinWidth: CGFloat = 375
    let filterCollectionViewSideAuto = 48
    let filterCollectionViewCellSpacing = 5
    
    // MARK: - Property
    
    var filteredEmotion: Int?
    var filteredDepth: Int?
    var journalLabel1WidthSize: CGFloat = 0.0
    var journalLabel2WidthSize: CGFloat = 0.0
    var receivedData: [Diary] = []
    var date = ""
    var filter: [String] = []
    var pattern: Bool = false
    var standardYear: Int = 0
    var standardMonth: Int = 0
    var year: Int = 2010
    var month: Int = 5
    var listFilterModalView: ListFilterModalViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        registerXib()
        initializeProperty()
        initializeTableView()
        assignDataSource()
        updateDelegate()
        assignDelegate()
        updateNavigationBarButton()
        initializeWarningLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDiariesWithAPI(userID: String(APIConstants.userId), year: String(year), month: String(month), order: "filter", day: nil, emotionID: nil, depth: nil)
    }
    
    // MARK: - Register TableView Cell
    
    private func registerXib() {
        let listcellnib = UINib(nibName: "ListTableViewCell", bundle: nil)
        listTableView.register(listcellnib, forCellReuseIdentifier: "ListTableViewCell")
        listTableView.register(UINib(nibName: "ListDateTableViewCell", bundle: nil), forCellReuseIdentifier: "ListDateTableViewCell")
        listTableView.register(UINib(nibName: "ListFilterTableViewCell", bundle: nil), forCellReuseIdentifier: "ListFilterTableViewCell")
        listTableView.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyTableViewCell")
    }
    
    // MARK: - Private Functions
    
    private func initializeProperty() {
        journalLabel1WidthSize = self.view.bounds.width * (261/zeplinWidth)
        journalLabel2WidthSize = self.view.bounds.width * (237/zeplinWidth)
        // 홈에서 받은 데이트 변수에 대입
        date = "\(year)년 \(month)월"
        updateNaviTitleLabel(self.date)
        // 필터에서 기준으로 잡을 년과 월 저장
        standardYear = year
        standardMonth = month
    }
    
    private func updateNaviTitleLabel(_ date: String) {
        if let font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16) {
            let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                             NSAttributedString.Key.foregroundColor: UIColor.Black2Nav,
                                                             NSAttributedString.Key.kern: -0.6]
            titleLabel.attributedText = NSAttributedString(string: date, attributes: attributes)
        }
    }
    
    private func initializeWarningLabel() {
        filterWarningLabel.attributedText = "검색된 결과가 없습니다".textSpacing()
        warningLabel.attributedText = "아직 작성된 일기가 없습니다.\n새로운 문장을 만나러 가볼까요?".wordTextSpacing(textSpacing: -0.6, lineSpacing: 4, center: true, truncated: false)
        filterWarningLabel.isHidden = true
        warningLabel.isHidden = true
        warningPlusButton.isHidden = true
    }
    
    private func assignDelegate() {
        listTableView.delegate = self
    }
    
    private func updateDelegate() {
        guard let modalView = listFilterModalView else {
            return
        }
        modalView.listFilterModalDelegate = self
    }
    
    private func assignDataSource() {
        self.listTableView.dataSource = self
    }
    
    private func initializeTableView() {
        self.listTableView.rowHeight  = UITableView.automaticDimension
        self.listTableView.estimatedRowHeight = 266
        self.listTableView.separatorStyle = .none
    }
    
    private func initializeHiddenStatus() {
        warningLabel.isHidden = true
        warningPlusButton.isHidden = true
        filterWarningLabel.isHidden = true
    }
    
    private func updateNavigationBarButton() {
    
        if year == standardYear && month == standardMonth && filter.count == 0 {
            filterButton.setImage(Constants.Design.Image.listBtnFilterBlack, for: .normal)
            filterButton.tintColor = .black
        } else {
            filterButton.setImage(Constants.Design.Image.listBtnFilterBlue, for: .normal)
        }

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: statButton), UIBarButtonItem(customView: filterButton)]
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.titleView = UILabel()
    }
    
    private func showWarningLabelAndButton() {
        if self.pattern == false && receivedData.count == 0 && self.year == self.standardYear && self.month ==  self.standardMonth {
            self.filterWarningLabel.isHidden = true
            self.warningLabel.isHidden = false
            self.warningPlusButton.isHidden = false
        } else if self.pattern == true && receivedData.count == 0 {
            self.filterWarningLabel.isHidden = false
            self.warningLabel.isHidden = true
            self.warningPlusButton.isHidden = true
        } else {
            self.warningLabel.isHidden = true
            self.warningPlusButton.isHidden = true
            self.filterWarningLabel.isHidden = true
        }
    }
    
    private func updateFilterCollectionViewCell(_ tagNumber: Int, _ identifier: String) {
        let indexPath = IndexPath(row: 0, section: 1)
    
        if identifier.contains("m") || identifier == "심해" {
            filteredDepth = nil
        } else {
            filteredEmotion = nil
        }
        guard let cell = listTableView.cellForRow(at: indexPath) as? ListFilterTableViewCell else {
            return
        }
        filter.remove(at: tagNumber)
        if filter.count == 0 {
            pattern.toggle()
            updateNavigationBarButton()
        }
        getDiariesWithAPI(userID: String(APIConstants.userId),
                      year: String(year),
                      month: String(month),
                      order: "filter",
                      day: nil,
                      emotionID: filteredEmotion,
                      depth: filteredDepth)
        cell.filterCollectionView.reloadData()
    }
    
    private func scrollTableViewToTop() {
        self.listTableView.contentOffset = .zero
    }
    // MARK: - 서버 통신
    func getDiariesWithAPI(userID: String,
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
                                         depth: depth) { (networkResult) in
            switch networkResult {

            case .success(let data):
                if let diary = data as? [Diary] {
                    self.receivedData = diary
                    self.listTableView.reloadData()
                    self.showWarningLabelAndButton()
                }
                
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr in getDiariesWithAPI")
            case .serverErr:
                print("serverErr in getDiariesWithAPI")
            case .networkFail:
                print("networkFail in getDiariesWithAPI")
            }
        }
    }
    
    // MARK: - Selector Functions
    
    // 필터 라벨 외 부분을 터치했을 때 실행되는 함수
    @objc func tapEmptySpace(_ sender: UITapGestureRecognizer) {

        guard let tagNumber = sender.view?.tag, let identifier = sender.view?.accessibilityIdentifier else {
            return
        }
        
        updateFilterCollectionViewCell(tagNumber, identifier)
    }
    
    // filter x버튼 클릭시 발생하는 함수
    @objc func touchCancelButton(sender: UIButton) {
        guard let identifier = sender.accessibilityIdentifier else {
            return
        }
        updateFilterCollectionViewCell(sender.tag, identifier)
        
    }
    @objc func touchFilterButton() {
        presentToListFilterModalView()
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
    
    @objc func tapTouchView(sender: UITapGestureRecognizer) {
        guard let num = sender.view?.tag else {
            return
        }
        pushToDiaryViewController(diaryId: num)
    }
    
    func presentToListFilterModalView() {
        listFilterModalView = ListFilterModalViewController()
        updateDelegate()
        guard let modalView = listFilterModalView else {
            return
        }
        if let paramEmotion = filteredEmotion {
            modalView.emotion = paramEmotion-1
        }
        if let paramDepth = filteredDepth {
            modalView.depth = paramDepth
        }
        
        modalView.selectedYear = self.year
        modalView.selectedMonth = self.month
        modalView.width = view.bounds.width
        modalView.height = view.bounds.height
        modalView.modalPresentationStyle = .custom
        modalView.transitioningDelegate = self
        
        self.present(modalView, animated: true, completion: nil)
    }
    

    @objc func touchMoreButton(sender: UIButton) {
        self.pushToDiaryViewController(diaryId: sender.tag)
    }
    
    func pushToDiaryViewController(diaryId: Int) {
        let diaryStoryboard = UIStoryboard(name: Constants.Name.diaryStoryboard, bundle: nil)
        
        guard let diaryViewController = diaryStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryViewController) as? DiaryViewController else {
            return
        }
        
        diaryViewController.diaryId = diaryId
        diaryViewController.isFromListView = true
        
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    @IBAction func touchWarningPlusButton(_ sender: Any) {
        pushToMoodView()
    }
    
    func pushToMoodView() {
        let onboardingStoryboard = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
        
        guard let moodViewController = onboardingStoryboard.instantiateViewController(identifier: Constants.Identifier.moodViewController) as? MoodViewController else {
            return
        }
        moodViewController.listNoDiary = true
        moodViewController.moodViewUsage = .upload
        
        self.navigationController?.pushViewController(moodViewController, animated: true)
    }
    
}

// MARK: - TableViewDelegate
extension ListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.listTableView.contentOffset.y > 40 {
            self.navigationItem.titleView = self.titleLabel
        } else {
            self.navigationItem.titleView = UILabel()
        }
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
            cell.updateDateLabel(date)
            cell.selectionStyle = .none
            return cell
        case 1:
            if filter.count > 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListFilterTableViewCell") as? ListFilterTableViewCell else {
                return UITableViewCell()
                }
                cell.filterCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterCollectionViewCell")
                cell.filterCollectionView.register(UINib(nibName: "EmptyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmptyCollectionViewCell")
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
            DispatchQueue.main.async {
                cell.journalView.round(corners: [.topLeft, .bottomLeft], cornerRadius: 20)
                cell.touchView.round(corners: [.topLeft, .bottomLeft], cornerRadius: 20)
            }
            cell.parseDiaryAll(diary: self.receivedData[indexPath.row])
            cell.customQuote(self.receivedData[indexPath.row].sentence.contents)
            cell.divideJournal(self.receivedData[indexPath.row].contents, self.journalLabel1WidthSize)
            cell.createLabelUnderline( self.journalLabel2WidthSize)
            cell.touchView.tag = self.receivedData[indexPath.row].id
            cell.touchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTouchView(sender:))))
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
        if indexPath.row < filter.count {
            let filterOptionCellWidth = filter[indexPath.row].size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]).width + 34
            return CGSize(width: Int(filterOptionCellWidth), height: 24)
        } else {
            var size: Int = 0
            for idx in 0..<filter.count {
                size += Int(filter[idx].size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]).width) + 34
            }
            size = Int(self.view.frame.width) - size - self.filterCollectionViewSideAuto - (self.filterCollectionViewCellSpacing * filter.count)
            return CGSize(width: size, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(filterCollectionViewCellSpacing)
    }
}

// MARK: - UICollectionViewDataSource

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filter.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < filter.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 8
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapEmptySpace(_:)))
            cell.filterLabel.text = filter[indexPath.row]
            // index 값을 tag에 넣어서 배열에 쉽게 접근
            cell.cancelButton.tag = indexPath.row
            cell.cancelButton.accessibilityIdentifier = filter[indexPath.row]
            cell.cancelButton.addTarget(self, action: #selector(touchCancelButton(sender:)), for: .touchUpInside)
            cell.filterTouchAreaView.tag = indexPath.row
            cell.filterTouchAreaView.accessibilityIdentifier = filter[indexPath.row]
            cell.filterTouchAreaView.addGestureRecognizer(tapRecognizer)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionViewCell", for: indexPath) as? EmptyCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - ListFilterModalViewDelegate
extension ListViewController: ListFilterModalViewDelegate {
    func sendData(year: Int, month: Int, emotion: Int?, depth: Int?, filterArray: [String], filteredStatus: Bool) {
        scrollTableViewToTop()
        self.year = year
        self.month = month
        self.filter = filterArray
        self.date = "\(year)년 \(month)월"
        updateNaviTitleLabel(self.date)
        updateNavigationBarButton()

        if filterArray.count > 0 || self.year != standardYear || self.month != standardMonth {
            self.pattern = true
        }
        if year == standardYear && month == standardMonth && filterArray.count == 0 {
            getDiariesWithAPI(userID: String(APIConstants.userId),
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
            unwrapSendDataParam(paramEmotion: emotion, paramDepth: depth)
            self.listTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 1)
            guard let cell = listTableView.cellForRow(at: indexPath) as? ListFilterTableViewCell else {
                return
            }
            cell.filterCollectionView.reloadData()
        }
        self.listFilterModalView = ListFilterModalViewController()
        self.updateDelegate()
    }
    
    private func unwrapSendDataParam(paramEmotion: Int?, paramDepth: Int?) {
        
        if paramEmotion == nil && paramDepth != nil {
            guard let unwrappedDepth = paramDepth else {
                return
            }
            getDiariesWithAPI(userID: String(APIConstants.userId),
                          year: String(year),
                          month: String(month),
                          order: "filter",
                          day: nil,
                          emotionID: nil,
                          depth: unwrappedDepth)
            
        } else if paramEmotion != nil && paramDepth == nil {
            guard let unwrappedEmotion = paramEmotion else {
                return
            }
            getDiariesWithAPI(userID: String(APIConstants.userId),
                          year: String(year),
                          month: String(month),
                          order: "filter",
                          day: nil,
                          emotionID: unwrappedEmotion,
                          depth: nil)
            
        } else if paramEmotion != nil && paramDepth != nil {
            guard let unwrappedEmotion = paramEmotion, let unwrappedDepth = paramDepth else {
                return
            }
            getDiariesWithAPI(userID: String(APIConstants.userId),
                          year: String(year),
                          month: String(month),
                          order: "filter",
                          day: nil,
                          emotionID: unwrappedEmotion,
                          depth: unwrappedDepth)
            
        } else {
            getDiariesWithAPI(userID: String(APIConstants.userId),
                          year: String(year),
                          month: String(month),
                          order: "filter",
                          day: nil,
                          emotionID: nil,
                          depth: nil)
        }
    }
}
