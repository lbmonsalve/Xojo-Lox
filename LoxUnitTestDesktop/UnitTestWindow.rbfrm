#tag Window
Begin Window UnitTestWindow Implements Writeable
   BackColor       =   &hFFFFFF
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   600
   ImplicitInstance=   True
   LiveResize      =   True
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
   Width           =   800
   Begin TabPanel TabPanel1
      AutoDeactivate  =   True
      Bold            =   ""
      Enabled         =   True
      Height          =   600
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Panels          =   ""
      Scope           =   0
      SmallTabs       =   ""
      TabDefinition   =   "UnitTest\rTest"
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   16
      TextUnit        =   0
      Top             =   0
      Underline       =   ""
      Value           =   1
      Visible         =   True
      Width           =   800
      Begin UnitTestPanel UnitTestPanel1
         AcceptFocus     =   ""
         AcceptTabs      =   True
         AutoDeactivate  =   True
         BackColor       =   &hFFFFFF
         Backdrop        =   ""
         Enabled         =   True
         EraseBackground =   True
         HasBackColor    =   False
         Height          =   550
         HelpTag         =   ""
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
         Top             =   38
         UseFocusRing    =   ""
         Visible         =   True
         Width           =   770
      End
      Begin PushButton PushButton1
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "Load"
         Default         =   ""
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   20
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   2
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   16
         TextUnit        =   0
         Top             =   50
         Underline       =   ""
         Visible         =   True
         Width           =   80
      End
      Begin TextArea TextArea1
         AcceptTabs      =   True
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &hFFFFFF
         Bold            =   ""
         Border          =   True
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   437
         HelpTag         =   ""
         HideSelection   =   True
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   20
         LimitText       =   0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Multiline       =   True
         ReadOnly        =   ""
         Scope           =   0
         ScrollbarHorizontal=   ""
         ScrollbarVertical=   True
         Styled          =   False
         TabIndex        =   3
         TabPanelIndex   =   2
         TabStop         =   True
         Text            =   "// Your first Lox program!\r\nprint ""Hello, world!"";\r\n\r\n// variables\r\nvar condition = true;\r\n\r\n// control flow\r\nif (condition) {\r\n  print ""yes"";\r\n} else {\r\n  print ""no"";\r\n}\r\n\r\nvar a = 1;\r\nwhile (a < 10) {\r\n  print a;\r\n  a = a + 1;\r\n}\r\n\r\nfor (var a = 1; a < 10; a = a + 1) {\r\n  print a;\r\n}\r\n\r\n// functions\r\nfun printSum(a, b) {\r\n  print a + b;\r\n}\r\nprintSum(1,2);\r\n\r\n// closures\r\nfun addPair(a, b) {\r\n  return a + b;\r\n}\r\n\r\nfun identity(a) {\r\n  return a;\r\n}\r\n\r\nprint identity(addPair)(1, 2); // Prints ""3"".\r\n\r\n// classes\r\nclass Breakfast {\r\n  init(meat, bread) {\r\n    this.meat = meat;\r\n    this.bread = bread;\r\n  }\r\n\r\n  cook() {\r\n    print ""Eggs a-fryin'!"";\r\n  }\r\n\r\n  serve(who) {\r\n    print ""Enjoy your breakfast, "" + who + ""."";\r\n  }\r\n}\r\n\r\nclass Brunch < Breakfast {\r\n  drink() {\r\n    print ""How about a Bloody Mary?"";\r\n  }\r\n}\r\n\r\n// Store it in variables.\r\nvar breakfast = Breakfast(""saug"", ""sour"");\r\nprint breakfast; // ""Breakfast instance"".\r\n\r\nbreakfast.meat = ""sausage"";\r\nbreakfast.bread = ""sourdough"";\r\n\r\nbreakfast.serve(""Dear Reader"");\r\n// ""Enjoy your bacon and toast, Dear Reader.""\r\n\r\nvar benedict = Brunch(""ham"", ""English muffin"");\r\nbenedict.serve(""Noble Reader"");\r\nbenedict.drink();\r\n\r\n\r\nfun fib(n) {\r\n  if (n < 2) return n;\r\n  return fib(n - 1) + fib(n - 2); \r\n}\r\n\r\nvar before = clock();\r\nprint fib(10);\r\nvar after = clock();\r\nprint after - before;"
         TextColor       =   &h000000
         TextFont        =   "System"
         TextSize        =   18
         TextUnit        =   0
         Top             =   143
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   360
      End
      Begin TextArea TextArea2
         AcceptTabs      =   ""
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   False
         BackColor       =   &hFFFFFF
         Bold            =   ""
         Border          =   True
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   488
         HelpTag         =   ""
         HideSelection   =   True
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   420
         LimitText       =   0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Multiline       =   True
         ReadOnly        =   False
         Scope           =   0
         ScrollbarHorizontal=   ""
         ScrollbarVertical=   True
         Styled          =   False
         TabIndex        =   9
         TabPanelIndex   =   2
         TabStop         =   True
         Text            =   ""
         TextColor       =   &h000000
         TextFont        =   "System"
         TextSize        =   18
         TextUnit        =   0
         Top             =   92
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   360
      End
      Begin PushButton PushButton2
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "Run"
         Default         =   ""
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   420
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   4
         TabPanelIndex   =   2
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   16
         TextUnit        =   0
         Top             =   50
         Underline       =   ""
         Visible         =   True
         Width           =   60
      End
      Begin TextField TextField1
         AcceptTabs      =   ""
         Alignment       =   0
         AutoDeactivate  =   False
         AutomaticallyCheckSpelling=   False
         BackColor       =   &hFFFFFF
         Bold            =   ""
         Border          =   False
         CueText         =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   112
         LimitText       =   0
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Mask            =   ""
         Password        =   ""
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   2
         TabStop         =   True
         Text            =   ""
         TextColor       =   &h000000
         TextFont        =   "System"
         TextSize        =   16
         TextUnit        =   0
         Top             =   51
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   268
      End
      Begin PushButton PushButton3
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "Reset"
         Default         =   ""
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   564
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   6
         TabPanelIndex   =   2
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   16
         TextUnit        =   0
         Top             =   50
         Underline       =   ""
         Visible         =   True
         Width           =   60
      End
      Begin PushButton PushButton4
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "Scan"
         Default         =   ""
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   636
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   7
         TabPanelIndex   =   2
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   16
         TextUnit        =   0
         Top             =   50
         Underline       =   ""
         Visible         =   True
         Width           =   60
      End
      Begin PushButton PushButton5
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "Tokens"
         Default         =   ""
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   708
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   8
         TabPanelIndex   =   2
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   16
         TextUnit        =   0
         Top             =   50
         Underline       =   ""
         Visible         =   True
         Width           =   60
      End
      Begin PushButton PushButton6
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "Expr"
         Default         =   ""
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   492
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         Scope           =   0
         TabIndex        =   5
         TabPanelIndex   =   2
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   16
         TextUnit        =   0
         Top             =   50
         Underline       =   ""
         Visible         =   True
         Width           =   60
      End
      Begin PushButton PushButton7
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "From clipboard"
         Default         =   ""
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "TabPanel1"
         Italic          =   ""
         Left            =   20
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   2
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   16
         TextUnit        =   0
         Top             =   92
         Underline       =   ""
         Visible         =   True
         Width           =   130
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  Lox.PrintOut= Self
		  Lox.ErrorOut= Self
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


#tag EndWindowCode

#tag Events PushButton1
	#tag Event
		Sub Action()
		  Dim varts() As Variant
		  Dim vart1 As Variant= "a"
		  Dim vart2 As Variant= "b"
		  Dim vart3 As Variant= "c"
		  Dim vart4 As Variant= "d"
		  
		  varts.Append vart1
		  varts.Append vart2
		  varts.Append vart3
		  varts.Append vart4
		  
		  Dim search As Variant= "c"
		  Dim idx As Integer= varts.IndexOf(search)
		  
		  Dim idxFound As Integer
		  For i As Integer= 0 To varts.Ubound
		    If search.Equals(varts(i)) Then
		      idxFound= i
		      Exit
		    End If
		  Next
		  
		  Break
		  
		  Dim txtType As New FileType
		  txtType.Name = "text/plain"
		  txtType.MacType = "TXT "
		  txtType.Extensions = "lox;txt"
		  
		  Dim f As FolderItem= GetOpenFolderItem(txtType)
		  If f Is Nil Then Return
		  Dim t As TextInputStream= TextInputStream.Open(f)
		  TextArea1.Text= t.ReadAll
		  TextField1.Text= f.DisplayName
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  'Dim ti As Introspection.TypeInfo= GetTypeInfo(Lox.Inter.Std.System)
		  
		  Lox.PrintOut= Self
		  Lox.ErrorOut= Self
		  
		  Dim scanner As New Lox.Scanner(TextArea1.Text)
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
#tag Events PushButton3
	#tag Event
		Sub Action()
		  Lox.Interpreter.Reset
		  TextArea2.Text= ""
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton4
	#tag Event
		Sub Action()
		  Dim scanner As New Lox.Scanner(TextArea1.Text)
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
		  Dim scanner As New Lox.Scanner(TextArea1.Text)
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
		  
		  Dim scanner As New Lox.Scanner(TextArea1.Text)
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
		  TextArea1.Text= cb.Text
		  cb.Close
		End Sub
	#tag EndEvent
#tag EndEvents
