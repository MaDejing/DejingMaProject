
struct YLImageCollectionItem {
    
    fileprivate var _image: UIImage?
    fileprivate var _url: NSURL?
    
    var image: UIImage? { return _image }
    var url: NSURL? { return _url }
    
    init(image: UIImage?) { _image = image }
    init(url: NSURL?) { _url = url }
}

struct YLImageCollectionPage {
    
    fileprivate var _items: [YLImageCollectionItem] = []
    
    init(images: [UIImage?]) {
        for image in images {
            _items.append(YLImageCollectionItem(image: image))
        }
    }
    
    init(urls: [NSURL?]) {
        for url in urls {
            _items.append(YLImageCollectionItem(url: url))
        }
    }
    
    init(items: [YLImageCollectionItem]) {
        _items = items
    }
}

extension YLImageCollectionPage {
    
    var items: [YLImageCollectionItem] { return _items }
    
    func item(atIndex _index: Int) -> YLImageCollectionItem? {
        return _items.safeElement(atIndex: _index)
    }
    
    func numberOfItems() -> Int {
        return _items.count
    }
}

struct YLImageCollection {
    
    fileprivate var _pages: [YLImageCollectionPage] = []
    
    init(pages: [YLImageCollectionPage], maxNumberOfItemAtPage: Int = 8) {
        _pages = pages
        
        var index = 0
        var page = _pages.safeElement(atIndex: index)
        while page != nil {
            if page!.numberOfItems() > maxNumberOfItemAtPage {
                let leftPageItems = page!.items.safeSubarray(toIndex: maxNumberOfItemAtPage - 1)
                var rightPageItems = page!.items.safeSubarray(leftIndex: maxNumberOfItemAtPage, rightIndex: page!.numberOfItems() - 1)
                if rightPageItems.count < maxNumberOfItemAtPage {
                    for _ in rightPageItems.count...maxNumberOfItemAtPage-1 {
                        rightPageItems.append(YLImageCollectionItem(image: nil))
                    }
                }
                _pages.safeRemove(atIndex: index)
                _pages.safeInsert(element: YLImageCollectionPage(items: leftPageItems), atIndex: index)
                _pages.safeInsert(element: YLImageCollectionPage(items: rightPageItems), atIndex: index + 1)
            }
            index += 1
            page = _pages.safeElement(atIndex: index)
        }
    }
}

extension YLImageCollection {
    
    func page(atIndex _index: Int) -> YLImageCollectionPage {
        return _pages.safeElement(atIndex: _index)!
    }
    
    func page(atIndexPath _indexPath: NSIndexPath) -> YLImageCollectionPage {
        return page(atIndex: _indexPath.section)
    }
    
    func item(atIndexPath _indexPath: NSIndexPath) -> YLImageCollectionItem? {
        return page(atIndexPath: _indexPath).item(atIndex: _indexPath.row)
    }
    
    func numberOfPages() -> Int {
        return _pages.count
    }
    
    func numberOfItems(atPage _page: Int) -> Int {
        return page(atIndex: _page).numberOfItems()
    }
}
