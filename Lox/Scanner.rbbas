#tag Class
Protected Class Scanner
	#tag Method, Flags = &h21
		Private Sub AddToken(type As TokenType)
		  AddToken type, Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddToken(type As TokenType, literal As Variant)
		  Dim text As String= mSource.SubstringLox(mStart, mCurrent)
		  mTokens.Append New Token(type, text, literal, mLine)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Advance() As String
		  Dim ret As String= mSource.Mid(mCurrent, 1) // charAt
		  mCurrent= mCurrent+ 1
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(source As String)
		  mSource= ReplaceLineEndings(source, EndOfLine.Windows)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Identifier()
		  While IsAlphanumeric(Peek)
		    Call Advance
		  Wend
		  
		  Dim text As String= mSource.SubstringLox(mStart, mCurrent)
		  Dim type As TokenType= Keywords.Lookup(text, TokenType.IDENTIFIER)
		  
		  AddToken type
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsAlpha(c As String) As Boolean
		  Dim cAsc As Integer= c.Asc
		  
		  If cAsc>= Asc("a") And cAsc<= Asc("z") Then
		    Return True
		  ElseIf cAsc>= Asc("A") And cAsc<= Asc("Z") Then
		    Return True
		  ElseIf cAsc= Asc("_") Then
		    Return True
		  ElseIf cAsc>= &h00c0 And cAsc<= &h00d6 Then
		    Return True
		  ElseIf cAsc>= &h00d8 And cAsc<= &h00f6 Then
		    Return True
		    
		    // antlr4 https://github.com/antlr/grammars-v4/blob/master/antlr/antlr4/LexBasic.g4:
		  ElseIf cAsc>= &h0370 And cAsc<= &h037d Then
		    Return True
		  ElseIf cAsc>= &h037f And cAsc<= &h1fff Then
		    Return True
		  ElseIf cAsc>= &h200c And cAsc<= &h200d Then
		    Return True
		  ElseIf cAsc>= &h2070 And cAsc<= &h218f Then
		    Return True
		  ElseIf cAsc>= &h2c00 And cAsc<= &h2fef Then
		    Return True
		  ElseIf cAsc>= &h3001 And cAsc<= &hd7ff Then
		    Return True
		  ElseIf cAsc>= &hf900 And cAsc<= &hfdcf Then
		    Return True
		  ElseIf cAsc>= &hfdf0 And cAsc<= &hfffd Then
		    Return True
		    // antlr4
		    
		    // emojis https://en.wikipedia.org/wiki/Emoticons_(Unicode_block)
		  ElseIf cAsc>= &h1f600 And cAsc<= &h1f64f Then
		    Return True
		    // emojis
		    
		  End If
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsAlphanumeric(c As String) As Boolean
		  Return IsAlpha(c) Or IsDigit(c)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsAtEnd() As Boolean
		  Return mCurrent> mSource.Len
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsBinnary(c As String) As Boolean
		  If c= "0" Or c= "1" Then Return True
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsDigit(c As String) As Boolean
		  Dim cAsc As Integer= c.Asc
		  
		  Return cAsc>= Asc("0") And cAsc<= Asc("9")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsHexadecimal(c As String) As Boolean
		  Dim cAsc As Integer= c.Asc
		  
		  If IsDigit(c) Or (cAsc>= Asc("a") And cAsc<= Asc("f")) Or _
		    (cAsc>= Asc("A") And cAsc<= Asc("F")) Then
		    Return True
		  End If
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsOctal(c As String) As Boolean
		  Dim cAsc As Integer= c.Asc
		  
		  If (cAsc>= Asc("0") And cAsc<= Asc("7")) Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Match(expected As String) As Boolean
		  If IsAtEnd Then Return False
		  If mSource.Mid(mCurrent, 1)<> expected Then Return False // charAt
		  
		  mCurrent= mCurrent+ 1
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Number()
		  While IsDigit(Peek)
		    Call Advance
		  Wend
		  
		  // Look for a fractional part.
		  If Peek= "." And IsDigit(PeekNext) Then
		    Call Advance // Consume the "."
		    While IsDigit(Peek)
		      Call Advance
		    Wend
		  End If
		  
		  // So far we have a number (either an integer or a double). Is there a valid exponent?
		  If Peek = "e" Then
		    Select Case PeekNext
		    Case "-", "+"
		      // Advance twice to consume the `e` and sign character.
		      Call Advance
		      Call Advance
		      While IsDigit(Peek)
		        Call Advance
		      Wend
		    Case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
		      Call Advance // Advance to consume the `e`.
		      While IsDigit(Peek)
		        Call Advance
		      Wend
		    End Select
		  End If
		  
		  'Dim val1 As Double= 1.2
		  'Dim str1 As String= "1.2"
		  'Dim str2 As String= Str(val1)
		  'Dim str3 As String= Format(val1, "-###########0.0#######")
		  'Dim val2 As Double= CDbl(str1)
		  'Dim val3 As Double= Val(str1)
		  'Break
		  
		  #if TargetConsole And RBVersion< 2011.044 // chk: weird!
		    Dim value As Double= mSource.SubstringLox(mStart, mCurrent).Replace(".", ",").Val
		  #else
		    Dim value As Double= mSource.SubstringLox(mStart, mCurrent).Val
		  #endif
		  
		  AddToken TokenType.NUMBER, value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Peek() As String
		  If IsAtEnd Then Return Chr(0)
		  
		  Return mSource.Mid(mCurrent, 1) // charAt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PeekNext() As String
		  If (mCurrent+ 1)> mSource.Len Then Return Chr(0)
		  Return mSource.Mid(mCurrent+ 1, 1) // charAt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PreviousTokenIs(type As TokenType) As Boolean
		  If mTokens.Ubound= -1 Then Return False
		  If mTokens(mTokens.Ubound).TypeToken= type Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Scan() As Token()
		  While Not IsAtEnd
		    mStart= mCurrent
		    ScanToken
		  Wend
		  
		  mTokens.Append New Token(TokenType.EOF, "", Nil, mLine)
		  
		  Return mTokens
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanToken()
		  Dim c As String= Advance
		  
		  Select Case c
		  Case "("
		    AddToken TokenType.LEFT_PAREN
		  Case ")"
		    AddToken TokenType.RIGHT_PAREN
		  Case "{"
		    AddToken TokenType.LEFT_BRACE
		  Case "}"
		    AddToken TokenType.RIGHT_BRACE
		    If mInterpolationStr> 0 Then
		      mInterpolationStr= mInterpolationStr- 1
		      StringsInterpolated
		    End If
		  Case "["
		    AddToken TokenType.LEFT_BRACKET
		  Case "]"
		    AddToken TokenType.RIGHT_BRACKET
		  Case ","
		    AddToken TokenType.COMMA
		  Case "."
		    AddToken TokenType.DOT
		  Case "#"
		    If Peek= "{" Then
		      Call Advance
		      AddToken TokenType.HASHTAG_BRACE
		    End If
		    
		    // 2-char operators
		  Case "-"
		    If Peek= "=" Then
		      Call Advance
		      AddToken TokenType.MINUS_EQUAL
		    Else
		      // --ID, ---ID, ...
		      If Peek= "-" Then
		        If PreviousTokenIs(TokenType.IDENTIFIER) Then
		          Call Advance
		          AddToken TokenType.MINUS_MINUS
		        Else
		          AddToken TokenType.MINUS
		        End If
		      Else
		        AddToken TokenType.MINUS
		      End If
		      // --ID, ---ID, ...
		    End If
		  Case "+"
		    If Peek= "=" Then
		      Call Advance
		      AddToken TokenType.PLUS_EQUAL
		    Else
		      AddToken IIf(Match("+"), TokenType.PLUS_PLUS, TokenType.PLUS)
		    End If
		  Case ";"
		    AddToken TokenType.SEMICOLON
		  Case "*"
		    AddToken IIf(Match("="), TokenType.STAR_EQUAL, TokenType.STAR)
		    
		  Case "!"
		    AddToken IIf(Match("="), TokenType.BANG_EQUAL, TokenType.BANG)
		  Case "="
		    If Peek= ">" Then
		      Call Advance
		      AddToken TokenType.FAT_ARROW
		    Else
		      AddToken IIf(Match("="), TokenType.EQUAL_EQUAL, TokenType.EQUAL)
		    End If
		  Case "<"
		    If Peek= "<" Then
		      Call Advance
		      AddToken TokenType.LESS_LESS
		    Else
		      AddToken IIf(Match("="), TokenType.LESS_EQUAL, TokenType.LESS)
		    End If
		  Case ">"
		    If Peek= ">" Then
		      Call Advance
		      AddToken TokenType.GREATER_GREATER
		    Else
		      AddToken IIf(Match("="), TokenType.GREATER_EQUAL, TokenType.GREATER)
		    End If
		    // 2-char operators
		    
		    // slash or comment
		  Case "/"
		    If Match("/") Then
		      While Peek<> Chr(EOL) And Not IsAtEnd
		        Call Advance
		      Wend
		    Else
		      AddToken IIf(Match("="), TokenType.SLASH_EQUAL, TokenType.SLASH)
		    End If
		    // slash or comment
		    
		    // whitespaces, tab, newlines, etc
		  Case Chr(EOL)
		    mLine= mLine+ 1
		    
		  Case " ", Chr(9), Chr(13), Chr(10)
		    // whitespaces, tab, newlines, etc
		    
		    // strings
		  Case """"
		    StringsInterpolated
		    // strings
		    
		    // ternary, elvis
		  Case "?"
		    If Peek= ":" Then
		      Call Advance
		      AddToken TokenType.ELVIS
		    ElseIf Peek= "." Then
		      Call Advance
		      AddToken TokenType.ELVIS_DOT
		    Else
		      AddToken TokenType.QUESTION
		    End If
		  Case ":"
		    AddToken TokenType.COLON
		    // ternary
		    
		    // bitwise & |
		  Case "&"
		    AddToken TokenType.AMPERSAND
		  Case "|"
		    AddToken TokenType.PIPE
		    // bitwise & |
		    
		  Case Else
		    If c= "0" Then // 0base prefixed number
		      Dim base As String= Peek
		      
		      Select Case base
		      Case "x"
		        Call Advance
		        While IsHexadecimal(Peek)
		          Call Advance
		        Wend
		        Dim value As Double= mSource.SubstringLox(mStart+ 2, mCurrent).ValHexLox
		        AddToken TokenType.NUMBER, value
		        Return
		      Case "o"
		        Call Advance
		        While IsOctal(Peek)
		          Call Advance
		        Wend
		        Dim value As Double= Val("&o"+ mSource.SubstringLox(mStart+ 2, mCurrent))
		        AddToken TokenType.NUMBER, value
		        Return
		      Case "b"
		        Call Advance
		        While IsBinnary(Peek)
		          Call Advance
		        Wend
		        Dim value As Double= Val("&b"+ mSource.SubstringLox(mStart+ 2, mCurrent))
		        AddToken TokenType.NUMBER, value
		        Return
		      End Select
		    End If
		    
		    If IsDigit(c) Then
		      Number
		    ElseIf isAlpha(c) Then
		      Identifier
		    Else
		      Error mLine, "Unexpected character."
		      HadError= True
		    End If
		    
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Strings()
		  While Peek<> """" And Not IsAtEnd
		    If Peek= Chr(EOL) Then mLine= mLine+ 1
		    Call Advance
		  Wend
		  
		  If IsAtEnd Then
		    Error mLine, "Unterminated string."
		    HadError= True
		    Return
		  End If
		  
		  Call Advance
		  AddToken TokenType.STRING_, mSource.SubstringLox(mStart+ 1, mCurrent- 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StringsInterpolated()
		  While Peek<> """" And Not IsAtEnd
		    If Peek= Chr(EOL) Then
		      mLine= mLine+ 1
		    ElseIf Peek= "$" And PeekNext= "{" Then
		      Call Advance
		      AddToken TokenType.STRING_INTERPOLATION, mSource.SubstringLox(mStart+ 1, mCurrent- 1)
		      mInterpolationStr= mInterpolationStr+ 1
		      Return
		    End If
		    Call Advance
		  Wend
		  
		  If IsAtEnd Then
		    Error mLine, "Unterminated string."
		    HadError= True
		    Return
		  End If
		  
		  Call Advance
		  AddToken TokenType.STRING_, mSource.SubstringLox(mStart+ 1, mCurrent- 1)
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetConsole
			    Return 10 // LF
			  #else
			    Return 13 // CR
			  #endif
			End Get
		#tag EndGetter
		Shared EOL As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		HadError As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  If Not(mKeywords Is Nil) Then Return mKeywords
			  
			  mKeywords= New Lox.Misc.CSDictionary
			  
			  mKeywords.Value("and")= TokenType.AND_
			  mKeywords.Value("class")= TokenType.CLASS_
			  mKeywords.Value("else")= TokenType.ELSE_
			  mKeywords.Value("false")= TokenType.FALSE_
			  mKeywords.Value("for")= TokenType.FOR_
			  mKeywords.Value("fun")= TokenType.FUN
			  mKeywords.Value("if")= TokenType.IF_
			  mKeywords.Value("nil")= TokenType.NIL_
			  mKeywords.Value("or")= TokenType.OR_
			  mKeywords.Value("print")= TokenType.PRINT_
			  mKeywords.Value("return")= TokenType.RETURN_
			  mKeywords.Value("super")= TokenType.SUPER_
			  mKeywords.Value("this")= TokenType.THIS
			  mKeywords.Value("true")= TokenType.TRUE_
			  mKeywords.Value("var")= TokenType.VAR_
			  mKeywords.Value("while")= TokenType.WHILE_
			  mKeywords.Value("break")= TokenType.BREAK_
			  mKeywords.Value("continue")= TokenType.CONTINUE_
			  mKeywords.Value("module")= TokenType.MODULE_
			  mKeywords.Value("import")= TokenType.IMPORT
			  
			  Return mKeywords
			End Get
		#tag EndGetter
		Private Shared Keywords As Lox.Misc.CSDictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCurrent As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInterpolationStr As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mKeywords As Lox.Misc.CSDictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLine As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSource As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStart As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTokens() As Token
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="HadError"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
