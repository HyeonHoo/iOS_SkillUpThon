//
//  Diary.swift
//  Diary
//
//  Created by Gunter on 2021/09/11.
//

import Foundation

struct Diary {
  var uuidString: String
  var title: String //일기제목
  var contents: String  //일기내용
  var date: Date    //날짜
  var isStar: Bool  //즐겨찾기 여부저장
}
