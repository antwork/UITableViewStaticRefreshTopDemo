//
//  NSString+XQSize.h
//  TBDemo
//
//  Created by Bill on 15/11/9.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (XQSize)

/**
 *  计算UITextView中的文字显示区域大小,不限制行数
 *
 *  @param maxWidth 最大宽度,如果为0,则宽度不限,使用最大宽度,只有一行文字
 *  @param font     字体
 *
 *  @return 文字显示区域大小
 */
- (CGSize)sizeInTextViewWithMaxWidth:(CGFloat)maxWidth
                                font:(UIFont *)font;

/**
 *  计算UILabel中的文字显示区域大小
 *
 *  @param maxWidth      最大宽度,如果为0,则宽度不限,使用最大宽度,只有一行文字
 *  @param font          字体
 *  @param numberOfLines 文字行数,0为不限制行数
 *
 *  @return 文字显示区域大小
 */
- (CGSize)sizeInLabelWithMaxWidth:(CGFloat)maxWidth
                             font:(UIFont *)font
                    numberOfLines:(NSInteger)numberOfLines;

@end


@interface NSAttributedString (XQSize)

/**
 *  计算UITextView中的文字显示区域大小
 *
 *  @param maxWidth 最大宽度,如果为0,则宽度不限,使用最大宽度,只有一行文字
 *
 *  @return 文字显示区域大小
 */
- (CGSize)sizeInTextViewWithMaxWidth:(CGFloat)maxWidth;

/**
 *  计算UILabel中的文字显示区域大小
 *
 *  @param maxWidth      最大宽度,如果为0,则宽度不限,使用最大宽度,只有一行文字
 *  @param numberOfLines 文字行数,0为不限制行数
 *
 *  @return 文字显示区域大小
 */
- (CGSize)sizeInLabelWithMaxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)numberOfLines;

@end
