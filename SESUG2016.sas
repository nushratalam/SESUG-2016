libname grocery '/home/nushrat1.alam/Mycontent';

proc import datafile='/home/nushrat1.alam/Mycontent/Gro1.xlsx' 
	out = grocery.gro1 dbms=xlsx;
run;

proc contents data = grocery.gro1 varnum;
run;

/*TIME FUNCTION*/

data grocery.grocery1;
set grocery.gro1;
LastBought = '20AUG2016'd ;
Today = Today();
Check1 = intnx('Day','20AUG2016'd, 14);
Check2 = intnx('Day','20AUG2016'd, 28);
put Check1/Check1 Date9.;
put Check2/Check2 Date9.;
run;

data grocery.g1;
set grocery.grocery1;
if  Schedule in ('Biweekly')then CheckOn = Check1;
If Schedule in ('Monthly')then CheckOn = Check2;
If (Today=>CheckOn) then Buy = 'Y';
If (Today < CheckOn) then  Buy= 'W';
run;

/*PROC REPORT*/
ods graphics on; 
ods pdf file= '/home/nushrat1.alam/Mycontent/grocery.pdf' notoc;

option pageno=1 date orientation=landscape;
Title 'GROCERY LIST' font= Arial bold height=4;
footnote 'Y=Yes W= Wait';
proc report data =grocery.g1
	style (report) = {preimage = '/home/nushrat1.alam/Mycontent/Grocery.jpg'} 
	style (summary) = Header center;
	columns store category  item Amount LastBought Schedule Today CheckOn Buy;
	define store/order width = 20 style (column) =[font_weight=bold color = Blue];
	define category/ display width= 250 style (column) =[font_weight=bold  color = Black];
	define item /order width=50;
	define amount/ format=2.;
	define LastBought/ format= Date9.;
	define Schedule/ display width= 25;
	define Today/ format=Date9.;
	define CheckOn/ Format=date9.; 
	define Buy /Display Width= 250 style (column) =[font_weight=bold color = LightRed];
	
run;
footnote;
Title;
ods pdf close;


/*Traffic Lighting*/
proc format;
	value $Dietvalue
 'Protein' ='Yellow'
 'Carbohydrate' = 'Dark Red'
  'Fat'= 'light Orange'
  'Others' = 'Very lightPurple'
  'Vegetables' = 'Green'
  'Fruit' = 'Very light Blue';
run;
 
proc contents data =grocery.g1 varnum;
run;
 
ods pdf file= '/home/nushrat1.alam/Mycontent/grocery1.pdf' notoc;
option pageno=1 orientation= landscape;
Title 'GROCERY LIST' font= Arial bold height=4;
footnote 'Y=Yes W= Wait';
proc report data =grocery.g1
	style (report) = {preimage = '/home/nushrat1.alam/Mycontent/Grocery.jpg'} 
	style (summary) = Header center ;
	columns store category  item Amount Group LastBought Schedule Today CheckOn Buy;
	define store/order width = 20 style (column) =[font_weight=bold color = Blue];
	define category/ display width= 250 style (column) =[font_weight=bold  color = Black];
	define item /order width=50;
	define amount/ format=2.;
	define Group/  style (column) =[font_weight=bold background=$Dietvalue.];
	define LastBought/ format= Date9.;
	define Schedule/ display width= 25;
	define Today/ format=Date9.;
	define CheckOn/ Format=date9.; 
	define Buy /Display Width= 250 style (column) =[font_weight=bold color = VeryLightRed];
	
run;
footnote;
Title;

/*Food Habit Tracking*/
option pageno=2 orientation=landscape;

Title 'FOOD VALUE TRACKING';
proc gchart data= grocery.g1 (where=(Category='Breakfast' or Category ='Lunch' or Category='Dinner' or Category = 'Snacks'));
   pie Group / group=Category
              midpoints="Protein" "Carbohydrate" "Fat" "Others" "Vegetables" "Fruit"
              value=none
              percent=arrow
              slice=arrow
              plabel=(font='Albany AMT/bold' h=1.3 color= Darkblue);
title;
run;
quit; 
ods pdf close;