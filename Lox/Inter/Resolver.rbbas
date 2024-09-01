#tag Class
Protected Class Resolver
Implements Lox.Ast.IExprVisitor,Lox.Ast.IStmtVisitor
	#tag Method, Flags = &h21
		Private Sub beginScope()
		  mScopes.Append New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(interp As Interpreter)
		  mInterpreter= interp
		  mCurrentFunction= FunctionType.NONE
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub declare_(name As Lox.Token)
		  If mScopes.Ubound= -1 Then Return
		  
		  Dim scope As Dictionary= mScopes(mScopes.Ubound)
		  If scope.HasKey(name.Lexeme) Then
		    Error name, "Already a variable with this name in this scope."
		  End If
		  
		  scope.Value(name.Lexeme)= False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub define(name As Lox.Token)
		  If mScopes.Ubound= -1 Then Return
		  Dim scope As Dictionary= mScopes(mScopes.Ubound)
		  scope.Value(name.Lexeme)= True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub endScope()
		  Call mScopes.Pop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub resolve(expr As Lox.Ast.Expr)
		  Call expr.Accept Self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Resolve(stmts() As Lox.Ast.Stmt)
		  For Each stmt As Lox.Ast.Stmt In stmts
		    resolve stmt
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub resolve(stmt As Lox.Ast.Stmt)
		  Call stmt.Accept Self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub resolveFunction(func As Lox.Ast.FunctionStmt, type As FunctionType)
		  Dim enclosingFunction As FunctionType= mCurrentFunction
		  mCurrentFunction= type
		  
		  beginScope
		  For Each param As Token In func.Params
		    declare_ param
		    define param
		  Next
		  resolve func.Body
		  endScope
		  
		  mCurrentFunction= enclosingFunction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub resolveLocal(expr As Lox.Ast.Expr, name As Lox.Token)
		  For i As Integer= mScopes.Ubound To 0 Step -1
		    Dim scope As Dictionary= mScopes(i)
		    If scope.HasKey(name.Lexeme) Then
		      mInterpreter.Resolve(expr, mScopes.Ubound- i)
		      Return
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Assign) As Variant
		  resolve expr.Value
		  resolveLocal expr, expr.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Binary) As Variant
		  resolve expr.Left
		  resolve expr.Right
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.Block) As Variant
		  beginScope
		  resolve stmt.Statements
		  endScope
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.CallExpr) As Variant
		  resolve expr.Callee
		  
		  For Each arg As Lox.Ast.Expr In expr.Arguments
		    resolve arg
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.ClassStmt) As Variant
		  declare_ stmt.Name
		  define stmt.Name
		  
		  beginScope
		  mScopes(mScopes.Ubound).Value("this")= True
		  
		  For Each method As Lox.Ast.FunctionStmt In stmt.Methods
		    Dim declaration As FunctionType= FunctionType.METHOD
		    resolveFunction method, declaration
		  Next
		  
		  endScope
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.Expression) As Variant
		  resolve stmt.Expression
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.FunctionStmt) As Variant
		  declare_ stmt.Name
		  define stmt.Name
		  
		  resolveFunction stmt, FunctionType.FUNC
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Get) As Variant
		  resolve expr.Obj
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Grouping) As Variant
		  resolve expr.Expression
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.IfStmt) As Variant
		  resolve stmt.Condition
		  resolve stmt.ThenBranch
		  If Not (stmt.ElseBranch Is Nil ) Then resolve stmt.ElseBranch
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Literal) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Logical) As Variant
		  resolve expr.Left
		  resolve expr.Right
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.Print) As Variant
		  resolve stmt.Expression
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.ReturnStmt) As Variant
		  If mCurrentFunction= FunctionType.NONE Then
		    Error stmt.Keyword, "Can't return from top-level code."
		  End If
		  
		  If Not (stmt.Value Is Nil) Then resolve stmt.Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Set) As Variant
		  resolve expr.Value
		  resolve expr.Obj
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.SuperExpr) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.This) As Variant
		  resolveLocal expr, expr.Keyword
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Unary) As Variant
		  resolve expr.Right
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Variable) As Variant
		  If mScopes.Ubound> -1 Then
		    Dim scope As Dictionary= mScopes(mScopes.Ubound)
		    If scope.HasKey(expr.Name.Lexeme) And _
		      scope.Value(expr.Name.Lexeme).BooleanValue= False Then
		      Error expr.Name, "Can't read local variable in its own initializer."
		    End If
		  End If
		  
		  resolveLocal expr, expr.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.VarStmt) As Variant
		  declare_ stmt.Name
		  If Not (stmt.Initializer Is Nil) Then resolve stmt.Initializer
		  define stmt.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.WhileStmt) As Variant
		  resolve stmt.Condition
		  resolve stmt.Body
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCurrentFunction As FunctionType
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInterpreter As Interpreter
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScopes() As Dictionary
	#tag EndProperty


	#tag Enum, Name = FunctionType, Type = Integer, Flags = &h21
		NONE
		  FUNC
		METHOD
	#tag EndEnum


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
