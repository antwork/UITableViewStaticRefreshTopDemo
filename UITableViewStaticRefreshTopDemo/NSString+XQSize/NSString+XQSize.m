//
//  NSString+XQSize.m
//  TBDemo
//
//  Created by Bill on 15/11/9.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "NSString+XQSize.h"

static UITextView *textView;

static UILabel *label;

@implementation NSString (XQSize)

/**
 *  计算UITextView中的文字显示区域大小,不限制行数
 *
 *  @param maxWidth 最大宽度,如果为0,则宽度不限,使用最大宽度,只有一行文字
 *  @param font     字体
 *
 *  @return 文字显示区域大小
 */
- (CGSize)sizeInTextViewWithMaxWidth:(CGFloat)maxWidth
                                font:(UIFont *)font {
     NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    return [attrString sizeInTextViewWithMaxWidth:maxWidth];
}

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
                    numberOfLines:(NSInteger)numberOfLines {
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    return [attrString sizeInLabelWithMaxWidth:maxWidth numberOfLines:numberOfLines];
}

@end

@implementation NSAttributedString (XQSize)

/**
 *  计算UITextView中的文字显示区域大小
 *
 *  @param maxWidth 最大宽度,如果为0,则宽度不限,使用最大宽度,只有一行文字
 *
 *  @return 文字显示区域大小
 */
- (CGSize)sizeInTextViewWithMaxWidth:(CGFloat)maxWidth {
    return [self sizeWithMaxWidth:maxWidth useLabel:false numberOfLines:0];
}

/**
 *  计算UILabel中的文字显示区域大小
 *
 *  @param maxWidth      最大宽度,如果为0,则宽度不限,使用最大宽度,只有一行文字
 *  @param numberOfLines 文字行数,0为不限制行数
 *
 *  @return 文字显示区域大小
 */
- (CGSize)sizeInLabelWithMaxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)numberOfLines {
    return [self sizeWithMaxWidth:maxWidth useLabel:YES numberOfLines:numberOfLines];
}

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth useLabel:(BOOL)useLabel numberOfLines:(NSInteger)numberOfLines {
    CGSize opSize = CGSizeZero;
    
    if (maxWidth == 0) {
        opSize.width = CGFLOAT_MAX;
        opSize.height = CGFLOAT_MAX;
        CGRect expectedLabelSize = [self boundingRectWithSize:opSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil];
        return expectedLabelSize.size;
    } else {
        if (useLabel) {
            if (!label) {
                label = [[UILabel alloc] init];
                label.lineBreakMode = NSLineBreakByCharWrapping;
            }
            label.numberOfLines = numberOfLines;
            label.frame = CGRectMake(0, 0, maxWidth, 1);
            label.attributedText = self;
            CGSize contentSize = [label sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
            
            return contentSize;
        } else {
            if (!textView) {
                textView = [[UITextView alloc] init];
            }
            
            
            textView.frame = CGRectMake(0, 0, maxWidth, 1);
            textView.attributedText = self;
            CGSize contentSize = [textView sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
            
            return contentSize;
        }
    }
}

@end


