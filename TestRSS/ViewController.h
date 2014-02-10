//
//  ViewController.h
//  TestRSS
//
//  Created by Daljeet Singh on 2/8/14.
//  Copyright (c) 2014 Daljeet Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
@interface ViewController : UIViewController<MWFeedParserDelegate>
{
    MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
    
}
@end
