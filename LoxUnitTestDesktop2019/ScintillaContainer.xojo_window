#tag Window
Begin ContainerControl ScintillaContainer
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
   Height          =   400
   InitialParent   =   ""
   Left            =   0
   LockBottom      =   True
   LockLeft        =   True
   LockRight       =   True
   LockTop         =   True
   TabIndex        =   0
   TabPanelIndex   =   0
   TabStop         =   True
   Tooltip         =   ""
   Top             =   0
   Transparent     =   True
   Visible         =   True
   Width           =   600
   Begin ScintillaControlMBS ScintillaControlMBS1
      AutoDeactivate  =   True
      Enabled         =   True
      HasBorder       =   True
      Height          =   400
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      ShowInfoBar     =   True
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   0
      Visible         =   True
      Width           =   600
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  Dim c As ScintillaControlMBS= Me.ScintillaControlMBS1
		  
		  // if you got newer lexer with Xojo
		  c.InitializeLexer "cpp"
		  
		  'For i As Integer= 0 To 255
		  'System.DebugLog "i="+ str(i)+ " "+ c.Style(i).Description
		  'Next
		  
		  // all miss the // comments, so we may eventually need to make an extra one.
		  Const SCE_LOX_WHITE_SPACE  = 0
		  Const SCE_LOX_COMMENT      = 1 // /* */
		  Const SCE_LOX_COMMENT_LINE = 2 // // 
		  Const SCE_LOX_NUMBER       = 4 
		  Const SCE_LOX_KEYWORD      = 5
		  Const SCE_LOX_STRING       = 6 // starts with "....."
		  'Const SCE_LOX_PREPROCESSOR = 9 // #if #pragma
		  Const SCE_LOX_OPERATOR     = 10
		  Const SCE_LOX_IDENTIFIER   = 11
		  Const SCE_LOX_KEYWORD2     = 16
		  'Const SCE_LOX_ESCAPESEQ    = 27
		  
		  'Const SCE_LOX_COLOR_RED    = 11 // starts &c default color is RED
		  'Const SCE_LOX_COLOR_GREEN  = 12 // starts &c default color is GREEN
		  'Const SCE_LOX_COLOR_BLUE   = 13 // starts &c default color is BLUE
		  'Const SCE_LOX_COLOR_ALPHA  = 14 // starts &c  default color is the system default text color based on light mode dark mode
		  
		  Dim factor As Double = 1
		  Dim reservedWords As String = "print clock var true false nil fun class init static this super for in if or and else return while continue break module import"
		  Dim dataTypes As String = "Array Dict Range"
		  
		  AddWordsForAutoComplete reservedWords
		  AddWordsForAutoComplete dataTypes
		  
		  // Keywords to highlight. Indices are:
		  // 0 - Major keywords (reserved keywords)
		  // 1 - Normal keywords (everything not reserved but integral part of the language)
		  // 2 - Database objects
		  // 3 - Function keywords
		  // 4 - System variable keywords
		  // 5 - Procedure keywords (keywords used in procedures like "begin" and "end")
		  // 6..8 - User keywords 1..3
		  c.KeyWords(0)= reservedWords
		  c.KeyWords(1)= dataTypes
		  
		  Dim style As ScintillaStyleMBS = c.Style(ScintillaStyleMBS.kStylesCommonDefault)
		  style.Font = kDefaultFont
		  
		  #If TargetWindows Then
		    style.size = 14 // on Windows it is 96 dpi insteasd of 72dpi
		    factor = Self.ScaleFactor // and we have to do margins *2
		  #Else
		    factor = 1
		    style.size = 16
		  #endif
		  style.ForeColor = &c5C5C5C
		  
		  #If False
		    Dim backColor As Color= &cEBEBEB
		    Dim commentColor As Color= &cAC151A
		    Dim commentLineColor As Color= &c7D1012
		    Dim stringColor As Color= &c9D33D5
		    Dim numberColor As Color= &c24B52F
		    Dim operatorColor As Color= &c590000
		    Dim keywordColor As Color= &c0A5FFE
		    Dim identifierColor As Color= &c003700
		    Dim keyword2Color As Color= &cC46200
		    Dim caretColor As Color= &c7E7E7E00
		    Dim selBackColor As Color= &cCEE7FF
		  #Else // dark 
		    Dim backColor As Color= &c19191900
		    Dim commentColor As Color= &cF29FA200
		    Dim commentLineColor As Color= &cFAD1D200
		    Dim stringColor As Color= &c00C10000
		    Dim numberColor As Color= &c80BFFF00
		    Dim operatorColor As Color= &cFF2F2F00
		    Dim keywordColor As Color= &cC1C1E100
		    Dim identifierColor As Color= &cC287E700
		    Dim keyword2Color As Color= &cFF8B1700
		    Dim caretColor As Color= &cF4F4F400
		    Dim selBackColor As Color= &c52525200
		  #endif
		  
		  style.BackColor= backColor
		  
		  'c.StyleClearAll
		  '
		  c.Style(SCE_LOX_WHITE_SPACE).BackColor = backColor
		  '
		  c.Style(SCE_LOX_COMMENT).ForeColor = commentColor
		  c.Style(SCE_LOX_COMMENT).BackColor = backColor
		  c.Style(SCE_LOX_COMMENT_LINE).ForeColor = commentLineColor
		  c.Style(SCE_LOX_COMMENT_LINE).BackColor = backColor
		  
		  c.Style(SCE_LOX_STRING).ForeColor = stringColor
		  c.Style(SCE_LOX_STRING).BackColor = backColor
		  c.Style(SCE_LOX_NUMBER).ForeColor = numberColor
		  c.Style(SCE_LOX_NUMBER).BackColor = backColor
		  c.Style(SCE_LOX_OPERATOR).ForeColor = operatorColor
		  c.Style(SCE_LOX_OPERATOR).bold = True
		  c.Style(SCE_LOX_OPERATOR).BackColor = backColor
		  'c.Style(SCE_LOX_PREPROCESSOR).ForeColor = &c595BB4
		  c.Style(SCE_LOX_KEYWORD).ForeColor = keywordColor
		  c.Style(SCE_LOX_KEYWORD).bold = True
		  c.Style(SCE_LOX_KEYWORD).BackColor = backColor
		  c.Style(SCE_LOX_IDENTIFIER).ForeColor = identifierColor
		  c.Style(SCE_LOX_IDENTIFIER).BackColor = backColor
		  c.Style(SCE_LOX_KEYWORD2).ForeColor = keyword2Color
		  c.Style(SCE_LOX_KEYWORD2).BackColor = backColor
		  'c.Style(SCE_LOX_ESCAPESEQ).ForeColor = &cFF0000
		  
		  // Line number style.
		  c.Style(ScintillaStyleMBS.kStylesCommonLineNumber).ForeColor = &cF0F0F0
		  c.Style(ScintillaStyleMBS.kStylesCommonLineNumber).BackColor = &c3E3E40
		  
		  'System.DebugLog Str(c.Style(SCE_LOX_KEYWORD).ForeColor) 
		  
		  'c.Margin(0).Width = 0
		  
		  // Markers.
		  c.Margin(0).Type = ScintillaMarginMBS.kMarginTypeSymbol
		  c.Margin(0).Width = 16
		  c.Margin(0).Sensitive = True // allow click
		  c.Margin(0).Mask = Not c.kMaskFolders
		  
		  // line numbers
		  c.Margin(1).Type = ScintillaMarginMBS.kMarginTypeNumber
		  c.Margin(1).Width = 35 * Factor
		  c.Margin(1).Mask = 0
		  
		  // Some special lexer properties.
		  c.PropertyValue("fold") = "1"
		  c.PropertyValue("fold.compact") = "0"
		  c.PropertyValue("fold.comment") = "1"
		  c.PropertyValue("fold.preprocessor") = "1"
		  
		  // Folder setup.
		  c.Margin(2).Type = ScintillaMarginMBS.kMarginTypeSymbol
		  c.Margin(2).Width = 18
		  c.Margin(2).Mask = c.kMaskFolders
		  c.Margin(2).Sensitive = True
		  
		  c.Marker(ScintillaMarkerMBS.kMarkerOutlineFolderOpen).Symbol = ScintillaMarkerMBS.kMarkerSymbolArrowDown
		  c.Marker(ScintillaMarkerMBS.kMarkerOutlineFolder).Symbol = ScintillaMarkerMBS.kMarkerSymbolArrow
		  c.Marker(ScintillaMarkerMBS.kMarkerOutlineFolderSub).Symbol = ScintillaMarkerMBS.kMarkerSymbolVLine
		  c.Marker(ScintillaMarkerMBS.kMarkerOutlineFolderTail).Symbol = ScintillaMarkerMBS.kMarkerSymbolLCorner
		  c.Marker(ScintillaMarkerMBS.kMarkerOutlineFolderEnd).Symbol = ScintillaMarkerMBS.kMarkerSymbolCirclePlusConnected
		  c.Marker(ScintillaMarkerMBS.kMarkerOutlineFolderOpenMid).Symbol = ScintillaMarkerMBS.kMarkerSymbolCircleMinusConnected
		  c.Marker(ScintillaMarkerMBS.kMarkerOutlineFolderMidTail).Symbol = ScintillaMarkerMBS.kMarkerSymbolTCorner
		  
		  For n As Integer = 25 To 31
		    // Markers 25..31 are reserved for folding.
		    
		    c.Marker(n).ForeColor = &cD7D7D700
		    c.Marker(n).BackColor = &c16161600
		    
		  Next
		  
		  // Init markers & indicators for highlighting of syntax errors.
		  c.Indicator(0).ForeColor = &cFF0000
		  c.Indicator(0).Under = True
		  c.Indicator(0).Style = ScintillaIndicatorMBS.kIndicatorStyleSquiggle
		  
		  c.Marker(0).BackColor = &cB1151C
		  
		  c.SetSelBackColor(True, selBackColor)
		  'c.SetSelForeColor(True, Color.White)
		  
		  'c.CaretStyle= ScintillaControlMBS.kCaretStyleBlockAfter
		  
		  // define the marker for breakpoint
		  c.Marker(1).ForeColor = &cFF00
		  c.Marker(1).Symbol = ScintillaMarkerMBS.kMarkerSymbolBookmark
		  
		  // more possible options
		  
		  c.AutoCompleteIgnoreCase = True
		  c.MultipleSelection= True
		  c.AdditionalSelectionTyping= True
		  
		  c.SetFoldMarginColor(True, &c3E3E40)
		  c.SetFoldMarginHighlightColor(True, &c3E3E40)
		  
		  c.CaretForeColor= caretColor
		  
		  c.setStatusText "Ready"
		  
		  RaiseEvent Ready
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddWordsForAutoComplete(list as string)
		  Dim words() As String = Split(list, " ")
		  
		  For Each word As String In words
		    AutoCompleteWords.Append word
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartAutoComplete()
		  Dim editor As ScintillaControlMBS = ScintillaControlMBS1
		  
		  'Dim CurrentPosition As Integer = editor.Position
		  'Dim lineCurrentPos As Integer = editor.LineFromPosition(CurrentPosition)
		  'Dim lineStart As Integer = editor.LineStart(lineCurrentPos)
		  'Dim lineEnd As Integer = editor.LineStart(lineCurrentPos + 1)
		  
		  
		  Dim line As String = editor.CurrentLine
		  Dim positon As Integer = editor.GetCaretInLine
		  Dim wordCharacters As String = editor.WordChars
		  
		  Dim startword As Integer = positon
		  // Autocompletion of pure numbers is mostly an annoyance
		  Dim allNumber As Boolean = True
		  
		  Dim Numbers As String = "0123456789"
		  While (startword > 0 And wordCharacters.IndexOfBytes(line.MiddleBytes(startword-1, 1)) >= 0) 
		    startword = startword - 1
		    Dim c As String = line.MiddleBytes(startword, 1)
		    If Numbers.IndexOf(c) < 0 Then
		      // not a number
		      allNumber = False
		    End If
		  Wend
		  
		  If startword = positon Or allNumber Then
		    // nothing to do
		    Return 
		  End If
		  
		  
		  // build word list
		  
		  Dim root As String = line.MiddleBytes(startword, positon - startword)
		  Dim rootLength As Integer = root.Bytes
		  
		  // simple auto complete based on key words
		  
		  Dim words() As String
		  For Each n As String In AutoCompleteWords
		    
		    If n.Bytes > rootLength And n.LeftB(rootLength) = root Then
		      words.Append n
		    End If
		    
		  Next
		  
		  If words.Ubound = -1 Then 
		    // no words
		    editor.AutoCompleteCancel
		    Return 
		    
		  Else
		    
		    Const autoCompleteVisibleItemCount = 9
		    
		    Dim wordList As String = Join(Words, " ")
		    editor.AutoCompleteMaxHeight = autoCompleteVisibleItemCount
		    editor.AutoCompleteSeparator = 32
		    editor.AutoCompleteShow(rootLength, wordList)
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Ready()
	#tag EndHook


	#tag Property, Flags = &h0
		AutoCompleteWords() As string
	#tag EndProperty


	#tag Constant, Name = kDefaultFont, Type = String, Dynamic = False, Default = \"System", Scope = Private
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"Consolas"
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Menlo"
	#tag EndConstant


#tag EndWindowCode

#tag Events ScintillaControlMBS1
	#tag Event
		Sub CharacterAdded(Character as Integer, CharacterSource as Integer)
		  'System.DebugLog CurrentMethodName
		  
		  
		  // new line -> let's indent the text a bit
		  If Character = 13 Or Character = 10 Then 
		    
		    Dim CurrentPosition As Integer = Me.Position
		    Dim curLine As Integer = Me.LineFromPosition(CurrentPosition)
		    Dim lineLength As Integer = Me.LineLength(curLine)
		    
		    If curLine > 0 And lineLength < 2 Then
		      // beginning on a new line
		      
		      Dim prevLine As String = Me.Line(curLine-1)
		      Dim Len As Integer = 0
		      
		      For i As Integer = 1 To prevLine.Len
		        Dim ch As String = prevLine.Mid(i, 1)
		        If Asc(ch) = 9 Or Asc(ch) = 32 Then
		          // we take that
		          Len = i
		        Else
		          // start of text, so exit
		          Exit
		        End If
		      Next
		      
		      Dim prefix As String = prevLine.Left(Len)
		      Me.ReplaceSelection(prefix)
		      return
		    End If
		  End If
		  
		  
		  
		  
		  // no selection?
		  If Me.SelectionEnd = Me.SelectionStart Then
		    If Me.SelectionStart > 0 Then
		      
		      // already active?
		      If Me.AutoCompleteActive Then
		        
		      Else
		        StartAutoComplete
		      End If
		    End If
		  End If
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub MarginClick(Position as Integer, modifiers as Integer, Margin as ScintillaMarginMBS)
		  If Margin.Margin= 0 Then // markers
		    Const kBitMarker1= &b01 //1
		    Const kBitMarker2= &b10 //2
		    Dim line As Integer= Me.LineFromPosition(Position),  whichMarkers As Integer
		    
		    If modifiers= Me.kKeyModCtrl Then //(kKeyModShift And Me.kKeyModCtrl)
		      whichMarkers= Me.MarkerGet(line) // bookmark
		      If (whichMarkers And kBitMarker2)= kBitMarker2 Then // mark
		        Call Me.MarkerDelete(line, 1)
		      Else
		        Call Me.MarkerAdd(line, 1)
		      End If
		      Return
		    End If
		    
		    whichMarkers= Me.MarkerGet(line) // circle
		    If (whichMarkers And kBitMarker1)= kBitMarker1 Then // mark
		      Call Me.MarkerDelete(line, 0)
		    Else
		      Call Me.MarkerAdd(line, 0)
		    End If
		    
		  End If
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
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="InitialParent"
		Visible=false
		Group="Position"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Left"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Top"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockLeft"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockTop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockRight"
		Visible=true
		Group="Position"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockBottom"
		Visible=true
		Group="Position"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIndex"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabPanelIndex"
		Visible=false
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabStop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowAutoDeactivate"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Tooltip"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocusRing"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
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
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocus"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowTabs"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EraseBackground"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Transparent"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DoubleBuffer"
		Visible=true
		Group="Windows Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
