//
//  PrivateUtils.m
//
//  Copyright (c) 2015 Andrey Fidrya
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "PrivateUtils.h"

@implementation PrivateUtils

+ (BOOL)debug {
#ifdef DEBUG
    return YES;
#else
    return NO;
#endif
}

#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
UIImage *_UICreateScreenUIImage();
#pragma clang diagnostic pop
#endif

#ifdef DEBUG
+ (UIImage *)rotateImage:(UIImage *)sourceImage clockwise:(BOOL)clockwise
{
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.height, size.width), YES, sourceImage.scale);
    [[UIImage imageWithCGImage:[sourceImage CGImage]
                         scale:1.0
                   orientation:clockwise ? UIImageOrientationRight : UIImageOrientationLeft]
     drawInRect:CGRectMake(0,0,size.height ,size.width)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
#endif

+ (UIImage *)takeScreenshot {
#ifdef DEBUG
    UIImage *image = _UICreateScreenUIImage();
    switch ([UIApplication sharedApplication].statusBarOrientation) {
    case UIInterfaceOrientationLandscapeLeft:
        return [[self class] rotateImage: image clockwise: YES];
    case UIInterfaceOrientationLandscapeRight:
        return [[self class] rotateImage: image clockwise: NO];
    default:
        break;
    }
    return image;
#else
    return nil;
#endif
}

// http://stackoverflow.com/questions/12650137/how-to-change-the-device-orientation-programmatically-in-ios-6
+ (void)forceOrientation:(int)orientation
{
#ifdef DEBUG
    NSNumber *value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
#endif
}

@end
