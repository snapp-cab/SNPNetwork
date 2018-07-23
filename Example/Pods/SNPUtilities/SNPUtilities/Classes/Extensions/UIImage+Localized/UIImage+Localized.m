//
//  UIImage+Localized.m
//  Snapp
//
//  Created by Ali RP on 02/02/2016.
//  Copyright © 2016 Snapp. All rights reserved.
//

#import "UIImage+Localized.h"

@implementation UIImage (Localized)
+ (UIImage *)localizedImageWithName:(NSString *)name {
    int scale = [[UIScreen mainScreen] scale];
    NSString *path;
    if (scale == 1 || scale == 2) {
        path = [NSString stringWithFormat:@"%@@2x",name];
    }else {
        path = [NSString stringWithFormat:@"%@@3x",name];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]];
    return image ? image : [UIImage imageNamed:name];
}
@end
