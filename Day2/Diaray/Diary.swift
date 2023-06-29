//
//  Diary.swift
//  Diaray
//
//  Created by 신현호 on 2023/06/21.
//

import Foundation

struct Diary {
  var uuidString: String
  var title: String //일기제목
  var contents: String  //일기내용
  var date: Date    //날짜
  var isStar: Bool  //즐겨찾기 여부저장
}
