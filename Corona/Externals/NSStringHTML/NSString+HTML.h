//
//  NSString+HTML.h
//  DTCoreText
//
//  Created by Oliver Drobnik on 1/9/11.
//  Copyright 2011 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Methods for making HTML strings easier and quicker to handle. 
 */
@interface NSString (HTML)

/** 
 Convert a string into a proper HTML string by converting special characters into HTML entities. For example: an ellipsis `…` is represented by the entity `&hellip;` in order to display it correctly across text encodings. 
 @returns A string containing HTML that now uses proper HTML entities. 
 */
- (NSString *)stringByAddingHTMLEntities;


/** 
 Convert a string from HTML entities into correct character representations using UTF8 encoding. For example: an ellipsis entity representy by `&hellip;` is converted into `…`. 
 @returns A string without HTML entities, instead having the actual characters formerly represented by HTML entities. 
 */
- (NSString *)stringByReplacingHTMLEntities;


@end
