//
//  TableView.m
//  SubEthaEdit
//
//  Created by Dominik Wagner on 14.10.04.
//  Copyright (c) 2004 TheCodingMonkeys. All rights reserved.
//

#import "TableView.h"


@implementation TableView
-(void)setLightBackgroundColor:(NSColor *)aColor {
    [I_lightBackgroundColor autorelease];
     I_lightBackgroundColor=[aColor retain];
}

-(void)setDarkBackgroundColor:(NSColor *)aColor {
    [I_darkBackgroundColor autorelease];
     I_darkBackgroundColor=[aColor retain];
}

-(void)setDisableFirstRow:(BOOL)aFlag {
    I_disableFirstRow=aFlag;
    [self setNeedsDisplay:YES];
}


- (void)drawBackgroundInClipRect:(NSRect)clipRect {
    [I_lightBackgroundColor set];
    NSRectFill([self rectOfColumn:0]);
    [I_darkBackgroundColor set];
    NSRectFill([self rectOfColumn:1]);
    if (I_disableFirstRow) {
        NSRect rowRect=[self rectOfRow:0];
        rowRect=NSIntersectionRect(clipRect,rowRect);
        if (rowRect.size.height>0. || rowRect.size.width >0.) {
            [[NSColor colorWithCalibratedWhite:.5 alpha:.3] set];
            [NSBezierPath fillRect:rowRect];
        }
    }
}

// Focus Ring methods

- (void)highlightWithColor:(NSColor *)aColor inset:(float)aInset {
    if ([self selectedRow]>=0) {

        NSMutableIndexSet *rows = [[[self selectedRowIndexes] mutableCopy] autorelease];
    
        int index;
        int fromindex = -42;
        int lastindex = -42;
        
        while ((index = [rows firstIndex]) != NSNotFound) {
            [rows removeIndex:[rows firstIndex]];
            
            if (lastindex != index-1) {  
                
                [NSGraphicsContext saveGraphicsState];
                NSSetFocusRingStyle (NSFocusRingOnly);
                [[NSBezierPath bezierPathWithRect:NSUnionRect(NSInsetRect([self rectOfRow:fromindex],aInset,aInset),NSInsetRect([self rectOfRow:lastindex],aInset,aInset))] fill];
                [NSGraphicsContext restoreGraphicsState];
        
                fromindex = index;
            } 
            
            lastindex = index;
        }
        
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle (NSFocusRingOnly);
        [[NSBezierPath bezierPathWithRect:NSUnionRect(NSInsetRect([self rectOfRow:fromindex],aInset,aInset),NSInsetRect([self rectOfRow:lastindex],aInset,aInset))] fill];
        [NSGraphicsContext restoreGraphicsState];
    }
    [self setFocusRingType:NSFocusRingTypeNone];
}

- (void)highlightSelectionInClipRect:(NSRect)clipRect {
}

- (void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend {
    [super selectRowIndexes:indexes byExtendingSelection:extend];
    [self setNeedsDisplay:YES];
}

- (void)deselectRow:(int)rowIndex {
    [super deselectRow:rowIndex];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)aRect {
    [super drawRect:aRect];
    [self highlightWithColor:nil inset:1.];
}

@end
