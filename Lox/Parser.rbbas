#tag Class
Protected Class Parser
	#tag Method, Flags = &h21
		Private Function Advance() As Token
		  If Not IsAtEnd Then mCurrent= mCurrent+ 1
		  Return Previous
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function assignment() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= elvis
		  
		  If Match(TokenType.LEFT_BRACKET) Then // array?
		    Break
		    // idx
		    Dim idx As Lox.Ast.Expr= elvis
		    // idx
		    Call consume TokenType.RIGHT_BRACKET, "Expect ']' after elements."
		    
		    If expr IsA Lox.Ast.Variable Then
		      expr= New Lox.Ast.ArrayExpr(Lox.Ast.Variable(expr).Name, idx)
		    ElseIf expr IsA Lox.Ast.Get Then
		      'expr= New Lox.Ast.ArrayExpr(Lox.Ast.Get(expr).Name, idx)
		      Break // TODO:
		      Dim getExpr As Lox.Ast.Get= Lox.Ast.Get(expr)
		      Dim arrExpr As New Lox.Ast.ArrayExpr(getExpr.Name, idx)
		      expr= New Lox.Ast.Set(getExpr.Obj, getExpr.Name, arrExpr)
		    Else
		      Break // TODO:
		    End If
		    
		  End If
		  
		  If Match(TokenType.HASHTAG_BRACE) Then // hashmap?
		    // idx
		    Dim idx As Lox.Ast.Expr= elvis
		    // idx
		    Call consume TokenType.RIGHT_BRACE, "Expect '}' after elements."
		    
		    If expr IsA Lox.Ast.Variable Then
		      expr= New Lox.Ast.HashMapExpr(Lox.Ast.Variable(expr).Name, idx)
		    Else // TODO:
		      HadError= True
		      #pragma BreakOnExceptions Off
		      Raise Error(Peek, "only for variables.")
		    End If
		  End If
		  
		  If Match(TokenType.EQUAL, TokenType.PLUS_EQUAL, TokenType.MINUS_EQUAL, _
		    TokenType.STAR_EQUAL, TokenType.SLASH_EQUAL) Then
		    
		    expr= GetAssignmentOper(expr, Previous)
		  End If
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function bitwise() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= term // TODO:
		  
		  While Match(TokenType.AMPERSAND, _
		    TokenType.PIPE, TokenType.LESS_LESS, TokenType.GREATER_GREATER)
		    Dim operator As Token= Previous
		    Dim right As Lox.Ast.Expr= term
		    expr= New Lox.Ast.Binary(expr, operator, right)
		  Wend
		  
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
		Private Function breakStmt() As Lox.Ast.Stmt
		  Dim keyword As Token= Previous
		  Call consume TokenType.SEMICOLON, "Expect ';' after return value."
		  
		  Return New Lox.Ast.BreakStmt(keyword)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function call_() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= suscript
		  
		  While True
		    If Match(TokenType.LEFT_PAREN) Then
		      expr= finishCall(expr)
		    ElseIf Match(TokenType.DOT) Then
		      Dim name As Token= consume(TokenType.IDENTIFIER, "Expect property name after '.'.")
		      expr= New Lox.Ast.Get(name, expr)
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
		Private Function CheckNext(type As TokenType) As Boolean
		  If IsAtEnd Then Return False
		  If mTokens(mCurrent+ 1).TypeToken= TokenType.EOF Then Return False
		  
		  Return mTokens(mCurrent+ 1).TypeToken= type
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function classDecl() As Lox.Ast.Stmt
		  Dim name As Token= consume(TokenType.IDENTIFIER, "Expect class name.")
		  
		  Dim superClass As Lox.Ast.Variable
		  If Match(TokenType.LESS) Then
		    Call consume TokenType.IDENTIFIER, "Expect superclass name."
		    superClass= New Lox.Ast.Variable(Previous)
		  End If
		  
		  Call consume TokenType.LEFT_BRACE, "Expect '{' before class body."
		  
		  Dim methods() As Lox.Ast.FunctionStmt
		  Dim classMethods() As Lox.Ast.FunctionStmt
		  
		  While Not Check(TokenType.RIGHT_BRACE) And Not IsAtEnd
		    Dim isClassMethod As Boolean= Match(TokenType.CLASS_)
		    If isClassMethod Then
		      classMethods.Append funDecl("method")
		    Else
		      methods.Append funDecl("method")
		    End If
		  Wend
		  
		  Call consume TokenType.RIGHT_BRACE, "Expect '}' after class body."
		  
		  Return New Lox.Ast.ClassStmt(name, superClass, methods, classMethods)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function comparison() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= bitwise
		  
		  While Match(TokenType.GREATER, TokenType.GREATER_EQUAL, TokenType.LESS, TokenType.LESS_EQUAL)
		    Dim operator As Token= Previous
		    Dim right As Lox.Ast.Expr= bitwise
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
		  
		  HadError= True
		  #pragma BreakOnExceptions Off
		  Raise Error(Peek, message)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function continueStmt() As Lox.Ast.Stmt
		  Dim keyword As Token= Previous
		  Call consume TokenType.SEMICOLON, "Expect ';' after return value."
		  
		  Return New Lox.Ast.ContinueStmt(keyword)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function declaration() As Lox.Ast.Stmt
		  Try
		    If Match(TokenType.IMPORT) Then Return importDecl
		    If Match(TokenType.MODULE_) Then Return moduleDecl
		    If Match(TokenType.CLASS_) Then Return classDecl
		    If Check(TokenType.FUN) And CheckNext(TokenType.IDENTIFIER) Then
		      Call consume TokenType.FUN, ""
		      Return funDecl("function")
		    End If
		    If Match(TokenType.VAR_) Then Return varDecl
		    
		    Return statement
		  Catch exc As ParseError
		    Synchronize
		    Return Nil
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function elvis() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= ternary
		  
		  While Match(TokenType.ELVIS, TokenType.ELVIS_DOT)
		    Dim elvis As Token= Previous
		    Dim right As Lox.Ast.Expr= ternary
		    
		    If elvis.TypeToken= TokenType.ELVIS Then
		      expr= New Lox.Ast.Elvis(expr, elvis, right)
		    Else
		      expr= New Lox.Ast.ElvisDot(expr, elvis, right)
		    End If
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function equality() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= comparison
		  
		  While Match(TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL)
		    Dim operator As Token= Previous
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
		Private Function exprStmt() As Lox.Ast.Stmt
		  Dim expr As Lox.Ast.Expr= expression
		  
		  If mAllowExpression And IsAtEnd Then
		    mFoundExpression= True
		  Else
		    Call consume TokenType.SEMICOLON, "Expect ';' after expression."
		  End If
		  
		  Return New Lox.Ast.Expression(expr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function factor() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= unary
		  
		  While Match(TokenType.SLASH, TokenType.STAR)
		    Dim operator As Token= Previous
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
		      If arguments.Ubound>= 254 Then
		        Error Peek, "Can't have more than 255 arguments."
		        HadError= True
		      End If
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
		    initializer= varDecl
		  Else
		    initializer= exprStmt
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
		Private Function functionBody(kind As String) As Lox.Ast.FunctionExpr
		  Call consume TokenType.LEFT_PAREN, "Expect '(' after "+ kind+ " name."
		  Dim parameters() As Token
		  If Not Check(TokenType.RIGHT_PAREN) Then
		    Do
		      If parameters.Count>= 255 Then
		        Error Peek, "Can't have more than 255 parameters."
		        HadError= True
		      End If
		      parameters.Append consume(TokenType.IDENTIFIER, "Expect parameter name.")
		    Loop Until Not (Match(TokenType.COMMA))
		  End If
		  Call consume TokenType.RIGHT_PAREN, "Expect ')' after parameters."
		  
		  Call consume TokenType.LEFT_BRACE, "Expect '{' before "+ kind+ " body."
		  Dim body() As Lox.Ast.Stmt= block
		  Return New Lox.Ast.FunctionExpr(parameters, body)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function funDecl(kind As String) As Lox.Ast.FunctionStmt
		  Dim name As Token= consume(TokenType.IDENTIFIER, "Expect "+ kind+ " name.")
		  Return New Lox.Ast.FunctionStmt(name, functionBody(kind))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetAssignmentOper(expr As Lox.Ast.Expr, equals As Token) As Lox.Ast.Expr
		  // TODO: refactor this
		  
		  If equals.TypeToken= TokenType.EQUAL Then
		    Dim value As Lox.Ast.Expr= assignment
		    
		    If expr IsA Lox.Ast.Variable Then
		      Dim name As Token= Lox.Ast.Variable(expr).Name
		      Return New Lox.Ast.Assign(name, value)
		    ElseIf expr IsA Lox.Ast.Get Then
		      Dim getExpr As Lox.Ast.Get= Lox.Ast.Get(expr)
		      Return New Lox.Ast.Set(getExpr.Obj, getExpr.Name, value)
		    ElseIf expr IsA Lox.Ast.ArrayExpr Then
		      Dim name As Token= Lox.Ast.ArrayExpr(expr).Name
		      Return New Lox.Ast.ArrayAssign(name, Lox.Ast.ArrayExpr(expr).Index, equals, value)
		    ElseIf expr IsA Lox.Ast.HashMapExpr Then
		      Dim name As Token= Lox.Ast.HashMapExpr(expr).Name
		      Return New Lox.Ast.HashMapAssign(name, Lox.Ast.HashMapExpr(expr).Key, equals, value)
		    End If
		    
		    Error equals, "Invalid assignment target."
		    HadError= True
		  ElseIf equals.TypeToken= TokenType.PLUS_EQUAL Then
		    Dim value As Lox.Ast.Expr= assignment
		    
		    If expr IsA Lox.Ast.Variable Then
		      Dim name As Token= Lox.Ast.Variable(expr).Name
		      Dim oper As New Token(TokenType.PLUS, "+", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.Assign(name, binn)
		    ElseIf expr IsA Lox.Ast.Get Then
		      Dim getExpr As Lox.Ast.Get= Lox.Ast.Get(expr)
		      Dim oper As New Token(TokenType.PLUS, "+", Nil, getExpr.Name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.Set(getExpr.Obj, getExpr.Name, binn)
		    ElseIf expr IsA Lox.Ast.ArrayExpr Then
		      Dim name As Token= Lox.Ast.ArrayExpr(expr).Name
		      Dim oper As New Token(TokenType.PLUS, "+", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.ArrayAssign(name, Lox.Ast.ArrayExpr(expr).Index, equals, binn)
		    ElseIf expr IsA Lox.Ast.HashMapExpr Then
		      Dim name As Token= Lox.Ast.HashMapExpr(expr).Name
		      Dim oper As New Token(TokenType.PLUS, "+", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.HashMapAssign(name, Lox.Ast.HashMapExpr(expr).Key, equals, binn)
		    End If
		    
		    Error equals, "Invalid assignment target."
		    HadError= True
		  ElseIf equals.TypeToken= TokenType.MINUS_EQUAL Then
		    Dim value As Lox.Ast.Expr= assignment
		    
		    If expr IsA Lox.Ast.Variable Then
		      Dim name As Token= Lox.Ast.Variable(expr).Name
		      Dim oper As New Token(TokenType.MINUS, "-", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.Assign(name, binn)
		    ElseIf expr IsA Lox.Ast.Get Then
		      Dim getExpr As Lox.Ast.Get= Lox.Ast.Get(expr)
		      Dim oper As New Token(TokenType.MINUS, "-", Nil, getExpr.Name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.Set(getExpr.Obj, getExpr.Name, binn)
		    ElseIf expr IsA Lox.Ast.ArrayExpr Then
		      Dim name As Token= Lox.Ast.ArrayExpr(expr).Name
		      Dim oper As New Token(TokenType.MINUS, "-", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.ArrayAssign(name, Lox.Ast.ArrayExpr(expr).Index, equals, binn)
		    ElseIf expr IsA Lox.Ast.HashMapExpr Then
		      Dim name As Token= Lox.Ast.HashMapExpr(expr).Name
		      Dim oper As New Token(TokenType.MINUS, "-", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.HashMapAssign(name, Lox.Ast.HashMapExpr(expr).Key, equals, binn)
		    End If
		    
		    Error equals, "Invalid assignment target."
		    HadError= True
		  ElseIf equals.TypeToken= TokenType.STAR_EQUAL Then
		    Dim value As Lox.Ast.Expr= assignment
		    
		    If expr IsA Lox.Ast.Variable Then
		      Dim name As Token= Lox.Ast.Variable(expr).Name
		      Dim oper As New Token(TokenType.STAR, "*", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.Assign(name, binn)
		    ElseIf expr IsA Lox.Ast.Get Then
		      Dim getExpr As Lox.Ast.Get= Lox.Ast.Get(expr)
		      Dim oper As New Token(TokenType.STAR, "*", Nil, getExpr.name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.Set(getExpr.Obj, getExpr.Name, binn)
		    ElseIf expr IsA Lox.Ast.ArrayExpr Then
		      Dim name As Token= Lox.Ast.ArrayExpr(expr).Name
		      Dim oper As New Token(TokenType.STAR, "*", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.ArrayAssign(name, Lox.Ast.ArrayExpr(expr).Index, equals, binn)
		    ElseIf expr IsA Lox.Ast.HashMapExpr Then
		      Dim name As Token= Lox.Ast.HashMapExpr(expr).Name
		      Dim oper As New Token(TokenType.STAR, "*", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.HashMapAssign(name, Lox.Ast.HashMapExpr(expr).Key, equals, binn)
		    End If
		    
		    Error equals, "Invalid assignment target."
		    HadError= True
		  ElseIf equals.TypeToken= TokenType.SLASH_EQUAL Then
		    Dim value As Lox.Ast.Expr= assignment
		    
		    If expr IsA Lox.Ast.Variable Then
		      Dim name As Token= Lox.Ast.Variable(expr).Name
		      Dim oper As New Token(TokenType.SLASH, "/", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.Assign(name, binn)
		    ElseIf expr IsA Lox.Ast.Get Then
		      Dim getExpr As Lox.Ast.Get= Lox.Ast.Get(expr)
		      Dim oper As New Token(TokenType.SLASH, "/", Nil, getExpr.name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.Set(getExpr.Obj, getExpr.Name, binn)
		    ElseIf expr IsA Lox.Ast.ArrayExpr Then
		      Dim name As Token= Lox.Ast.ArrayExpr(expr).Name
		      Dim oper As New Token(TokenType.SLASH, "/", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.ArrayAssign(name, Lox.Ast.ArrayExpr(expr).Index, equals, binn)
		    ElseIf expr IsA Lox.Ast.HashMapExpr Then
		      Dim name As Token= Lox.Ast.HashMapExpr(expr).Name
		      Dim oper As New Token(TokenType.SLASH, "/", Nil, name.Line)
		      Dim binn As New Lox.Ast.Binary(expr, oper, value)
		      Return New Lox.Ast.HashMapAssign(name, Lox.Ast.HashMapExpr(expr).Key, equals, binn)
		    End If
		    
		    Error equals, "Invalid assignment target."
		    HadError= True
		  End If
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ifStmt() As Lox.Ast.Stmt
		  Call consume TokenType.LEFT_PAREN, "Expect '(' after 'if'."
		  Dim condition As Lox.Ast.Expr= expression
		  Call consume TokenType.RIGHT_PAREN, "Expect ')' after if condition."
		  
		  Dim thenBranch As Lox.Ast.Stmt= statement
		  
		  Dim orBranch() As Lox.Ast.Stmt
		  While Check(TokenType.OR_)
		    Call Advance
		    Call consume TokenType.LEFT_PAREN, "Expect '(' after 'or'."
		    Dim orCondition As Lox.Ast.Expr= expression
		    Call consume TokenType.RIGHT_PAREN, "Expect ')' after or condition."
		    Dim orThenBranch As Lox.Ast.Stmt= statement
		    orBranch.Append New Lox.Ast.IfStmt(orCondition, orThenBranch, Nil)
		  Wend
		  
		  Dim elseBranch As Lox.Ast.Stmt
		  If Match(TokenType.ELSE_) Then elseBranch= statement
		  
		  Return New Lox.Ast.IfStmt(condition, thenBranch, elseBranch, orBranch)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function importDecl() As Lox.Ast.Stmt
		  Dim name As Token= consume(TokenType.STRING_, "Expect import name.")
		  
		  Call consume(TokenType.SEMICOLON, "Expect ';' after variable declaration.")
		  Return New Lox.Ast.Import(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function interpolatedStr() As Lox.Ast.Expr
		  Dim expressions() As Lox.Ast.Expr
		  expressions.Append New Lox.Ast.Literal(Previous.Literal)
		  
		  Do
		    
		    If Match(TokenType.STRING_INTERPOLATION) Then
		      expressions.Append New Lox.Ast.Literal(Previous.Literal)
		    ElseIf Match(TokenType.LEFT_BRACE) Then
		      expressions.Append expression
		      Call consume TokenType.RIGHT_BRACE, "Expect '}' after elements."
		    ElseIf Match(TokenType.STRING_) Then
		      expressions.Append New Lox.Ast.Literal(Previous.Literal)
		      Exit
		    Else
		      Error Peek, "Unexpected token in interpolation."
		      HadError= True
		      Exit
		    End If
		    
		  Loop
		  
		  Return New Lox.Ast.InterpolatedStr(expressions)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsAtEnd() As Boolean
		  Return Peek.TypeToken= TokenType.EOF
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function logicAnd() As Lox.Ast.Expr
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
		Private Function logicOr() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= logicAnd
		  
		  While Match(TokenType.OR_)
		    Dim operator As Token= Previous
		    Dim right As Lox.Ast.Expr= logicAnd
		    expr= New Lox.Ast.Logical(expr, operator, right)
		  Wend
		  
		  Return expr
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
		Private Function moduleDecl() As Lox.Ast.Stmt
		  Dim name As Token= consume(TokenType.IDENTIFIER, "Expect module name.")
		  
		  Call consume TokenType.LEFT_BRACE, "Expect '{' before class body."
		  
		  Dim modules() As Lox.Ast.ModuleStmt
		  Dim classes() As Lox.Ast.ClassStmt
		  Dim functio() As Lox.Ast.FunctionStmt
		  
		  While Not Check(TokenType.RIGHT_BRACE) And Not IsAtEnd
		    If Check(TokenType.MODULE_) Then
		      Call Advance
		      modules.Append Lox.Ast.ModuleStmt(moduleDecl)
		    ElseIf Check(TokenType.CLASS_) Then
		      Call Advance
		      classes.Append Lox.Ast.ClassStmt(classDecl)
		    ElseIf Check(TokenType.FUN) Then
		      Call Advance
		      functio.Append funDecl("function")
		    Else
		      Error Peek, "Expected a module, class or method definition."
		      HadError= True
		    End If
		    //
		  Wend
		  
		  Call consume TokenType.RIGHT_BRACE, "Expect '}' after class body."
		  
		  Return New Lox.Ast.ModuleStmt(name, modules, classes, functio)
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

	#tag Method, Flags = &h0
		Function ParseREPL() As Variant
		  mAllowExpression= True
		  Dim statements() As Lox.Ast.Stmt
		  While Not IsAtEnd
		    statements.Append declaration
		    
		    If mFoundExpression Then
		      Dim last As Lox.Ast.Stmt= statements(statements.Ubound)
		      Return lox.Ast.Expression(last).Expression
		    End If
		    mAllowExpression= True
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
		Private Function postfix() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= call_
		  
		  If Match(TokenType.PLUS_PLUS, TokenType.MINUS_MINUS) Then
		    Dim name As Token
		    Dim oper As Token= Previous
		    
		    If expr IsA Lox.Ast.Variable Then
		      name= Lox.Ast.Variable(expr).Name
		    Else // TODO:
		      HadError= True
		      #pragma BreakOnExceptions Off
		      Raise Error(Peek, "postfix only for variables.")
		    End If
		    
		    expr= New Lox.Ast.Postfix(name, oper, expr)
		  End If
		  
		  Return expr
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
		  If Match(TokenType.THIS) Then Return New Lox.Ast.This(Previous)
		  If Match(TokenType.FUN) Then Return functionBody("function")
		  
		  If Match(TokenType.NUMBER, TokenType.STRING_) Then Return New Lox.Ast.Literal(Previous.Literal)
		  
		  If Match(TokenType.STRING_INTERPOLATION) Then Return interpolatedStr
		  
		  If Match(TokenType.LEFT_PAREN) Then
		    Dim expr As Lox.Ast.Expr= expression
		    Call consume(TokenType.RIGHT_PAREN, "Expect ')' after expression.")
		    Return New Lox.Ast.Grouping(expr)
		  End If
		  
		  If Match(TokenType.IDENTIFIER) Then
		    Return New Lox.Ast.Variable(Previous)
		  End If
		  
		  If Match(TokenType.SUPER_) Then
		    Dim keyword As Token= Previous
		    Call consume TokenType.DOT, "Expect '.' after 'super'."
		    Dim method As Token= consume(TokenType.IDENTIFIER, "Expect superclass method name.")
		    Return New Lox.Ast.SuperExpr(keyword, method)
		  End If
		  
		  // Array literal? (E.g: [1, 3, "a"]).
		  // https://github.com/munificent/craftinginterpreters/blob/master/note/answers/chapter13_inheritance/3.md
		  // https://calebschoepp.com/blog/2020/adding-a-list-data-type-to-lox/
		  If Match(TokenType.LEFT_BRACKET) Then
		    Dim elems() As Lox.Ast.Expr
		    
		    If Not Check(TokenType.RIGHT_BRACKET) Then
		      Do
		        elems.Append elvis
		      Loop Until Not (Match(TokenType.COMMA))
		    End If
		    Call consume TokenType.RIGHT_BRACKET, "Expect ']' after elements."
		    
		    Return New Lox.Ast.ArrayLiteral(elems)
		  End If
		  
		  // Hash literal? (E.g: {"a" => 1, "b" => 2}).
		  // https://github.com/gkjpettet/roo/blob/master/docs/The%20Roo%20Standard%20Library.md#regular-expressions
		  If Match(TokenType.HASHTAG_BRACE) Then
		    Dim keyValues() As Pair
		    
		    If Not Check(TokenType.RIGHT_BRACE) Then
		      Do
		        Dim key As Lox.Ast.Expr= elvis
		        Call Consume(TokenType.FAT_ARROW, "Expected `=>` operator after hash key.")
		        Dim value As Lox.Ast.Expr= expression
		        
		        keyValues.Append New Pair(key, value)
		      Loop Until Not (Match(TokenType.COMMA))
		    End If
		    Call consume TokenType.RIGHT_BRACE, "Expect '}' after elements."
		    
		    Return New Lox.Ast.HashMapLiteral(keyValues)
		  End If
		  
		  HadError= True
		  #pragma BreakOnExceptions Off
		  Raise Error(Peek, "Expect expression.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function printStmt() As Lox.Ast.Stmt
		  Dim value As Lox.Ast.Expr= expression
		  Call consume TokenType.SEMICOLON, "Expect ';' after value."
		  
		  Return New Lox.Ast.Print(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function returnStmt() As Lox.Ast.Stmt
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
		  If Match(TokenType.IF_) Then Return ifStmt
		  If Match(TokenType.PRINT_) Then Return printStmt
		  If Match(TokenType.RETURN_) Then Return returnStmt
		  If Match(TokenType.WHILE_) Then Return whileStmt
		  If Match(TokenType.BREAK_) Then Return breakStmt
		  If Match(TokenType.CONTINUE_) Then Return continueStmt
		  If Match(TokenType.LEFT_BRACE) Then Return New Lox.Ast.Block(block)
		  
		  Return exprStmt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function suscript() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= primary
		  
		  If Match(TokenType.LEFT_BRACKET) Then
		    // idx
		    Dim idx As Lox.Ast.Expr= elvis
		    // idx
		    Call consume TokenType.RIGHT_BRACKET, "Expect ']' after elements."
		    
		    If expr IsA Lox.Ast.Variable Then
		      expr= New Lox.Ast.ArrayExpr(Lox.Ast.Variable(expr).Name, idx)
		    End If
		  End If
		  
		  'If Match(TokenType.HASHTAG_BRACE) Then
		  '// idx
		  'Dim idx As Lox.Ast.Expr= elvis
		  '// idx
		  'Call consume TokenType.RIGHT_BRACE, "Expect '}' after elements."
		  '
		  'If expr IsA Lox.Ast.Variable Then
		  'expr= New Lox.Ast.HashMapExpr(Lox.Ast.Variable(expr).Name, idx)
		  'Else
		  'Break
		  'End If
		  'End If
		  
		  Return expr
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
		    Dim operator As Token= Previous
		    Dim right As Lox.Ast.Expr= factor
		    expr= New Lox.Ast.Binary(expr, operator, right)
		  Wend
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ternary() As Lox.Ast.Expr
		  Dim expr As Lox.Ast.Expr= logicOr
		  
		  If Match(TokenType.QUESTION) Then
		    Dim thenBranch As Lox.Ast.Expr= expression
		    Call consume TokenType.COLON, "Expected a ':' after 'then' condition in ternary operator."
		    Dim elseBranch As Lox.Ast.Expr= ternary
		    expr= New Lox.Ast.Ternary(expr, thenBranch, elseBranch)
		  End If
		  
		  Return expr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function unary() As Lox.Ast.Expr
		  If Match(TokenType.BANG, TokenType.MINUS) Then
		    Dim operator As Token= Previous
		    Dim right As Lox.Ast.Expr= unary
		    Return New Lox.Ast.Unary(operator, right)
		  End If
		  
		  Return postfix
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function varDecl() As Lox.Ast.Stmt
		  Dim name As Token= consume(TokenType.IDENTIFIER, "Expect variable name.")
		  
		  Dim initializer As Lox.Ast.Expr
		  If Match(TokenType.EQUAL) Then initializer= expression
		  
		  Call consume(TokenType.SEMICOLON, "Expect ';' after variable declaration.")
		  Return New Lox.Ast.VarStmt(name, initializer)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function whileStmt() As Lox.Ast.Stmt
		  Call consume TokenType.LEFT_PAREN, "Expect '(' after 'while'."
		  Dim condition As Lox.Ast.Expr= expression
		  Call consume TokenType.RIGHT_PAREN, "Expect ')' after condition."
		  Dim body As Lox.Ast.Stmt= statement
		  
		  Return New Lox.Ast.WhileStmt(condition, body)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		HadError As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAllowExpression As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrent As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFoundExpression As Boolean
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
