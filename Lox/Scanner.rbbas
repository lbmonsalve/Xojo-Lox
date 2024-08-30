#tag Class
Protected Class Scanner
	#tag Method, Flags = &h21
		Private Sub AddToken(type As TokenType)
		  AddToken type, Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddToken(type As TokenType, literal As Variant)
		  Dim text As String= mSource.Substring(mStart, mCurrent)
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
		  mSource= source
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Identifier()
		  While IsAlphanumeric(Peek)
		    Call Advance
		  Wend
		  
		  Dim text As String= mSource.Substring(mStart, mCurrent)
		  Dim type As TokenType= Keywords.Lookup(text, TokenType.IDENTIFIER)
		  
		  AddToken type
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsAlpha(c As String) As Boolean
		  Dim cAsc As Integer= c.Asc
		  
		  Return (cAsc>= Asc("a") And cAsc<= Asc("z")) Or _
		  (cAsc>= Asc("A") And cAsc<= Asc("Z")) Or _
		  cAsc= Asc("_")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsAlphanumeric(c As String) As Boolean
		  Return IsAlpha(c) Or IsDigit(c)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsAtEnd() As Boolean
		  Return mCurrent> mSource.Len
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsDigit(c As String) As Boolean
		  Dim cAsc As Integer= c.Asc
		  
		  Return cAsc>= Asc("0") And cAsc<= Asc("9")
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
		  
		  'Dim val1 As Double= 1.2
		  'Dim str1 As String= "1.2"
		  'Dim str2 As String= Str(val1)
		  'Dim str3 As String= Format(val1, "-###########0.0#######")
		  'Dim val2 As Double= CDbl(str1)
		  'Dim val3 As Double= Val(str1)
		  'Break
		  
		  #if TargetConsole And RBVersion< 2011.044 // chk: weird!
		    Dim value As Double= mSource.Substring(mStart, mCurrent).Replace(".", ",").Val
		  #else
		    Dim value As Double= mSource.Substring(mStart, mCurrent).Val
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
		  #if TargetConsole
		    Const EOL= 10 // LF
		  #else
		    Const EOL= 13 // CR
		  #endif
		  
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
		  Case ","
		    AddToken TokenType.COMMA
		  Case "."
		    AddToken TokenType.DOT
		  Case "-"
		    AddToken TokenType.MINUS
		  Case "+"
		    AddToken TokenType.PLUS
		  Case ";"
		    AddToken TokenType.SEMICOLON
		  Case "*"
		    AddToken TokenType.STAR
		    
		    // 2-char operators
		  Case "!"
		    AddToken IIf(Match("="), TokenType.BANG_EQUAL, TokenType.BANG)
		  Case "="
		    AddToken IIf(Match("="), TokenType.EQUAL_EQUAL, TokenType.EQUAL)
		  Case "<"
		    AddToken IIf(Match("="), TokenType.LESS_EQUAL, TokenType.LESS)
		  Case ">"
		    AddToken IIf(Match("="), TokenType.GREATER_EQUAL, TokenType.GREATER)
		    // 2-char operators
		    
		    // slash or comment
		  Case "/"
		    If Match("/") Then
		      While Peek<> Chr(EOL) And Not IsAtEnd
		        Call Advance
		      Wend
		    Else
		      AddToken TokenType.SLASH
		    End If
		    // slash or comment
		    
		    // whitespaces, tab, newlines, etc
		  Case " ", Chr(13), Chr(9)
		  Case Chr(EOL)
		    mLine= mLine+ 1
		    // whitespaces, tab, newlines, etc
		    
		    // strings
		  Case """"
		    Strings
		    // strings
		    
		  Case Else
		    If IsDigit(c) Then
		      Number
		    ElseIf isAlpha(c) Then
		      Identifier
		    Else
		      Error mLine, "Unexpected character."
		    End If
		    
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Strings()
		  #if TargetConsole
		    Const EOL= 10 // LF
		  #else
		    Const EOL= 13 // CR
		  #endif
		  
		  While Peek<> """" And Not IsAtEnd
		    If Peek= Chr(EOL) Then mLine= mLine+ 1
		    Call Advance
		  Wend
		  
		  If IsAtEnd Then
		    Error mLine, "Unterminated string."
		    Return
		  End If
		  
		  Call Advance
		  
		  AddToken TokenType.STRING_, mSource.Substring(mStart+ 1, mCurrent- 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Tokens() As Token()
		  Return mTokens
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  If Not(mKeywords Is Nil) Then Return mKeywords
			  
			  mKeywords= New Dictionary
			  
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
			  
			  Return mKeywords
			End Get
		#tag EndGetter
		Private Shared Keywords As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCurrent As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mKeywords As Dictionary
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
