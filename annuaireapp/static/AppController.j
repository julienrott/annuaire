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
	CPArray persons;
	CPTableView tableView;
	CPView popup;
	CPButton btnCancel;
	CPButton btnSave;
	CPTextField prenom;
	CPTextField nom;
	var selectedPerson;
}

- (id)init
{
	if(self = [super init])
	{
		objs = [];
		objsToDisplay = [];
		[self getList];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
      contentView = [theWindow contentView];

	// create a CPScrollView that will contain the CPTableView
  //var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 10.0, 600.0, 200.0)];
	var scrollView = [[CPScrollView alloc] initWithFrame:[contentView bounds]];
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

  // create the CPTableView
  tableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
  [tableView setDataSource:self];
	[tableView setDelegate:self];
  [tableView setUsesAlternatingRowBackgroundColors:YES];
  
  // define the header color
  //var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"button-bezel-center.png"]]];
  
  //[[tableView cornerView] setBackgroundColor:headerColor];
  
  // add the first column
  var column = [[CPTableColumn alloc] initWithIdentifier:@"prenom"];
  [[column headerView] setStringValue:"Prénom"];
  //[[column headerView] setBackgroundColor:headerColor];
  //[column setWidth:125.0];
  [tableView addTableColumn:column];

  // add the second column
  var column = [[CPTableColumn alloc] initWithIdentifier:@"nom"];
  [[column headerView] setStringValue:"Nom"];
  //[[column headerView] setBackgroundColor:headerColor];
  //[column setWidth:825.0];
  [tableView addTableColumn:column];

  // add the third column
  var column = [[CPTableColumn alloc] initWithIdentifier:@"team"];
  [[column headerView] setStringValue:"Team"];
  //[[column headerView] setBackgroundColor:headerColor];
  //[column setWidth:825.0];
  [tableView addTableColumn:column];

  [scrollView setDocumentView:tableView];

	//create popup
	popup = [[CPView alloc] initWithFrame:CGRectMake(5.0, 5.0, 300.0, 100.0)];
	[popup setHidden:YES];
	[popup setBackgroundColor:[CPColor whiteColor]];

	prenom = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 10.0, 200.0, 30.0)];
  [prenom setEditable:YES];
  [prenom setBordered:YES];
  [prenom setBezeled:YES];
  [prenom setFont:[CPFont systemFontOfSize:12.0]];
  [prenom setTarget:self];
  [popup addSubview:prenom];

	nom = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 40.0, 200.0, 30.0)];
  [nom setEditable:YES];
  [nom setBordered:YES];
  [nom setBezeled:YES];
  [nom setFont:[CPFont systemFontOfSize:12.0]];
  [nom setTarget:self];
  [popup addSubview:nom];

  /*var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
	[label setStringValue:@"Hello World!"];
  [label setFont:[CPFont boldSystemFontOfSize:24.0]];
  [label sizeToFit];
  [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
  [label setCenter:[popup center]];
  [popup addSubview:label];*/

	btnCancel = [[CPButton alloc] initWithFrame: CGRectMake(10, 70, 60, 24)];
	[btnCancel setTitle:"annuler"];
	[btnCancel setTarget:self];
	[btnCancel setAction:@selector(test:)];
  [popup addSubview:btnCancel];

	btnSave = [[CPButton alloc] initWithFrame: CGRectMake(75, 70, 80, 24)];
	[btnSave setTitle:"enregistrer"];
	[btnSave setTarget:self];
	[btnSave setAction:@selector(updatePerson:)];
  [popup addSubview:btnSave];

	btnAddToTeam = [[CPButton alloc] initWithFrame: CGRectMake(160, 70, 100, 24)];
	[btnAddToTeam setTitle:"add to team"];
	[btnAddToTeam setTarget:self];
	[btnAddToTeam setAction:@selector(addToTeam:)];
  [popup addSubview:btnAddToTeam];

  //[contentView addSubview:searchField];
  [contentView addSubview:scrollView];
  [contentView addSubview:popup];

	[theWindow orderFront:self];
}

-(void)updatePerson:(id)sender
{
	var request = [CPURLRequest requestWithURL:"/persons/" + [selectedPerson objectForKey:@"id"]];
	[request setHTTPMethod:@"PUT"];
	[request setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:@"firstName=" + [prenom stringValue] + "&lastName=" + [nom stringValue]];
	[[CPURLConnection alloc] initWithRequest:request delegate:self];
	[popup setHidden:YES];
}

-(void)test:(id)sender
{
	if([popup isHidden])
		[popup setHidden:NO];
	else
		[popup setHidden:YES];
}

- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
  return [persons count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
  if ([tableColumn identifier]===@"prenom")
    return [persons[row] objectForKey:@"firstname"];
  else if ([tableColumn identifier]===@"nom")
  	return [persons[row] objectForKey:@"lastname"];
  else 
	{
		//the popupmenu
		/*var popUpButton  = [[CPPopUpButton alloc] initWithFrame: CGRectMake(0, 0, 200.0, 24.0) pullsDown:YES];
		[[popUpButton menu] setTitle:@"mytitle"];
		[popUpButton setTarget:self];
		[popUpButton setAction:@selector(doMenu:)];
		[popUpButton addItemsWithTitles: [CPArray arrayWithObjects:
				            @"Add to team",
				            @"Action 1",
				            @"Action 2",
				            @"Action 3",
				            nil]
		];*/
		/*var mi = [[CPMenuItem alloc] init];
		[mi setTitle:"menu1"];
		[mi setTarget:self];
		//[mi setAction:@selector(doMenu:)];
		[popUpButton addItem:mi];
		var mi = [[CPMenuItem alloc] init];
		[mi setTitle:"menu2"];
		[mi setTarget:self];
		//[mi setAction:@selector(menuDidChangeItem:)];
		[popUpButton addItem:mi];
		[popUpButton setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin];*/
		//[popUpButton sizeToFit];
		//[contentView addSubview:popUpButton];
  	//return [persons[row] objectForKey:@"lastname"];
		//return popUpButton;

		/*var buttonsView = [[CPCollectionView alloc] initWithFrame: CGRectMake(0, 0, 400.0, 25.0)];
		var b1 = [[CPButton alloc] initWithFrame: CGRectMake(0, 0, 100.0, 24.0)];
		[b1 setTitle:"team1"];
		[b1 setTarget:self];
		[b1 setAction:@selector(doMenu:)];
		[buttonsView addSubview:b1];

		//[tableColumn setDataView:popUpButton];
		[tableColumn setDataView:buttonsView];*/
	}
}

-(void)addToTeam:(id)sender
{
	//var request = [CPURLRequest requestWithURL:"/persons/addToTeam/" + [selectedPerson objectForKey:@"id"] + "?idTeam=1"];
	var request = [CPURLRequest requestWithURL:"/persons/addToTeam/" + [selectedPerson objectForKey:@"id"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:@"idTeam=1"];
	[[CPURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)menuDidChangeItem:(CPNotification) notif
{
	console.info("menuDidChangeItem");
}

- (void)tableViewSelectionDidChange:(CPNotification *)notif
{
  row = [[[notif object] selectedRowIndexes] firstIndex];
	selectedPerson = persons[row];
	[prenom setStringValue:[selectedPerson objectForKey:@"firstname"]];
	[nom setStringValue:[selectedPerson objectForKey:@"lastname"]];
	[popup setHidden:NO];
}

- (void)getList
{
	var request = [CPURLRequest requestWithURL:"/persons"];
	[[CPURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data
{
	console.info('didReceiveData connection:' + aConnection + ' data:' + data);
	if (data)
	{
		persons = [];
		var JSONLists = CPJSObjectCreateWithJSON(data);
		// loop through everything and create a dictionary in place of the JSObject adding it to the array
		for (var i = 0; i < JSONLists.persons.length; i++)
		    persons[i] = [CPDictionary dictionaryWithJSObject:JSONLists.persons[i] recursively:YES];
	 
		[tableView reloadData]
	}
	else
	{
		[self getList]
	}
}

- (void)connection:(CPURLConnection)aConnection didFailWithError:(CPString)error
{
    alert(error) ;
}

- (CPInteger) clickedRow
{
	console.info(1)
}

@end
