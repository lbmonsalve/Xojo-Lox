#tag Class
Protected Class Parser
	#tag Method, Flags = &h21
		Private Function Advance() As Lox.Lexical.Token
		  If Not IsAtEnd Then mCurrent= mCurrent+ 1
		  Return Previous
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function assignment() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= equality
		  
		  If Match(Lox.TokenType.EQUAL) Then
		    Dim equals As Lox.Lexical.Token= Previous
		    Dim value As Lox.Ast.Expr= assignment
		    
		    If expr IsA Lox.Ast.Variable Then
		      Dim name As Lox.Lexical.Token= Lox.Ast.Variable(value).Name
		      
		      Return New Lox.Ast.Assign(name, value)
		    End If
		    
		    Error equals, "Invalid assignment target."
		  End If
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Block() As Lox.Ast.Stmt()
		  Dim statements() As Lox.Ast.Stmt
		  
		  While (Not Check(Lox.TokenType.RIGHT_BRACE)) And (Not IsAtEnd)
		    statements.Append declaration
		  Wend
		  
		  Call consume Lox.TokenType.RIGHT_BRACE, "Expect '}' after block."
		  
		  Return statements
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
		Private Function declaration() As Lox.Ast.Stmt
		  Try
		    #pragma BreakOnExceptions Off
		    
		    If Match(Lox.TokenType.VAR_) Then Return varDeclaration
		    
		    Return statement
		    #pragma BreakOnExceptions Default
		  Catch exc As ParseError
		    Synchronize
		    Return Nil
		  End Try
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
		  Return assignment
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function expressionStatement() As Lox.Ast.Stmt
		  Dim expr As Lox.Ast.Expr= expression
		  Call consume Lox.TokenType.SEMICOLON, "Expect ';' after expression."
		  
		  Return New Lox.Ast.Expression(expr)
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
		Function Parse() As Lox.Ast.Stmt()
		  Dim statements() As Lox.Ast.Stmt
		  While Not IsAtEnd
		    statements.Append declaration
		  Wend
		  
		  Return statements
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
		  
		  If Match(Lox.TokenType.IDENTIFIER) Then Return New Lox.Ast.Variable(Previous)
		  
		  If Match(Lox.TokenType.LEFT_PAREN) Then
		    Dim expr As Lox.Ast.Expr= expression
		    Call consume(Lox.TokenType.RIGHT_PAREN, "Expect ')' after expression.")
		    Return New Lox.Ast.Grouping(expr)
		  End If
		  
		  Raise Error(Peek, "Expect expression.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function printStatement() As Lox.Ast.Stmt
		  Dim value As Lox.Ast.Expr= expression
		  Call consume Lox.TokenType.SEMICOLON, "Expect ';' after value."
		  
		  Return New Lox.Ast.Print(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function statement() As Lox.Ast.Stmt
		  If Match(Lox.TokenType.PRINT_) Then Return printStatement
		  If Match(Lox.TokenType.LEFT_BRACE) Then Return New Lox.Ast.Block(Block)
		  
		  Return expressionStatement
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

	#tag Method, Flags = &h21
		Private Function varDeclaration() As Lox.Ast.Stmt
		  Dim name As Lox.Lexical.Token= consume(Lox.TokenType.IDENTIFIER, "Expect variable name.")
		  
		  Dim initializer As Lox.Ast.Expr
		  If Match(Lox.TokenType.EQUAL) Then initializer= expression
		  
		  Call consume(Lox.TokenType.SEMICOLON, "Expect ';' after variable declaration.")
		  Return New Lox.Ast.VarStmt(name, initializer)
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
