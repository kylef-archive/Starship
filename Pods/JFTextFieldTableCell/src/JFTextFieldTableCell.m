//
//  JFTextFieldTableCell.m
//  Picks
//
//  Created by Joe Fabisevich on 3/23/14.
//  Copyright (c) 2014 Snarkbots. All rights reserved.
//

#import "JFTextFieldTableCell.h"


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

CGFloat const JFTextFieldTableCellLeftViewWidth = 15.0f;


////////////////////////////////////////////////////////////////////////////////
#pragma mark - JFTextField Interface

@interface JFTextField ()

@property BOOL canPerformSystemEditingActions;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface JFTextFieldTableCell ()

@property (readwrite) JFTextField *textField;

@property (nonatomic, copy) void (^nextTextFieldBlock)(UITextField *);
@property (nonatomic, copy) void (^textFieldBeganEditingBlock)(UITextField *);

@property UIView *editStateIndicatorView;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation JFTextFieldTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Layout subviews

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat const left = CGRectGetMinX(self.contentView.bounds)+self.textFieldInsets.left;
    CGFloat const top = CGRectGetMinY(self.contentView.bounds)+self.textFieldInsets.top;
    CGFloat const width = CGRectGetWidth(self.contentView.bounds)-CGRectGetWidth(self.actionButton.frame)-self.textFieldInsets.left-self.textFieldInsets.right;
    CGFloat const height = CGRectGetHeight(self.contentView.bounds)-self.textFieldInsets.top-self.textFieldInsets.bottom;
    
    self.textField.frame = CGRectMake(left, top, width, height);
    if (CGRectEqualToRect(self.textField.leftView.frame, CGRectZero))
    {
        self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _leftViewWidth, CGRectGetHeight(self.textField.frame))];
    }

    self.editStateIndicatorView.frame = CGRectMake(0, 0, _leftViewWidth/3, CGRectGetHeight(self.textField.frame));
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup

- (void)setup
{
    self.layer.opaque = YES;
    self.contentView.layer.opaque = YES;
    self.backgroundView.opaque = YES;

    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsZero;

    _leftViewWidth = JFTextFieldTableCellLeftViewWidth;
    _canPerformSystemEditingActions = YES;
    _maxCharacterCount = 0;

    _textField = [[JFTextField alloc] init];
    _textField.delegate = self;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.textColor = [UIColor blackColor];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:_textField];

    _editStateIndicatorView = [[UIView alloc] init];
    _editStateIndicatorView.alpha = 0.0f;
    [_textField addSubview:_editStateIndicatorView];

    _actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.contentView addSubview:_actionButton];

    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mutators

- (void)setActionButton:(UIButton *)actionButton
{
    _actionButton = actionButton;
    [self setNeedsLayout];
}

- (void)setCanPerformSystemEditingActions:(BOOL)canPerformSystemEditingActions
{
    _canPerformSystemEditingActions = canPerformSystemEditingActions;
    _textField.canPerformSystemEditingActions = _canPerformSystemEditingActions;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delegation - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.textFieldShouldBeginEditing)
    {
        return self.textFieldShouldBeginEditing(textField);
    }

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.textFieldShouldEndEditing)
    {
        return self.textFieldShouldEndEditing(textField);
    }

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.showsEditingStateAnimation)
    {
        self.editStateIndicatorView.backgroundColor = self.indicatorColor;
        self.editStateIndicatorView.alpha = 0.0f;
        [UIView animateWithDuration:0.4f animations:^{
            self.editStateIndicatorView.alpha = 1.0f;
        }];
    }

    if (self.textFieldDidBeginEditing)
    {
        self.textFieldDidBeginEditing(textField);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.showsEditingStateAnimation)
    {
        self.editStateIndicatorView.alpha = 1.0f;
        [UIView animateWithDuration:0.4f animations:^{
            self.editStateIndicatorView.alpha = 0.0f;
        }];
    }

    if (self.textFieldDidEndEditing)
    {
        self.textFieldDidEndEditing(textField);
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.textFieldShouldClear)
    {
        return self.textFieldShouldClear(textField);
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textFieldShouldReturn)
    {
        return self.textFieldShouldReturn(textField);
    }

    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.textFieldTextDidChange)
    {
        self.textFieldTextDidChange(textField);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.maxCharacterCount == 0)
    {
        return YES;
    }
    else
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > self.maxCharacterCount) ? NO : YES;
    }
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

- (void)flashIndicatorViewWithColor:(UIColor *)color
{
    UIColor *originalBackgroundColor = self.editStateIndicatorView.backgroundColor;
    CGFloat originalAlpha = self.editStateIndicatorView.alpha;

    self.editStateIndicatorView.backgroundColor = color;
    self.editStateIndicatorView.alpha = 0.0f;

    [UIView animateWithDuration:0.55f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAutoreverse animations:^{
        self.editStateIndicatorView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (finished)
        {
            self.editStateIndicatorView.backgroundColor = originalBackgroundColor;
            self.editStateIndicatorView.alpha = originalAlpha;
        }
    }];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Prepare for Reuse

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.textField.text = @"";
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Margins

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - JFTextField

@implementation JFTextField


////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIMenuController

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return _canPerformSystemEditingActions;
}

@end