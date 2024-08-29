#tag Class
Protected Class Parser
	#tag Method, Flags = &h21
		Private Function Advance() As Lox.Lexical.Token
		  If Not IsAtEnd Then mCurrent= mCurrent+ 1
		  Return Previous
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Check(type As Lox.TokenType) As Boolean
		  If IsAtEnd Then Return False
		  
		  Return Peek.TypeToken= type
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function comparison() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= term
		  
		  While Match(Lox.TokenType.GREATER, Lox.TokenType.GREATER_EQUAL, Lox.TokenType.LESS, Lox.TokenType.LESS_EQUAL)
		    Dim operator As Lox.Lexical.Token= previous
		    Dim right As Lox.Ast.Expr= term
		    expr= New Lox.Ast.Binary(expr, operator, right)
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(tokens() As Lox.Lexical.Token)
		  mTokens= tokens
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function consume(type As Lox.TokenType, message As String) As Lox.Lexical.Token
		  If Check(type) Then Return Advance
		  
		  Raise Error(Peek, message)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function equality() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= comparison
		  
		  While Match(Lox.TokenType.BANG_EQUAL, Lox.TokenType.EQUAL_EQUAL)
		    Dim operator As Lox.Lexical.Token= previous
		    Dim right As Lox.Ast.Expr= comparison
		    expr= New Lox.Ast.Binary(expr, operator, right)
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Error(token As Lox.Lexical.Token, message As String)
		  If token.TypeToken= Lox.TokenType.EOF Then
		    Report token.Line, " at end", message
		  Else
		    Report token.Line, " at '"+ token.Lexeme+ "'", message
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Error(token As Lox.Lexical.Token, message As String) As ParseError
		  Error token, message
		  
		  Return New ParseError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function expression() As Lox.Ast.Expr
		  Return equality
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function factor() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= unary
		  
		  While Match(Lox.TokenType.SLASH, Lox.TokenType.STAR)
		    Dim operator As Lox.Lexical.Token= previous
		    Dim right As Lox.Ast.Expr= unary
		    expr= New Lox.Ast.Binary(expr, operator, right)
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsAtEnd() As Boolean
		  Return Peek.TypeToken= Lox.TokenType.EOF
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Match(ParamArray types As Lox.TokenType) As Boolean
		  For Each type As Lox.TokenType In types
		    If Check(type) Then
		      Call Advance
		      Return True
		    End If
		  Next
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Parse() As Lox.Ast.Expr
		  Try
		    #pragma BreakOnExceptions Off
		    Return expression
		    #pragma BreakOnExceptions Default
		  Catch exc As ParseError
		    Return Nil
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Peek() As Lox.Lexical.Token
		  Return mTokens(mCurrent)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Previous() As Lox.Lexical.Token
		  Return mTokens(mCurrent- 1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function primary() As Lox.Ast.Expr
		  If Match(Lox.TokenType.FALSE_) Then Return New Lox.Ast.Literal(False)
		  If Match(Lox.TokenType.TRUE_) Then Return New Lox.Ast.Literal(True)
		  If Match(Lox.TokenType.NIL_) Then Return New Lox.Ast.Literal(Nil)
		  
		  If Match(Lox.TokenType.NUMBER, Lox.TokenType.STRING_) Then Return New Lox.Ast.Literal(previous.Literal)
		  
		  If Match(Lox.TokenType.LEFT_PAREN) Then
		    Dim expr As Lox.Ast.Expr= expression
		    Call consume(Lox.TokenType.RIGHT_PAREN, "Expect ')' after expression.")
		    Return New Lox.Ast.Grouping(expr)
		  End If
		  
		  Raise Error(Peek, "Expect expression.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Synchronize()
		  Call Advance
		  
		  While Not IsAtEnd
		    If Previous.TypeToken= Lox.TokenType.SEMICOLON Then Return
		    
		    Select Case Peek.TypeToken
		    Case Lox.TokenType.CLASS_, Lox.TokenType.FUN, Lox.TokenType.VAR_, _
		      Lox.TokenType.FOR_, Lox.TokenType.IF_, Lox.TokenType.WHILE_, _
		      Lox.TokenType.PRINT_, Lox.TokenType.RETURN_
		      Return
		    End Select
		    
		    Call Advance
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function term() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= factor
		  
		  While Match(Lox.TokenType.MINUS, Lox.TokenType.PLUS)
		    Dim operator As Lox.Lexical.Token= previous
		    Dim right As Lox.Ast.Expr= factor
		    expr= New Lox.Ast.Binary(expr, operator, right)
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function unary() As Lox.Ast.Expr
		  If Match(Lox.TokenType.BANG, Lox.TokenType.MINUS) Then
		    Dim operator As Lox.Lexical.Token= previous
		    Dim right As Lox.Ast.Expr= unary
		    Return New Lox.Ast.Unary(operator, right)
		  End If
		  
		  Return primary
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCurrent As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTokens() As Lox.Lexical.Token
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
