/****************************************************************************
 *	@desc	popover
 *	@date	16/9/18
 *	@author	110102
 *	@file	PopoverViewController.swift
 *	@modify	null
 ******************************************************************************/

import UIKit

public typealias PopoverSelectCallback = (selectedIndex: Int)->()
public typealias PopoverItemDisplayCallback = (itemIndex: Int, contentView: UIView)->()

public class PopoverViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    /// 数据源
    public var data: [AnyObject] = [] {
        didSet {
            _tableView?.reloadData()
        }
    }
    /// 背景颜色
    public var backgroundColor: UIColor? = nil {
        didSet {
            self.popoverPresentationController?.backgroundColor = backgroundColor
        }
    }
    /// 选中的单元格的颜色
    public var selectedCellColor: UIColor? = nil
    /// 原本的单元格颜色
    private var originCellColor: UIColor? = nil
    /// 分割线颜色
    public var separatorColor: UIColor? = nil {
        didSet {
            _tableView?.separatorColor = separatorColor
        }
    }
    /// 行高
    public var rowHeight: CGFloat = 0
    /// 行宽
    public var rowWidth: CGFloat = 0
    /// 选择回调
    public var selectCallback: PopoverSelectCallback? = nil
    /// 选项显示的回调
    public var itemDisplayCallback: PopoverItemDisplayCallback? = nil
    
    private var _tableView: UITableView! = nil
    private let TableViewCellId = "popover_item_cell"
    
    public static func create() -> PopoverViewController? {
        let storyboard = UIStoryboard(name: "PopoverViewController", bundle: NSBundle.mainBundle())
        let storyboardId = "PopoverViewController"
        return storyboard.instantiateViewControllerWithIdentifier(storyboardId) as? PopoverViewController
    }
    
    override public func viewDidLoad() {
        // view
        if backgroundColor != nil {
            self.view.backgroundColor = UIColor.clearColor()
        }
        // table view
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Plain)
        _tableView.delegate = self
        _tableView.dataSource = self
        if backgroundColor != nil {
            _tableView.backgroundColor = UIColor.clearColor()
        }
        _tableView.separatorColor = separatorColor
        _tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, 0, CGFloat.min))
        _tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, CGFloat.min))
        _tableView.scrollEnabled = false
        _tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        _tableView.separatorInset = UIEdgeInsetsZero
        _tableView.layoutMargins = UIEdgeInsetsZero
        _tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: TableViewCellId)
        self.view.addSubview(_tableView)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: _tableView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0).active = true
        NSLayoutConstraint(item: _tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0).active = true
        NSLayoutConstraint(item: _tableView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0).active = true
        NSLayoutConstraint(item: _tableView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0).active = true
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        itemDisplayCallback?(itemIndex: indexPath.row, contentView: cell.contentView)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        if backgroundColor != nil {
            cell.backgroundColor = UIColor.clearColor()
        }
    }
    
    public func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            originCellColor = cell.backgroundColor
            cell.backgroundColor = selectedCellColor
        }
    }
    
    public func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.backgroundColor = originCellColor
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if originCellColor != nil {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.backgroundColor = originCellColor
        }
        selectCallback?(selectedIndex: indexPath.row)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellId, forIndexPath: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
}
