//
//  ViewController.m
//  UIRefreshControlDemo
//
//  Created by Bill on 15/11/17.
//  Copyright © 2015年 XQ. All rights reserved.
//

#import "ViewController.h"
#import "XCActivityViewCell.h"

#define MAX_MESSAGE_COUNT 100

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    BOOL _notFirstTime;
}

@property (strong, nonatomic) UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *items;

@property (assign, nonatomic) BOOL isRequesting;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableview];
    self.tableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"XCActivityViewCell" bundle:nil] forCellReuseIdentifier:@"XCActivityViewCell"];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self hasMore]) {
        return self.items.count;
    }
    return self.items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    if (row == 0 && [self hasMore]) {
        static NSString *XCActivityViewCellIdentifier = @"XCActivityViewCell";
        
        XCActivityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XCActivityViewCellIdentifier];
        
        return cell;
    }
    
    if ([self hasMore]) {
        row--;
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = self.items[row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        return 30;
    }
    
    return 44;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
 
    if ([self hasMore] && row == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestMoreData];
        });
        
    }
}

- (BOOL)hasMore {
    return self.items.count < MAX_MESSAGE_COUNT;
}

#pragma mark - Getter

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    return _tableview;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

#pragma mark - requests

- (void)requestMoreData {
    if (self.isRequesting) {
        return;
    }
    self.isRequesting = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *indexPaths = [NSMutableArray array];

        // 数据读完的时候不需要顶部的activity了
        NSInteger offset = (self.items.count + 20 < MAX_MESSAGE_COUNT) ? 1 : 0;
        
        for (int i = 0; i < 20; i++) {
            int tmp = arc4random() % 10000;
            sleep(0.1);
            NSString *tmpStr = @(tmp).stringValue;
            
            [self.items insertObject:tmpStr atIndex:0];
            
            [indexPaths addObject:[NSIndexPath indexPathForRow:i + offset inSection:0]];
        }
        
        CGSize beforeContentSize = self.tableview.contentSize;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
            CGSize afterContentSize = self.tableview.contentSize;
            CGPoint afterContentOffset = self.tableview.contentOffset;
            CGPoint newContentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height);
            self.tableview.contentOffset = newContentOffset;
            
            if (!_notFirstTime) {
                [self.tableview scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:false];
                _notFirstTime = true;
            }
        });
        self.isRequesting = false;
    });
    
}

@end
