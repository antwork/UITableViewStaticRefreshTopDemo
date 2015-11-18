//
//  ViewController.m
//  UIRefreshControlDemo
//
//  Created by Bill on 15/11/17.
//  Copyright © 2015年 XQ. All rights reserved.
//

#import "ViewController.h"
#import "XCActivityViewCell.h"
#import "XQContentCell.h"
#import "NSString+XQSize.h"
#import "UITableView+FDTemplateLayoutCell.h"

#define MAX_MESSAGE_COUNT 100

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    BOOL _notFirstTime;
    CGFloat _maxWidth;
}

@property (strong, nonatomic) UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *items;

@property (assign, nonatomic) BOOL isRequesting;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSString *totalTexts;

@property (strong, nonatomic) NSMutableDictionary *cachedHeightDict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalTexts = @"针对小方遇到的情况，国家二级心理咨询师宣妤认为，小方乘车时，车窗是开着一部分，空间是开放的，在这种情况下，司机用迷药迷人的可能性几乎没有。在排除刑事案件的可能性后，导致小方晕厥感强烈以及舌脸发麻的原因有两个：一是心理原因，可能看过类似的电影，其中有相似场景的情节，所以不由自主地臆想，身体产生反应；另外一个则是身体原因，风吹着，她又穿着短裙，忽冷忽热，身体自动产生反应，这种反应方式因人而异，有可能到小方这里就正好是晕厥感。";
    
    _maxWidth = [UIScreen mainScreen].bounds.size.width-16;
    
    [self.view addSubview:self.tableview];
    self.tableview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"XCActivityViewCell" bundle:nil] forCellReuseIdentifier:@"XCActivityViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"XQContentCell"  bundle:nil] forCellReuseIdentifier:@"XQContentCell"];
    
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
    
    static NSString *CellIdentifier = @"XQContentCell";
    XQContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.valueField.text = self.items[row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        return 30;
    }
    
    if ([self hasMore]) {
        row--;
    }
    
    NSString *txt = self.items[row];
    
    return [tableView fd_heightForCellWithIdentifier:@"XQContentCell" cacheByKey:txt configuration:^(XQContentCell *cell) {
        cell.valueField.text = txt;
    }];
    
//    NSNumber *heightValue = [self.cachedHeightDict objectForKey:txt];
//    
//    if (heightValue) {
//        return [heightValue floatValue];
//    }
//    
//    CGSize size = [txt sizeInLabelWithMaxWidth:_maxWidth font:[UIFont systemFontOfSize:16.0] numberOfLines:0];
//    
//    CGFloat txtH = size.height;
//    if (txtH < 21) {
//        txtH = 21;
//    }
//    
//    CGFloat height = 43-21 + txtH + 1;
//    [self.cachedHeightDict setObject:@(height) forKey:txt];
//    
//    return height;
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

- (NSMutableDictionary *)cachedHeightDict {
    if (!_cachedHeightDict) {
        _cachedHeightDict = [NSMutableDictionary dictionary];
    }
    return _cachedHeightDict;
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
            int tmp = arc4random() % (self.totalTexts.length - 1);
            sleep(0.1);
            
            if (tmp < 5) {
                tmp = 5;
            }
            
            NSString *tmpStr = [self.totalTexts substringToIndex:tmp];
            
            CGSize size = [tmpStr sizeInLabelWithMaxWidth:_maxWidth font:[UIFont systemFontOfSize:16.0] numberOfLines:0];
            
            CGFloat txtH = size.height;
            if (txtH < 21) {
                txtH = 21;
            }
            
            CGFloat height = 43-21 + txtH + 1;
            [self.cachedHeightDict setObject:@(height) forKey:tmpStr];
            
            [self.items insertObject:tmpStr atIndex:0];
            
            [indexPaths addObject:[NSIndexPath indexPathForRow:i + offset inSection:0]];
        }
        
        CGSize beforeContentSize = self.tableview.contentSize;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
            
            CGRect frame = [self.tableview rectForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:20]];
            
            CGSize afterContentSize = self.tableview.contentSize;
            CGPoint afterContentOffset = self.tableview.contentOffset;
            CGPoint newContentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height);
            
//            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
//            [self.tableview scrollRectToVisible:frame animated:NO];
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
