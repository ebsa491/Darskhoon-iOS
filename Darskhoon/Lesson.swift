//
//  Lesson.swift
//  Darskhoon
//
//  Created by Saman on 3/16/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit

class Lesson {
    
    private var _id: String!
    private var _title: String!
    private var _desc: String!
    private var _time: String!
    private var _teacher: String!
    private var _video: String!
    private var _image: String!
    
    var id: String {
        get {
            return _id
        }
    }
    
    var title: String {
        get {
            return _title
        }
    }
    
    var desc: String {
        get {
            return _desc
        }
    }
    
    var time: String {
        get {
            return _time
        }
    }
    
    var teacher: String {
        get {
            return _teacher
        }
    }
    
    var video: String {
        get {
            return _video
        }
    }
    
    var image: String {
        get {
            return _image
        }
    }
    
    init(id: String, title: String, desc: String, time: String, teacher: String, video: String, image: String) {
        _id = id
        _title = title
        _desc = desc
        _time = time
        _teacher = teacher
        _video = video
        _image = image
    }
    
}
