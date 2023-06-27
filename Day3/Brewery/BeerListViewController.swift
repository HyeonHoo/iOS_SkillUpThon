//
//  BeerListViewController.swift
//  Brewary
//
//  Created by 신현호 on 2023/06/22.
//

import UIKit

class BeerListViewController: UITableViewController {
    var beerList = [Beer]()
    var dataTasks = [URLSessionTask]()
    var currentPage = 1     //페이지 기반 데이터
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UINavigationController 설정
        title = "브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //UITableView 설정
        tableView.prefetchDataSource = self
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        
        fetchBeer(of: currentPage)  //페이지 실행
    }
}

//UITableView DataSource, Delegate
extension BeerListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //선택한 로우의 값을 넘겨줍니다.
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
}

//페이지네이션 작업
extension BeerListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else { return }
        
        indexPaths.forEach {
            if ($0.row + 1)/25 + 1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }
    }
}

//Data Fetching
private extension BeerListViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
            dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil else { return }
        //이미 Beer를 패칭했음. 그렇지 않다면,
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //shared싱글톤 찾아보기 //순환참조 방지를 위한 self 참조
        
        let dataTask = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                    print("ERROR: URLSession data task error \(error?.localizedDescription ?? "")")
                    return
            }
            
            switch response.statusCode {            //응답 상태 확인
            case (200...299):                         //정상
                self.beerList += beers
                self.currentPage += 1

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case (400...499):                           //클라이언트 오류
                print(
                    """
                    ERROR: Client ERROR \(response.statusCode)
                    Response: \(response)
                    """
                )
            case (500...599):   //서버 오류
                print(
                    """
                    ERROR: Server ERROR \(response.statusCode)
                    Response: \(response)
                    """
                )
            default:        //구문 or 키 오류
                print(
                    """
                    ERROR: \(response.statusCode)
                    Response: \(response)
                    """
                )
            }
        }
        dataTask.resume()                   //데이터 실행
        dataTasks.append(dataTask)
    }
}
