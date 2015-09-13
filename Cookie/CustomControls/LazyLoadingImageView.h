//
//  LazyLoadingImageView.h
//  Cookie
//
//  Created by Kaustubh on 13/09/15.
//  Copyright (c) 2015 Default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LazyLoadingImageView : UIImageView

- (id)initWithImageUrlString:(NSString*)urlString;
-(void)setURLString:(NSString*)urlstr;
-(void)setImageReference:(NSString*)reference;

@end
