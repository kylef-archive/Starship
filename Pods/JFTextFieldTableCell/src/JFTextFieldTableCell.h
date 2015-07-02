//
//  JFTextFieldTableCell.h
//  Picks
//
//  Created by Joe Fabisevich on 3/23/14.
//  Copyright (c) 2014 Snarkbots. All rights reserved.
//

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
#pragma mark - JFTextField

/**
 This subclass exists only to override canPerformAction:withSender:
 */
@interface JFTextField : UITextField

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - JFTextFieldTableCell Interface

@interface JFTextFieldTableCell : UITableViewCell
<
    UITextFieldDelegate
>

@property (readonly) JFTextField *textField;
@property UIEdgeInsets textFieldInsets;

@property CGFloat leftViewWidth;
@property CGFloat maxCharacterCount;

@property (nonatomic) UIButton *actionButton;

@property BOOL showsEditingStateAnimation;
@property UIColor *indicatorColor;
@property (nonatomic) BOOL canPerformSystemEditingActions;

@property (nonatomic, copy) BOOL (^textFieldShouldBeginEditing)(UITextField *textField);
@property (nonatomic, copy) BOOL (^textFieldShouldEndEditing)(UITextField *textField);
@property (nonatomic, copy) void (^textFieldDidBeginEditing)(UITextField *textField);
@property (nonatomic, copy) void (^textFieldDidEndEditing)(UITextField *textField);
@property (nonatomic, copy) BOOL (^textFieldShouldReturn)(UITextField *textField);
@property (nonatomic, copy) BOOL (^textFieldShouldClear)(UITextField *textField);
@property (nonatomic, copy) void (^textFieldTextDidChange)(UITextField *textField);

- (void)flashIndicatorViewWithColor:(UIColor *)color;

@end
