#tag Window
Begin Window UnitTestWindow Implements Writeable
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   HasFullScreenButton=   False
   Height          =   600
   ImplicitInstance=   True
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   97988607
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "LoxUnitTest"
   Visible         =   True
   Width           =   900
   Begin TabPanel TabPanel1
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   16.0
      FontUnit        =   0
      Height          =   600
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Panels          =   ""
      Scope           =   0
      SmallTabs       =   False
      TabDefinition   =   "UnitTest\rTest"
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   True
      Underline       =   False
      Value           =   1
      Visible         =   True
      Width           =   900
      Begin UnitTestPanel UnitTestPanel1
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         AllowFocusRing  =   False
         AllowTabs       =   True
         Backdrop        =   0
         BackgroundColor =   &cFFFFFF00
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         HasBackgroundColor=   False
         Height          =   550
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Left            =   15
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   1
         TabStop         =   True
         Tooltip         =   ""
         Top             =   38
         Transparent     =   True
         Visible         =   True
         Width           =   870
      End
      Begin BevelButton PushButton1
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         BackgroundColor =   &c00000000
         BevelStyle      =   "4"
         Bold            =   False
         ButtonStyle     =   "0"
         Caption         =   "Load..."
         CaptionAlignment=   "0"
         CaptionDelta    =   2
         CaptionPosition =   "0"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   16.0
         FontUnit        =   0
         HasBackgroundColor=   False
         Height          =   30
         Icon            =   0
         IconAlignment   =   "0"
         IconDeltaX      =   0
         IconDeltaY      =   0
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   False
         Left            =   20
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MenuStyle       =   "0"
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   2
         TabStop         =   True
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   50
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   80
      End
      Begin TextArea TextArea2
         AllowAutoDeactivate=   True
         AllowFocusRing  =   True
         AllowSpellChecking=   False
         AllowStyledText =   False
         AllowTabs       =   False
         BackgroundColor =   &cFFFFFF00
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   18.0
         FontUnit        =   0
         Format          =   ""
         HasBorder       =   True
         HasHorizontalScrollbar=   False
         HasVerticalScrollbar=   True
         Height          =   488
         HideSelection   =   True
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   False
         Left            =   520
         LineHeight      =   0.0
         LineSpacing     =   1.0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         MaximumCharactersAllowed=   0
         Multiline       =   True
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   9
         TabPanelIndex   =   2
         TabStop         =   True
         TextAlignment   =   "0"
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   92
         Transparent     =   True
         Underline       =   False
         ValidationMask  =   ""
         Value           =   ""
         Visible         =   True
         Width           =   360
      End
      Begin BevelButton PushButton2
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         BackgroundColor =   &c00000000
         BevelStyle      =   "4"
         Bold            =   False
         ButtonStyle     =   "0"
         Caption         =   "Run"
         CaptionAlignment=   "3"
         CaptionDelta    =   0
         CaptionPosition =   "0"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   16.0
         FontUnit        =   0
         HasBackgroundColor=   False
         Height          =   30
         Icon            =   0
         IconAlignment   =   "0"
         IconDeltaX      =   0
         IconDeltaY      =   0
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   False
         Left            =   520
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         MenuStyle       =   "0"
         Scope           =   0
         TabIndex        =   4
         TabPanelIndex   =   2
         TabStop         =   True
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   50
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   60
      End
      Begin TextField TextField1
         AllowAutoDeactivate=   False
         AllowFocusRing  =   False
         AllowSpellChecking=   False
         AllowTabs       =   False
         BackgroundColor =   &cFFFFFF00
         Bold            =   True
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   16.0
         FontUnit        =   0
         Format          =   ""
         HasBorder       =   True
         Height          =   30
         Hint            =   ""
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   False
         Left            =   112
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         MaximumCharactersAllowed=   0
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   2
         TabStop         =   True
         TextAlignment   =   "0"
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   50
         Transparent     =   True
         Underline       =   False
         ValidationMask  =   ""
         Value           =   ""
         Visible         =   True
         Width           =   384
      End
      Begin BevelButton PushButton4
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         BackgroundColor =   &c00000000
         BevelStyle      =   "4"
         Bold            =   False
         ButtonStyle     =   "0"
         Caption         =   "Scan"
         CaptionAlignment=   "3"
         CaptionDelta    =   0
         CaptionPosition =   "0"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   16.0
         FontUnit        =   0
         HasBackgroundColor=   False
         Height          =   30
         Icon            =   0
         IconAlignment   =   "0"
         IconDeltaX      =   0
         IconDeltaY      =   0
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   False
         Left            =   736
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         MenuStyle       =   "0"
         Scope           =   0
         TabIndex        =   7
         TabPanelIndex   =   2
         TabStop         =   True
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   50
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   60
      End
      Begin BevelButton PushButton5
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         BackgroundColor =   &c00000000
         BevelStyle      =   "4"
         Bold            =   False
         ButtonStyle     =   "0"
         Caption         =   "Tokens"
         CaptionAlignment=   "3"
         CaptionDelta    =   0
         CaptionPosition =   "0"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   16.0
         FontUnit        =   0
         HasBackgroundColor=   False
         Height          =   30
         Icon            =   0
         IconAlignment   =   "0"
         IconDeltaX      =   0
         IconDeltaY      =   0
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   False
         Left            =   808
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         MenuStyle       =   "0"
         Scope           =   0
         TabIndex        =   8
         TabPanelIndex   =   2
         TabStop         =   True
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   50
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   72
      End
      Begin BevelButton PushButton6
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         BackgroundColor =   &c00000000
         BevelStyle      =   "4"
         Bold            =   False
         ButtonStyle     =   "0"
         Caption         =   "Expr"
         CaptionAlignment=   "3"
         CaptionDelta    =   0
         CaptionPosition =   "0"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   16.0
         FontUnit        =   0
         HasBackgroundColor=   False
         Height          =   30
         Icon            =   0
         IconAlignment   =   "0"
         IconDeltaX      =   0
         IconDeltaY      =   0
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   False
         Left            =   592
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         MenuStyle       =   "0"
         Scope           =   0
         TabIndex        =   5
         TabPanelIndex   =   2
         TabStop         =   True
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   50
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   60
      End
      Begin BevelButton PushButton7
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         BackgroundColor =   &c00000000
         BevelStyle      =   "4"
         Bold            =   False
         ButtonStyle     =   "0"
         Caption         =   "From clipboard..."
         CaptionAlignment=   "0"
         CaptionDelta    =   2
         CaptionPosition =   "0"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   16.0
         FontUnit        =   0
         HasBackgroundColor=   False
         Height          =   30
         Icon            =   0
         IconAlignment   =   "0"
         IconDeltaX      =   0
         IconDeltaY      =   0
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   False
         Left            =   20
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MenuStyle       =   "0"
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   2
         TabStop         =   True
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   92
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   130
      End
      Begin ScintillaContainer ScintillaContainer1
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         AllowFocusRing  =   False
         AllowTabs       =   False
         Backdrop        =   0
         BackgroundColor =   &cFFFFFF00
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         HasBackgroundColor=   False
         Height          =   437
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Left            =   20
         LockBottom      =   True
         LockedInPosition=   True
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   10
         TabPanelIndex   =   2
         TabStop         =   True
         Tooltip         =   ""
         Top             =   143
         Transparent     =   True
         Visible         =   True
         Width           =   476
      End
      Begin BevelButton PushButton3
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         BackgroundColor =   &c00000000
         BevelStyle      =   "4"
         Bold            =   False
         ButtonStyle     =   "0"
         Caption         =   "Reset"
         CaptionAlignment=   "3"
         CaptionDelta    =   0
         CaptionPosition =   "0"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   16.0
         FontUnit        =   0
         HasBackgroundColor=   False
         Height          =   30
         Icon            =   0
         IconAlignment   =   "0"
         IconDeltaX      =   0
         IconDeltaY      =   0
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   False
         Left            =   664
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         MenuStyle       =   "0"
         Scope           =   0
         TabIndex        =   6
         TabPanelIndex   =   2
         TabStop         =   True
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   50
         Transparent     =   True
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   60
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  Lox.PrintOut= Self
		  Lox.ErrorOut= Self
		  
		  Lox.AddSearchPath FindFolder("Examples").Child("import").AbsoluteNativePathLox
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  #if RBVersion< 2014
		    UnitTestPanel1.Refresh
		  #endif
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function EditClearAll() As Boolean Handles EditClearAll.Action
			UnitTestPanel1.SelectAllGroups(False, False)
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditSelectAll() As Boolean Handles EditSelectAll.Action
			UnitTestPanel1.SelectAllGroups(True, False)
			
			Return True
			
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h21
		Private Function FindFolder(folderName As String) As FolderItem
		  Dim parent As FolderItem= app.ExecutableFile.Parent
		  Dim folder As FolderItem, found As Boolean
		  
		  While parent<> Nil
		    
		    folder= parent.Child(folderName)
		    If folder.Exists And folder.Directory Then
		      found= True
		      Exit
		    End If
		    
		    parent= parent.Parent
		  Wend
		  
		  Return folder
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Flush()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Write(text As String)
		  TextArea2.AppendText text
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WriteError() As Boolean
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Snippets
		
		var a= Array(10);
		var i= 0;
		for (; i< 10; i++) {
		  a[i]= i*2;
		  print "a[${i}]= ${a[i]}";
		}
		
		//for (i in 0..9) a[i]= 1;
		//a.each(fun (e) {print e;});
		
		
		var a=[1,2,3];
		var s=a.reduce(fun(acum,curr){
		  return acum+= curr;
		});
		print s;
		//a.each(fun(e){print e;});
		
		
		// for (i in 1..10) print i;
		{
		  var range= Range(1, 10);
		  var itera= range.makeIterator();
		  var i;
		  while (i= itera.next()) {
		    print i;
		  }
		} 
		
		var a=[1,3,5];
		{
		  var range= a;
		  var itera= range.makeIterator();
		  var i;
		  while (i= itera.next()) {
		    print i;
		  }
		} 
		// for (i in a) print i;
		
		  
		  // rnd
		  Static r As Random
		  r= New Random
		  r.RandomizeSeed
		  
		  TextArea1.AppendText Str(r.Gaussian)+ EndOfLine
		  TextArea1.AppendText Str(r.Number)+ EndOfLine
		  TextArea1.AppendText Str(r.InRange(2, 7))+ EndOfLine
		  TextArea1.AppendText Str(r.LessThan(100))+ EndOfLine
		  Return
		  
		  
		  // regex replace
		  Dim str1 As String= "\x41 \x43"
		  Dim str2 As String= str1
		  
		  Dim rg As New RegEx
		  rg.Options.CaseSensitive= True
		  rg.SearchPattern= "\\x?([\da-fA-F]{2})"
		  Dim match As RegExMatch= rg.Search(str1)
		  
		  While Not (match Is Nil)
		    Dim subExpr As String= match.SubExpressionString(0)
		    Dim repExpr As String= DecodeHex(match.Replace("\1"))
		    str2= str2.ReplaceAll(match.SubExpressionString(0), repExpr)
		    
		    match= rg.Search
		  Wend
		  Break
		  
		  
		  // test:
		  Dim varts() As Variant
		  Dim vart1 As Variant= "a"
		  Dim vart2 As Variant= "b"
		  Dim vart3 As Variant= "c"
		  Dim vart4 As Variant= "d"
		  
		  varts.Append vart1
		  varts.Append vart2
		  varts.Append vart3
		  varts.Append vart4
		  
		  Dim hm As New Lox.Misc.CSDictionary
		  hm.Value(vart1)= 1
		  hm.Value(vart2)= 2
		  hm.Value(vart3)= 3
		  
		  Dim found As Variant= hm.Lookup(vart1, -1)
		  vart1= 4
		  found= hm.Lookup(vart1, -2)
		  Break
	#tag EndNote


	#tag Constant, Name = kLoxSample, Type = String, Dynamic = False, Default = \"// Your first Lox program!\rprint \"Hello\x2C world!\";\r\r// variables\rvar condition \x3D true;\r\r// control flow\rif (condition) {\r  print \"yes\";\r} else {\r  print \"no\";\r}\r\rvar a \x3D 1;\rwhile (a < 10) {\r  print a;\r  a \x3D a + 1;\r}\r\rfor (var a \x3D 1; a < 10; a \x3D a + 1) {\r  print a;\r}\r\r// functions\rfun printSum(a\x2C b) {\r  print a + b;\r}\rprintSum(1\x2C2);\r\r// closures\rfun addPair(a\x2C b) {\r  return a + b;\r}\r\rfun identity(a) {\r  return a;\r}\r\rprint identity(addPair)(1\x2C 2); // Prints \"3\".\r\r// classes\rclass Breakfast {\r  init(meat\x2C bread) {\r    this.meat \x3D meat;\r    this.bread \x3D bread;\r  }\r\r  cook() {\r    print \"Eggs a-fryin\'!\";\r  }\r\r  serve(who) {\r    print \"Enjoy your breakfast\x2C \" + who + \".\";\r  }\r}\r\rclass Brunch < Breakfast {\r  drink() {\r    print \"How about a Bloody Mary\?\";\r  }\r}\r\r// Store it in variables.\rvar breakfast \x3D Breakfast(\"saug\"\x2C \"sour\");\rprint breakfast; // \"Breakfast instance\".\r\rbreakfast.meat \x3D \"sausage\";\rbreakfast.bread \x3D \"sourdough\";\r\rbreakfast.serve(\"Dear Reader\");\r// \"Enjoy your bacon and toast\x2C Dear Reader.\"\r\rvar benedict \x3D Brunch(\"ham\"\x2C \"English muffin\");\rbenedict.serve(\"Noble Reader\");\rbenedict.drink();\r\r\rfun fib(n) {\r  if (n < 2) return n;\r  return fib(n - 1) + fib(n - 2); \r}\r\rvar before \x3D clock();\rprint fib(6);\rvar after \x3D clock();\rprint after - before;\r\rprint System.osName;\rprint System.osEnvVar(\"HOMEPATH\");\rprint System.assert(true\x2C \"pass\");\rprint System.debugLog(\"test\");\r\r\rvar file\x3D File();\rvar parent\x3D file.parent;\r\rvar n\x3D parent.count;\rfor (var i\x3D1;i<\x3Dn;i++) {\r  print parent.item(i).name;\r}\r\rvar docs\x3D File.documents;\rprint \"docs.count: \"+ docs.count;\r\rvar temps\x3D File.temp;\rprint \"temps.count: \"+ temps.count;\r\rvar appdata\x3D File.appdata;\rprint \"appdata.count: \"+ appdata.count;\r\r", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events PushButton1
	#tag Event
		Sub Action()
		  Dim txtType As New FileType
		  txtType.Name = "text/plain"
		  txtType.MacType = "TXT "
		  txtType.Extensions = "lox;txt"
		  
		  Dim f As FolderItem= GetOpenFolderItem(txtType)
		  If f Is Nil Then Return
		  Dim t As TextInputStream= TextInputStream.Open(f)
		  ScintillaContainer1.ScintillaControlMBS1.Text= t.ReadAll
		  TextField1.Text= f.DisplayName
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  Lox.PrintOut= Self
		  Lox.ErrorOut= Self
		  
		  Dim scanner As New Lox.Scanner(ScintillaContainer1.ScintillaControlMBS1.Text)
		  Dim tokens() As Lox.Token= scanner.Scan
		  If scanner.HadError Then Return
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  If parser.HadError Then Return
		  
		  Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  If resolver.HadError Then Return
		  
		  Lox.Interpreter.Interpret(statements)
		  If Lox.Interpreter.HadRuntimeError Then
		    'Break
		  End If
		  
		  TextArea2.AppendText EndOfLine
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton4
	#tag Event
		Sub Action()
		  Dim scanner As New Lox.Scanner(ScintillaContainer1.ScintillaControlMBS1.Text)
		  Dim tokens() As Lox.Token= scanner.Scan
		  If scanner.HadError Then Return
		  
		  Dim lines() As String
		  For Each token As Lox.Token In tokens
		    lines.Append token.TypeToken.ToString+ " "+ token.Lexeme+ _
		    " "+ token.Literal.ToStringLox+ EndOfLine
		  Next
		  
		  TextArea2.AppendText Join(lines)+ EndOfLine
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton5
	#tag Event
		Sub Action()
		  Dim scanner As New Lox.Scanner(ScintillaContainer1.ScintillaControlMBS1.Text)
		  Dim tokens() As Lox.Token= scanner.Scan
		  If scanner.HadError Then Return
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  If parser.HadError Then Return
		  
		  Dim lines() As String
		  For Each statement As Lox.Ast.Stmt In statements
		    Dim stmtPrinter As New Lox.Misc.AstPrinter
		    Dim stmt As String= stmtPrinter.Print(statement)
		    lines.Append stmt+ EndOfLine
		  Next
		  
		  TextArea2.AppendText Join(lines)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton6
	#tag Event
		Sub Action()
		  Lox.PrintOut= Self
		  Lox.ErrorOut= Self
		  
		  Dim scanner As New Lox.Scanner(ScintillaContainer1.ScintillaControlMBS1.Text)
		  Dim tokens() As Lox.Token= scanner.Scan
		  If scanner.HadError Then Return
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim syntax As Variant= parser.ParseREPL
		  If parser.HadError Then Return
		  
		  If syntax.isArray Then
		    Dim statements() As Lox.Ast.Stmt= syntax
		    
		    Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		    resolver.Resolve(statements)
		    If resolver.HadError Then Return
		    
		    Lox.Interpreter.Interpret(statements)
		    If Lox.Interpreter.HadRuntimeError Then Return
		  Else
		    Dim expr As Lox.Ast.Expr= Lox.Ast.Expr(syntax)
		    Dim result As Variant= Lox.Interpreter.Interpret(expr)
		    If result.Type= 8 Then TextArea2.AppendText "= "+ result+ EndOfLine
		  End If
		  
		  TextArea2.AppendText EndOfLine
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton7
	#tag Event
		Sub Action()
		  Dim cb As New Clipboard
		  ScintillaContainer1.ScintillaControlMBS1.Text= cb.Text
		  cb.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ScintillaContainer1
	#tag Event
		Sub Ready()
		  Dim sc As ScintillaControlMBS= Me.ScintillaControlMBS1
		  
		  sc.Text= kLoxSample
		  Call sc.MarkerAdd(1, 1)
		  Call sc.MarkerAdd(4, 0)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton3
	#tag Event
		Sub Action()
		  Lox.Interpreter.Reset
		  TextArea2.Text= ""
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
