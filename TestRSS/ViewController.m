//
//  ViewController.m
//  TestRSS
//
//  Created by Daljeet Singh on 2/8/14.
//  Copyright (c) 2014 Daljeet Singh. All rights reserved.
//
// http://static.livetecha.com/abc.php
// http://www.diabetes-kids.de/index.php?option=com_content&view=category&layout=blog&id=142&Itemid=368&format=feed&type=rss

#import "ViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title=@"loading";
    formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems=[[NSMutableArray alloc]init];
    itemsToDisplay=[[NSArray alloc]init];
    
    
        NSURL *feedURL=[NSURL URLWithString:@"feed://feeds.bbci.co.uk/news/rss.xml"];
        feedParser=[[MWFeedParser alloc]initWithFeedURL:feedURL];
        feedParser.delegate=self;
        feedParser.feedParseType=ParseTypeFull;
        feedParser.connectionType =ConnectionTypeAsynchronously;
        [feedParser parse];
        
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
	self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

- (void)updateTableWithParsedItems {
	itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
                      [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                           ascending:NO]]];
    NSLog(@"itemsToDisplay %@",itemsToDisplay);
    [self titledisplay];
}
-(void)titledisplay
{
    MWFeedItem *item = [itemsToDisplay objectAtIndex:0];
	if (item) {
        
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
        
        
		NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
        
        
        NSMutableString *subtitle = [NSMutableString string];
		if (item.date) [subtitle appendFormat:@"%@: ", [formatter stringFromDate:item.date]];
        UILabel*titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 55, 300, 46)];
        titlelabel.text=[NSString stringWithFormat:@"%@",itemTitle];
        [titlelabel setFont:[UIFont systemFontOfSize:23]];
        [titlelabel setNumberOfLines:2];
        [titlelabel setBackgroundColor:[UIColor clearColor]];
        [self.view  addSubview:titlelabel];
        
        
        UILabel*datelabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 105,300, 35)];
        datelabel.text=[NSString stringWithFormat:@"%@",subtitle];
        [datelabel setBackgroundColor:[UIColor clearColor]];
        [datelabel setFont:[UIFont systemFontOfSize:20]];
        [self.view addSubview:datelabel];
        
        
        UITextView *titleview=[[UITextView alloc]initWithFrame:CGRectMake(10, 135, 300, 250)];
        titleview.text=[NSString stringWithFormat:@"%@",itemSummary];
        [titleview setBackgroundColor:[UIColor clearColor]];
        [titleview setUserInteractionEnabled:NO];
        [titleview setFont:[UIFont fontWithName:@"ArialMT" size:18]];
        [titleview setScrollEnabled:NO];
        [self.view addSubview:titleview];
    }
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                       message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                      delegate:nil
                                             cancelButtonTitle:@"Dismiss"
                                             otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
