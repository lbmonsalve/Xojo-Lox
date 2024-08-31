#tag Class
Protected Class Parser
	#tag Method, Flags = &h21
		Private Function Advance() As Token
		  If Not IsAtEnd Then mCurrent= mCurrent+ 1
		  Return Previous
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function and_() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= equality
		  
		  While Match(TokenType.AND_)
		    Dim operator As Token= Previous
		    Dim right As Lox.Ast.Expr= equality
		    expr= New Lox.Ast.Logical(expr, operator, right)
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function assignment() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= or_
		  
		  If Match(TokenType.EQUAL) Then
		    Dim equals As Token= Previous
		    Dim value As Lox.Ast.Expr= assignment
		    
		    If expr IsA Lox.Ast.Variable Then
		      Dim name As Token= Lox.Ast.Variable(expr).Name
		      
		      Return New Lox.Ast.Assign(name, value)
		    End If
		    
		    Error equals, "Invalid assignment target."
		  End If
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function block() As Lox.Ast.Stmt()
		  Dim statements() As Lox.Ast.Stmt
		  
		  While (Not Check(TokenType.RIGHT_BRACE)) And (Not IsAtEnd)
		    statements.Append declaration
		  Wend
		  
		  Call consume TokenType.RIGHT_BRACE, "Expect '}' after block."
		  
		  Return statements
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function call_() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= primary
		  
		  While True
		    If Match(TokenType.LEFT_PAREN) Then
		      expr= finishCall(expr)
		    Else
		      Exit
		    End If
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Check(type As TokenType) As Boolean
		  If IsAtEnd Then Return False
		  
		  Return Peek.TypeToken= type
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function comparison() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= term
		  
		  While Match(TokenType.GREATER, TokenType.GREATER_EQUAL, TokenType.LESS, TokenType.LESS_EQUAL)
		    Dim operator As Token= previous
		    Dim right As Lox.Ast.Expr= term
		    expr= New Lox.Ast.Binary(expr, operator, right)
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(tokens() As Token)
		  mTokens= tokens
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function consume(type As TokenType, message As String) As Token
		  If Check(type) Then Return Advance
		  
		  Raise Error(Peek, message)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function declaration() As Lox.Ast.Stmt
		  Try
		    If Match(TokenType.FUN) Then Return function_("function")
		    If Match(TokenType.VAR_) Then Return varDeclaration
		    
		    Return statement
		  Catch exc As ParseError
		    Synchronize
		    Return Nil
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function equality() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= comparison
		  
		  While Match(TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL)
		    Dim operator As Token= previous
		    Dim right As Lox.Ast.Expr= comparison
		    expr= New Lox.Ast.Binary(expr, operator, right)
		  Wend
		  
		  Return expr
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
		  Call consume TokenType.SEMICOLON, "Expect ';' after expression."
		  
		  Return New Lox.Ast.Expression(expr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function factor() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= unary
		  
		  While Match(TokenType.SLASH, TokenType.STAR)
		    Dim operator As Token= previous
		    Dim right As Lox.Ast.Expr= unary
		    expr= New Lox.Ast.Binary(expr, operator, right)
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function finishCall(callee As Lox.Ast.Expr) As Lox.Ast.Expr
		  Dim arguments() As Lox.Ast.Expr
		  If Not (check(TokenType.RIGHT_PAREN)) Then
		    Do
		      If arguments.Ubound>= 254 Then Error(Peek, "Can't have more than 255 arguments.")
		      arguments.Append expression
		    Loop Until Not Match(TokenType.COMMA)
		  End If
		  
		  Dim paren As Token= consume(TokenType.RIGHT_PAREN, "Expect ')' after arguments.")
		  
		  Return New Lox.Ast.CallExpr(callee, paren, arguments)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function forStatement() As Lox.Ast.Stmt
		  Call consume TokenType.LEFT_PAREN, "Expect '(' after 'for'."
		  
		  Dim initializer As Lox.Ast.Stmt
		  If Match(TokenType.SEMICOLON) Then
		  ElseIf Match(TokenType.VAR_) Then
		    initializer= varDeclaration
		  Else
		    initializer= expressionStatement
		  End If
		  
		  Dim condition As Lox.Ast.Expr
		  If Not Check(TokenType.SEMICOLON) Then condition= expression
		  Call consume TokenType.SEMICOLON, "Expect ';' after loop condition."
		  
		  Dim increment As Lox.Ast.Expr
		  If Not Check(TokenType.RIGHT_PAREN) Then increment= expression
		  Call consume TokenType.RIGHT_PAREN, "Expect ')' after for clauses."
		  
		  Dim body As Lox.Ast.Stmt= statement
		  
		  If Not (increment IS Nil) Then
		    Dim stmts() As Lox.Ast.Stmt
		    stmts.Append body
		    stmts.Append New Lox.Ast.Expression(increment)
		    body= New Lox.Ast.Block(stmts)
		  End If
		  
		  If condition Is Nil Then condition= New Lox.Ast.Literal(True)
		  body= New Lox.Ast.WhileStmt(condition, body)
		  
		  If Not (initializer Is Nil) Then
		    Dim stmts() As Lox.Ast.Stmt
		    stmts.Append initializer
		    stmts.Append body
		    body= New Lox.Ast.Block(stmts)
		  End If
		  
		  Return body
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function function_(kind As String) As Lox.Ast.FunctionStmt
		  Dim name As Token= consume(TokenType.IDENTIFIER, "Expect "+ kind+ " name.")
		  
		  Call consume TokenType.LEFT_PAREN, "Expect '(' after "+ kind+ " name."
		  Dim parameters() As Token
		  If Not Check(TokenType.RIGHT_PAREN) Then
		    Do
		      If parameters.Count>= 255 Then
		        Error Peek, "Can't have more than 255 parameters."
		      End If
		      
		      parameters.Append consume(TokenType.IDENTIFIER, "Expect parameter name.")
		    Loop Until Not Match(TokenType.COMMA)
		  End If
		  Call consume TokenType.RIGHT_PAREN, "Expect ')' after parameters."
		  
		  Call consume TokenType.LEFT_BRACE, "Expect '{' before "+ kind+ " body."
		  Dim body() As Lox.Ast.Stmt= block
		  
		  Return New Lox.Ast.FunctionStmt(name, parameters, body)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ifStatement() As Lox.Ast.Stmt
		  Call consume TokenType.LEFT_PAREN, "Expect '(' after 'if'."
		  Dim condition As Lox.Ast.Expr= expression
		  Call consume TokenType.RIGHT_PAREN, "Expect ')' after if condition."
		  
		  Dim thenBranch As Lox.Ast.Stmt= statement
		  Dim elseBranch As Lox.Ast.Stmt
		  If Match(TokenType.ELSE_) Then elseBranch= statement
		  
		  Return New Lox.Ast.IfStmt(condition, thenBranch, elseBranch)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsAtEnd() As Boolean
		  Return Peek.TypeToken= TokenType.EOF
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Match(ParamArray types As TokenType) As Boolean
		  For Each type As TokenType In types
		    If Check(type) Then
		      Call Advance
		      Return True
		    End If
		  Next
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function or_() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= and_
		  
		  While Match(TokenType.OR_)
		    Dim operator As Token= Previous
		    Dim right As Lox.Ast.Expr= and_
		    expr= New Lox.Ast.Logical(expr, operator, right)
		  Wend
		  
		  Return expr
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
		Private Function Peek() As Token
		  Return mTokens(mCurrent)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Previous() As Token
		  Return mTokens(mCurrent- 1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function primary() As Lox.Ast.Expr
		  If Match(TokenType.FALSE_) Then Return New Lox.Ast.Literal(False)
		  If Match(TokenType.TRUE_) Then Return New Lox.Ast.Literal(True)
		  If Match(TokenType.NIL_) Then Return New Lox.Ast.Literal(Nil)
		  
		  If Match(TokenType.NUMBER, TokenType.STRING_) Then Return New Lox.Ast.Literal(previous.Literal)
		  
		  If Match(TokenType.IDENTIFIER) Then Return New Lox.Ast.Variable(Previous)
		  
		  If Match(TokenType.LEFT_PAREN) Then
		    Dim expr As Lox.Ast.Expr= expression
		    Call consume(TokenType.RIGHT_PAREN, "Expect ')' after expression.")
		    Return New Lox.Ast.Grouping(expr)
		  End If
		  
		  Raise Error(Peek, "Expect expression.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function printStatement() As Lox.Ast.Stmt
		  Dim value As Lox.Ast.Expr= expression
		  Call consume TokenType.SEMICOLON, "Expect ';' after value."
		  
		  Return New Lox.Ast.Print(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function returnStatement() As Lox.Ast.Stmt
		  Dim keyword As Token= Previous
		  Dim value As Lox.Ast.Expr
		  If Not Check(TokenType.SEMICOLON) Then value= expression
		  
		  Call consume TokenType.SEMICOLON, "Expect ';' after return value."
		  
		  Return New Lox.Ast.ReturnStmt(keyword, value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function statement() As Lox.Ast.Stmt
		  If Match(TokenType.FOR_) Then Return forStatement
		  If Match(TokenType.IF_) Then Return ifStatement
		  If Match(TokenType.PRINT_) Then Return printStatement
		  If Match(TokenType.RETURN_) Then Return returnStatement
		  If Match(TokenType.WHILE_) Then Return whileStatement
		  If Match(TokenType.LEFT_BRACE) Then Return New Lox.Ast.Block(block)
		  
		  Return expressionStatement
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Synchronize()
		  Call Advance
		  
		  While Not IsAtEnd
		    If Previous.TypeToken= TokenType.SEMICOLON Then Return
		    
		    Select Case Peek.TypeToken
		    Case TokenType.CLASS_, TokenType.FUN, TokenType.VAR_, _
		      TokenType.FOR_, TokenType.IF_, TokenType.WHILE_, _
		      TokenType.PRINT_, TokenType.RETURN_
		      Return
		    End Select
		    
		    Call Advance
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function term() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= factor
		  
		  While Match(TokenType.MINUS, TokenType.PLUS)
		    Dim operator As Token= previous
		    Dim right As Lox.Ast.Expr= factor
		    expr= New Lox.Ast.Binary(expr, operator, right)
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function unary() As Lox.Ast.Expr
		  If Match(TokenType.BANG, TokenType.MINUS) Then
		    Dim operator As Token= previous
		    Dim right As Lox.Ast.Expr= unary
		    Return New Lox.Ast.Unary(operator, right)
		  End If
		  
		  Return call_
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function varDeclaration() As Lox.Ast.Stmt
		  Dim name As Token= consume(TokenType.IDENTIFIER, "Expect variable name.")
		  
		  Dim initializer As Lox.Ast.Expr
		  If Match(TokenType.EQUAL) Then initializer= expression
		  
		  Call consume(TokenType.SEMICOLON, "Expect ';' after variable declaration.")
		  Return New Lox.Ast.VarStmt(name, initializer)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function whileStatement() As Lox.Ast.Stmt
		  Call consume TokenType.LEFT_PAREN, "Expect '(' after 'while'."
		  Dim condition As Lox.Ast.Expr= expression
		  Call consume TokenType.RIGHT_PAREN, "Expect ')' after condition."
		  Dim body As Lox.Ast.Stmt= statement
		  
		  Return New Lox.Ast.WhileStmt(condition, body)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCurrent As Integer
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
