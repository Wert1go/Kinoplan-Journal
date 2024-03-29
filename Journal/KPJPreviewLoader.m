//
// Created by Виктор Шаманов on 2/20/14.
// Copyright (c) 2014 Applifto. All rights reserved.
//

#import "KPJPreviewLoader.h"
#import "CGPDFDocument.h"

static CGFloat const kDefaultWidth = 600.0;
static CGFloat const kDefaultHeight = 800.0;

@implementation KPJPreviewLoader

+ (void)generatePreviewForDocumentAtPath:(NSString *)path {
    [self generatePreviewForDocumentAtPath:path withSize:CGSizeMake(kDefaultWidth, kDefaultHeight)];
}

+ (void)generatePreviewForDocumentAtPath:(NSString *)path withSize:(CGSize)imageSize {
    NSInteger page = 1;

    CGImageRef imageRef = NULL;
    NSURL *fileURL = [NSURL fileURLWithPath:path];

    CGPDFDocumentRef thePDFDocRef = CGPDFDocumentCreateX((__bridge CFURLRef)fileURL, nil);

    if (thePDFDocRef != NULL) // Check for non-NULL CGPDFDocumentRef
    {
        CGPDFPageRef thePDFPageRef = CGPDFDocumentGetPage(thePDFDocRef, page);

        if (thePDFPageRef != NULL) // Check for non-NULL CGPDFPageRef
        {
            CGFloat thumb_w = imageSize.width; // Maximum thumb width
            CGFloat thumb_h = imageSize.height; // Maximum thumb height

            CGRect cropBoxRect = CGPDFPageGetBoxRect(thePDFPageRef, kCGPDFCropBox);
            CGRect mediaBoxRect = CGPDFPageGetBoxRect(thePDFPageRef, kCGPDFMediaBox);
            CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);

            NSInteger pageRotate = CGPDFPageGetRotationAngle(thePDFPageRef); // Angle

            CGFloat page_w = 0.0f; CGFloat page_h = 0.0f; // Rotated page size

            switch (pageRotate) // Page rotation (in degrees)
            {
                default: // Default case
                case 0: case 180: // 0 and 180 degrees
                {
                    page_w = effectiveRect.size.width;
                    page_h = effectiveRect.size.height;
                    break;
                }

                case 90: case 270: // 90 and 270 degrees
                {
                    page_h = effectiveRect.size.width;
                    page_w = effectiveRect.size.height;
                    break;
                }
            }

            CGFloat scale_w = (thumb_w / page_w); // Width scale
            CGFloat scale_h = (thumb_h / page_h); // Height scale

            CGFloat scale = 0.0f; // Page to target thumb size scale

            if (page_h > page_w)
                scale = ((thumb_h > thumb_w) ? scale_w : scale_h); // Portrait
            else
                scale = ((thumb_h < thumb_w) ? scale_h : scale_w); // Landscape

            NSInteger target_w = (page_w * scale); // Integer target thumb width
            NSInteger target_h = (page_h * scale); // Integer target thumb height

            if (target_w % 2) target_w--; if (target_h % 2) target_h--; // Even

            target_w *= scale;
            target_h *= scale; // Screen scale

            CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB(); // RGB color space

            CGBitmapInfo bmi = (kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);

            CGContextRef context = CGBitmapContextCreate(NULL, target_w, target_h, 8, 0, rgb, bmi);

            if (context != NULL) // Must have a valid custom CGBitmap context to draw into
            {
                CGRect thumbRect = CGRectMake(0.0f, 0.0f, target_w, target_h); // Target thumb rect

                CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); CGContextFillRect(context, thumbRect); // White fill

                CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(thePDFPageRef, kCGPDFCropBox, thumbRect, 0, true)); // Fit rect

                //CGContextSetRenderingIntent(context, kCGRenderingIntentDefault); CGContextSetInterpolationQuality(context, kCGInterpolationDefault);

                CGContextDrawPDFPage(context, thePDFPageRef); // Render the PDF page into the custom CGBitmap context

                imageRef = CGBitmapContextCreateImage(context); // Create CGImage from custom CGBitmap context

                CGContextRelease(context); // Release custom CGBitmap context reference
            }

            CGColorSpaceRelease(rgb); // Release device RGB color space reference
        }

        CGPDFDocumentRelease(thePDFDocRef); // Release CGPDFDocumentRef reference
    }

    if (imageRef != NULL) // Create UIImage from CGImage and show it, then save thumb as PNG
    {
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationUp];

        [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@.png", path]
                                                contents:UIImagePNGRepresentation(image)
                                              attributes:nil];


        //        [[ReaderThumbCache sharedInstance] setObject:image forKey:request.cacheKey]; // Update cache
        //
        //        if (self.isCancelled == NO) // Show the image in the target thumb view on the main thread
        //        {
        //            ReaderThumbView *thumbView = request.thumbView; // Target thumb view for image show
        //
        //            NSUInteger targetTag = request.targetTag; // Target reference tag for image show
        //
        //            dispatch_async(dispatch_get_main_queue(), // Queue image show on main thread
        //                    ^{
        //                        if (thumbView.targetTag == targetTag) [thumbView showImage:image];
        //                    });
        //        }
        //
        //        CFURLRef thumbURL = (__bridge CFURLRef)[self thumbFileURL]; // Thumb cache path with PNG file name URL
        //
        //        CGImageDestinationRef thumbRef = CGImageDestinationCreateWithURL(thumbURL, (CFStringRef)@"public.png", 1, NULL);
        //
        //        if (thumbRef != NULL) // Write the thumb image file out to the thumb cache directory
        //        {
        //            CGImageDestinationAddImage(thumbRef, imageRef, NULL); // Add the image
        //
        //            CGImageDestinationFinalize(thumbRef); // Finalize the image file
        //
        //            CFRelease(thumbRef); // Release CGImageDestination reference
        //        }
        //
        //        CGImageRelease(imageRef); // Release CGImage reference
    }
    else // No image - so remove the placeholder object from the cache
    {
        //        [[ReaderThumbCache sharedInstance] removeNullForKey:request.cacheKey];
    }

    //    request.thumbView.operation = nil; // Break retain loop
}

+ (NSString *)previewPathForDocumentAtPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@.png", path];
}

@end