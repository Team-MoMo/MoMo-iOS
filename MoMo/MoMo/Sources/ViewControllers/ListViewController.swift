//
//  ListViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2020/12/29.
//

import UIKit

struct List {
    var iconImage: String
    var category: String
    var date: String
    var day: String
    var depth: String
    var quote: String
    var author: String
    var title: String
    var publisher: String
    var journal: String
    
    func makeImage() -> UIImage? {
        return UIImage(named: iconImage)
    }
}

class ListViewController: UIViewController {

    // MARK: - Properities
    
    @IBOutlet weak var listTableView: UITableView!
    var widthSize: CGFloat = 0.0
    var secondWidthSize: CGFloat = 0.0
    var dummyData: [List] = []
    var date = [2021, 02]
    var filter: [String] = ["2021년 02", "배고파", "심해"]
    var pattern: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        self.listTableView.rowHeight  = UITableView.automaticDimension
        self.listTableView.estimatedRowHeight = 266
        self.listTableView.dataSource = self
        self.listTableView.separatorStyle = .none
        widthSize = CGFloat(self.view.bounds.width * (325/414))
        secondWidthSize = CGFloat(self.view.bounds.width * (237/414))
        setData()
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
    
    @IBAction func touch(_ sender: Any) {
        let modalView = ListFilterModalViewController()
        modalView.width = view.bounds.width
        modalView.height = view.bounds.height
        modalView.modalPresentationStyle = .custom
        modalView.transitioningDelegate = self
                
        self.present(modalView, animated: true, completion:nil)
        
    }
    // dummyData 설정
    func setData() {
        dummyData.append(contentsOf: [
            List(
                iconImage: "icHappyBlue",
                 category: "행복",
                 date: "12.01",
                 day: "화",
                 depth: "2m",
                 quote: "할머니가 자애로운 손길로 내 얼굴과 머리카락, 이마를 쓸어주는게 좋았다. 마치 내 존재 전부를 쓸어주는 것 같았다. 아 진짜 이거 어떻게 해야 돼 너무 힘들다 ㄹㅇ 제발 끝났으면 좋겠다",
                 author: "박연준",
                 title: "<인생은 이상하게 흐른다>",
                 publisher: "(달)",
                 journal: "오늘 새벽엔 눈이 내렸다. 와 ㄹㅇ 이게 머야 ㅋ ㅋㅋㅗ 포ㅓ ㅏ ㅓㅎ"),
            List(
                iconImage: "icLoveBlue",
                 category: "사랑",
                 date: "12.02",
                 day: "수",
                 depth: "700m",
                 quote: "나는 사랑받고 있다고 느꼈다. 사랑에는 언제나 한 방울의 연민이 포함되기 때문이다.",
                 author: "박연준",
                 title: "<인생은 이상하게 흐른다>",
                 publisher: "(달)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(
                iconImage: "icBoredBlue",
                category: "권태",
                date: "12.08",
                day: "화",
                depth: "300m",
                quote: "너무 많은 당신 때문에 상처는 더욱 싱싱해지고 내가 있는 이 공간은 좁아진다.나는 어디에 머물러야 하나?",
                author: "황인숙",
                title: "<좋은 일이 아주 없는 건 아니잖아>",
                publisher: "(달)",
                journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(
                iconImage: "icSadBlue",
                category: "슬픔",
                date: "12.11",
                day: "금",
                depth: "100m",
                quote: "도라였다. 얼굴을 돌렸다. 종일 가시가 박힌 것처럼 가슴이 따가웠다.",
                author: "손원평",
                title: "<아몬드>",
                publisher: "(창비)",
                journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(iconImage: "icMemoryBlue",
                 category: "추억",
                 date: "12.12",
                 day: "토",
                 depth: "300m",
                 quote: "어쩌면 좋으냐 네가 너무 많이 예뻐서 어쩌면 좋으냐 네가 너무 많아서",
                 author: "나태주",
                 title: "<끝까지 남겨두는 그 마음>",
                 publisher: "(북로그컴퍼니)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(iconImage: "icDailyBlue",
                 category: "일상",
                 date: "12.16",
                 day: "수",
                 depth: "30m",
                 quote: "아무것도 아냐. 미안해, 놀라게 해서. 별일 아니니까 걱정하지마.",
                 author: "히가시노 게이고",
                 title: "<나미야 잡화점의 기적>",
                 publisher: "(현대문학)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(iconImage: "icAngryBlue",
                 category: "화남",
                 date: "12.18",
                 day: "금",
                 depth: "심해",
                 quote: "여기서 살아야 할 사람이 커튼을 치고 싶다는데 그것조차 잘못된 생각이라고 몰아붙이는 그 눈빛이랑 조금도 소통하고 싶지 않았다.",
                 author: "히가시노 게이고",
                 title: "<나미야 잡화점의 기적>",
                 publisher: "(현대문학)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(iconImage: "icConsoleBlue",
                 category: "위로",
                 date: "12.20",
                 day: "일",
                 depth: "100m",
                 quote: "“괜찮아, 영주.” 한지가 말했다. 충동적으로 여기에 머물기로 한 것도, 네가 해야 했던 일을 내팽겨쳐버린 것도, 수도원 생활도 모두, 괜찮아.",
                 author: "최은영",
                 title: "<쇼코의 미소 - 한지와 영주>",
                 publisher: "(문학동네)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ...")
        ])
    }
    
    // filter x버튼 클릭시 발생하는 함수
    @objc func touchCancelButton(sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 1)
        guard let cell = listTableView.cellForRow(at: indexPath) as? ListFilterTableViewCell else {
            return
        }
        filter.remove(at: sender.tag)
        cell.filterCollectionView.reloadData()
        
        if filter.count == 0 {
            pattern.toggle()
            listTableView.reloadData()
        }
    }
}

// MARK: - TableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? dummyData.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListDateTableViewCell") as? ListDateTableViewCell else {
                return UITableViewCell()
            }
            cell.setDate("\(date[0])년 \(date[1])월")
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
            
            cell.setCell(list: self.dummyData[indexPath.row])
            cell.quoteSpacing(self.dummyData[indexPath.row].quote)
            cell.journalView.round(corners: [.topLeft, .bottomLeft], cornerRadius: 20)
            cell.journaltext(self.dummyData[indexPath.row].journal, self.widthSize)
            cell.setLabelUnderline(self.widthSize, self.secondWidthSize)
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
        cell.cancelButton.addTarget(self, action: #selector(touchCancelButton(sender:)), for: .touchUpInside)
        cell.filterTouchAreaView.tag = indexPath.row
        cell.filterTouchAreaView.addGestureRecognizer(tapRecognizer)
        return cell
    }
}

extension ListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
