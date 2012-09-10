/*
 * AppController.j
 * NewApplication
 *
 * Created by You on November 16, 2011.
 * Copyright 2011, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>


@implementation AppController : CPObject
{
	CPSplitView verticalSplitter;
	CPCollectionView personsCollection;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
      contentView = [theWindow contentView];

  /*var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];

  [label setStringValue:@"Hello World!"];
  [label setFont:[CPFont boldSystemFontOfSize:24.0]];

  [label sizeToFit];

  [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
  [label setCenter:[contentView center]];

  [contentView addSubview:label];*/

	/*var button = [[CPButton alloc] initWithFrame: CGRectMake(0, 0, 40, 18)]; 
	[button setTitle:"view1"]; 
	[button setTarget:self]; 
	[button setAction:@selector(showAlert:)]; 
	[contentView addSubview:button];*/

	var tabView = [[CPTabView alloc] initWithFrame: CGRectMake(
					10,
					10,
					CGRectGetWidth([contentView bounds]) - 20,
					CGRectGetHeight([contentView bounds]) - 20
				 )];


	[tabView setTabViewType:CPTopTabsBezelBorder];

	/* CPViewMinXMargin CPViewMaxXMargin */
	[tabView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];

	[contentView addSubview:tabView];
								
	var tabViewItem1 = [[CPTabViewItem alloc] initWithIdentifier:@"tabViewItem1"];
	[tabViewItem1 setLabel:@"First Tab"];
	
	var view1 = [[CPView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
	//[tabViewItem1 setView:view1];
	
	verticalSplitter = [[CPSplitView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([view1 bounds]), CGRectGetHeight([view1 bounds]))];
	[verticalSplitter setDelegate:self];
	[verticalSplitter setVertical:YES]; 
	[verticalSplitter setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ]; 
	//[view1 addSubview:verticalSplitter];
	[tabViewItem1 setView:verticalSplitter];

	var leftView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 200, CGRectGetHeight([verticalSplitter bounds]))];
	[leftView setAutoresizingMask:CPViewHeightSizable ]; 
	var rightView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([verticalSplitter bounds]) - 200, CGRectGetHeight([verticalSplitter bounds]))];
	[rightView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ]; 

	[verticalSplitter addSubview:leftView];
	[verticalSplitter addSubview:rightView];

	personsCollection = [[CPCollectionView alloc] initWithFrame:CGRectMake(0, 0, 200, CGRectGetHeight([verticalSplitter bounds]))];
	//[leftView addSubView:personsCollection];

	/*var button = [[CPButton alloc] initWithFrame: CGRectMake(10, 10, 150, 24)];
	[button setTitle:"test"];
	[button setTarget:self];
	[button setAction:@selector(test:)];                
				  
	[view1 addSubview:button];*/

	
	var tabViewItem2 = [[CPTabViewItem alloc] initWithIdentifier:@"tabViewItem2"];
	[tabViewItem2 setLabel:@"Second Tab"];

	var view2 = [[CPView alloc] initWithFrame: CGRectMake(0, 0, 50, 50)];
	[tabViewItem2 setView:view2];



	[tabView addTabViewItem:tabViewItem1];
	[tabView addTabViewItem:tabViewItem2];

	[tabView selectFirstTabViewItem:self];

  [theWindow orderFront:self];

  // Uncomment the following line to turn on the standard menu bar.
  //[CPMenu setMenuBarVisible:YES];
}

-(void)test:(id)sender
{
	var request = [CPURLRequest requestWithURL:"http://localhost:5000/persons"];
	var response;
	var error;

	debugger;
	
	// For now response and error are not used
	var data = [CPURLConnection sendSynchronousRequest:request returningResponse:response error:error];
	/*
	if ([response statusCode] == 200)
	{
		var text = [data string];
		
		console.log([data string]);
		
		CPLog.warn(text);
		CPLog.trace(text);
	}
	*/
	if (data != nil)
	{
		var text = [data string];
		
		console.log([data string]);
		
		CPLog.trace(text);
	}
}

-(void)showAlert:(id)sender
{
	var alert = [[CPAlert alloc] init];
	[alert setMessageText:@"My new alert"];
	[alert setDelegate:self];
	[alert setAlertStyle:CPWarningAlertStyle];
	[alert addButtonWithTitle:@"OK"]
	[alert addButtonWithTitle:@"Cancel"]
	[alert runModal];
}

@end
