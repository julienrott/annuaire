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
	CPURLConnection getUsersConnection;
	CPURLConnection updateUserConnection;
	CPURLConnection manageUserTeamConnection;
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

    var column = [[CPTableColumn alloc] initWithIdentifier:@"id"];
    [[column headerView] setStringValue:"ID"];
    //[[column headerView] setBackgroundColor:headerColor];
    [column setWidth:30.0];
    [tableView addTableColumn:column];

    var column = [[CPTableColumn alloc] initWithIdentifier:@"prenom"];
    [[column headerView] setStringValue:"Prénom"];
    //[[column headerView] setBackgroundColor:headerColor];
    //[column setWidth:125.0];
    [tableView addTableColumn:column];

    var column = [[CPTableColumn alloc] initWithIdentifier:@"nom"];
    [[column headerView] setStringValue:"Nom"];
    //[[column headerView] setBackgroundColor:headerColor];
    //[column setWidth:825.0];
    [tableView addTableColumn:column];

    var column = [[CPTableColumn alloc] initWithIdentifier:@"teams"];
    [[column headerView] setStringValue:"Teams"];
    //[[column headerView] setBackgroundColor:headerColor];
    [column setWidth:300.0];
    [tableView addTableColumn:column];

    var column = [[CPTableColumn alloc] initWithIdentifier:@"team"];
    [[column headerView] setStringValue:"Team"];
    //[[column headerView] setBackgroundColor:headerColor];
    [column setWidth:130.0];
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

	/*btnAddToTeam = [[CPButton alloc] initWithFrame: CGRectMake(160, 70, 100, 24)];
	[btnAddToTeam setTitle:"add to team"];
	[btnAddToTeam setTarget:self];
	[btnAddToTeam setAction:@selector(addToTeam:)];
    [popup addSubview:btnAddToTeam];*/

    [contentView addSubview:scrollView];
    [contentView addSubview:popup];

	[theWindow orderFront:self];
}

- (void)updatePerson:(id)sender
{
	var request = [CPURLRequest requestWithURL:"/persons/" + [selectedPerson objectForKey:@"id"] + "/"];
	[request setHTTPMethod:@"PUT"];
	[request setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:@"firstName=" + [prenom stringValue] + "&lastName=" + [nom stringValue]];
	updateUserConnection = [[CPURLConnection alloc] initWithRequest:request delegate:self];
	[popup setHidden:YES];
}

- (void)test:(id)sender
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
    else if ([tableColumn identifier]===@"id")
  	    return [persons[row] objectForKey:@"id"];
    else if ([tableColumn identifier]===@"nom")
  	    return [persons[row] objectForKey:@"lastname"];
    else if ([tableColumn identifier]===@"teams")
    {
        var teamNames = "";
        var teams = [persons[row] objectForKey:@"teams"];
        for (var i = 0; i < teams.length; i++)
        {
            var team = teams[i];
            var teamName = [team objectForKey:@"name"];
            teamNames += teamName;
            if (i < teams.length - 1)
            {
                teamNames += " - ";
            }
        }
  	    return teamNames;
    }
    else 
	{
	    var personId = [persons[row] objectForKey:@"id"];
	    
		var popUpButton  = [[CPPopUpButton alloc] initWithFrame: CGRectMake(0, 0, 200.0, 24.0) pullsDown:YES];
		[popUpButton setTarget:self];
		
		var mi = [[CPMenuItem alloc] init];
		[mi setTitle:@"Manage teams"];
		[popUpButton addItem:mi];
		
		var mi = [[CPMenuItem alloc] init];
		[mi setTag:{row: row, teamId:1}];
		[mi setTitle:@"Manchester"];
		[mi setAction:@selector(menuDidChangeItem:)];
		[popUpButton addItem:mi];
		
		var mi = [[CPMenuItem alloc] init];
		[mi setTag:{row: row, teamId:2}];
		[mi setTitle:@"Barça"];
		[mi setAction:@selector(menuDidChangeItem:)];
		[popUpButton addItem:mi];
		
		var mi = [[CPMenuItem alloc] init];
		[mi setTag:{row: row, teamId:3}];
		[mi setTitle:@"RCS"];
		[mi setAction:@selector(menuDidChangeItem:)];
		[popUpButton addItem:mi];
		
		[popUpButton setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin];
  	    
  	    [tableColumn setDataView:popUpButton];
	}
}

/*- (void)addToTeam:(id)sender
{
    var request = [CPURLRequest requestWithURL:"/persons/" + [selectedPerson objectForKey:@"id"] + "/teams/1/"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
    [[CPURLConnection alloc] initWithRequest:request delegate:self];
}*/

- (void)menuDidChangeItem:(id)sender
{
    var clickedItemData = [sender tag];
    var rowClicked = (clickedItemData.row + 1 === persons.length) ? 0 : clickedItemData.row + 1;
    var personId = [persons[rowClicked] objectForKey:@"id"];
    var request = [CPURLRequest requestWithURL:"/persons/" + personId + "/teams/" + clickedItemData.teamId + "/"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
    manageUserTeamConnection = [[CPURLConnection alloc] initWithRequest:request delegate:self];
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
	var request = [CPURLRequest requestWithURL:"/persons/"];
	getUsersConnection = [[CPURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data
{
	var JSONLists = CPJSObjectCreateWithJSON(data);
	
	if (aConnection === getUsersConnection)
	{
		persons = [];
		for (var i = 0; i < JSONLists.persons.length; i++)
		{
		    persons[i] = [CPDictionary dictionaryWithJSObject:JSONLists.persons[i] recursively:YES];
	    }
	 
		[tableView reloadData];
	}
	
	if (aConnection === updateUserConnection)
	{
        if (JSONLists.error)
            alert(JSONLists.error);
		[self getList];
	}
	
	if (aConnection === manageUserTeamConnection)
	{
		[self getList];
	}
}

- (void)connection:(CPURLConnection)aConnection didFailWithError:(CPString)error
{
    alert(error);
}

@end
