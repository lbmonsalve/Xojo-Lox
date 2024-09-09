#tag Class
Protected Class Resolver
Implements Lox.Ast.IExprVisitor,Lox.Ast.IStmtVisitor
	#tag Method, Flags = &h21
		Private Sub beginScope()
		  mScopes.Append New Lox.Misc.CSDictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(interp As Interpreter)
		  mInterpreter= interp
		  mCurrentFunction= FunctionType.NONE
		  mCurrentClass= ClassType.NONE
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub declare_(name As Lox.Token)
		  If mScopes.Ubound= -1 Then Return
		  
		  Dim scope As Lox.Misc.CSDictionary= mScopes(mScopes.Ubound)
		  If scope.HasKey(name.Lexeme) Then
		    Error name, "Already a variable with this name in this scope."
		    HadError= True
		  End If
		  
		  scope.Value(name.Lexeme)= False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub define(name As Lox.Token)
		  If mScopes.Ubound= -1 Then Return
		  Dim scope As Lox.Misc.CSDictionary= mScopes(mScopes.Ubound)
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
		  
		Exception exc As RuntimeError
		  HadError= True
		  Error exc.Token, exc.Message
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
		  
		Exception exc As RuntimeError
		  HadError= True
		  Error exc.Token, exc.Message
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub resolveFunction(func As Lox.Ast.FunctionStmt, type As FunctionType)
		  Dim enclosingFunction As FunctionType= mCurrentFunction
		  mCurrentFunction= type
		  
		  beginScope
		  For Each param As Token In func.Func.Parameters
		    declare_ param
		    define param
		  Next
		  resolve func.Func.Body
		  endScope
		  
		  mCurrentFunction= enclosingFunction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub resolveLocal(expr As Lox.Ast.Expr, name As Lox.Token)
		  For i As Integer= mScopes.Ubound DownTo 0
		    Dim scope As Lox.Misc.CSDictionary= mScopes(i)
		    If scope.HasKey(name.Lexeme) Then
		      mInterpreter.Resolve(expr, mScopes.Ubound- i)
		      Return
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitArrayAssign(expr As Lox.Ast.ArrayAssign) As Variant
		  resolve expr.Value
		  resolveLocal expr, expr.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitArrayExpr(expr As Lox.Ast.ArrayExpr) As Variant
		  resolveLocal expr, expr.Name
		  resolve expr.Index
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitArrayLiteral(expr As Lox.Ast.ArrayLiteral) As Variant
		  For Each elem As Lox.Ast.Expr In expr.Elements
		    resolve elem
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitAssign(expr As Lox.Ast.Assign) As Variant
		  resolve expr.Value
		  resolveLocal expr, expr.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBinary(expr As Lox.Ast.Binary) As Variant
		  resolve expr.Left
		  resolve expr.Right
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(stmt As Lox.Ast.Block) As Variant
		  beginScope
		  resolve stmt.Statements
		  endScope
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBreakStmt(stmt As Lox.Ast.BreakStmt) As Variant
		  If mLoopLevel<= 0 Then
		    HadError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(stmt.Keyword, "Cannot break when not in a loop.")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitCallExpr(expr As Lox.Ast.CallExpr) As Variant
		  resolve expr.Callee
		  
		  For Each arg As Lox.Ast.Expr In expr.Arguments
		    resolve arg
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitClassStmt(stmt As Lox.Ast.ClassStmt) As Variant
		  Dim enclosingClass As ClassType= mCurrentClass
		  mCurrentClass= ClassType.CLASS_
		  
		  declare_ stmt.Name
		  define stmt.Name
		  
		  If Not (stmt.SuperClass Is Nil) And _
		    stmt.Name.Lexeme= stmt.SuperClass.Name.Lexeme Then
		    Error stmt.SuperClass.Name, "A class can't inherit from itself."
		    HadError= True
		  End If
		  
		  If Not (stmt.SuperClass Is Nil) Then
		    mCurrentClass= ClassType.SUBCLASS
		    resolve(stmt.SuperClass)
		  End If
		  
		  If Not (stmt.SuperClass Is Nil) Then
		    beginScope
		    mScopes(mScopes.Ubound).Value("super")= True
		  End If
		  
		  beginScope
		  mScopes(mScopes.Ubound).Value("this")= True
		  
		  For Each method As Lox.Ast.FunctionStmt In stmt.Methods
		    Dim declaration As FunctionType= FunctionType.METHOD
		    If method.Name.Lexeme= "init" Then declaration= FunctionType.INITIALIZER
		    resolveFunction method, declaration
		  Next
		  
		  endScope
		  
		  If Not (stmt.SuperClass Is Nil) Then endScope
		  
		  For Each method As Lox.Ast.FunctionStmt In stmt.ClassMethods
		    beginScope
		    mScopes(mScopes.Ubound).Value("this")= True
		    resolveFunction method, FunctionType.METHOD
		    endScope
		  Next
		  
		  mCurrentClass= enclosingClass
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitContinueStmt(stmt As Lox.Ast.ContinueStmt) As Variant
		  If mLoopLevel<= 0 Then
		    HadError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(stmt.Keyword, "Cannot continue when not in a loop.")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitElvis(expr As Lox.Ast.Elvis) As Variant
		  resolve expr.Condition
		  resolve expr.RightExp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitElvisDot(expr As Lox.Ast.ElvisDot) As Variant
		  resolve expr.Condition
		  resolve expr.RightExp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitExpression(stmt As Lox.Ast.Expression) As Variant
		  resolve stmt.Expression
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFunctionExpr(expr As Lox.Ast.FunctionExpr) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFunctionStmt(stmt As Lox.Ast.FunctionStmt) As Variant
		  declare_ stmt.Name
		  define stmt.Name
		  
		  resolveFunction stmt, FunctionType.FUNC
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitGet(expr As Lox.Ast.Get) As Variant
		  resolve expr.Obj
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitGrouping(expr As Lox.Ast.Grouping) As Variant
		  resolve expr.Expression
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHashMapAssign(expr As Lox.Ast.HashMapAssign) As Variant
		  resolve expr.Value
		  resolveLocal expr, expr.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHashMapExpr(expr As Lox.Ast.HashMapExpr) As Variant
		  resolveLocal expr, expr.Name
		  resolve expr.Key
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHashMapLiteral(expr As Lox.Ast.HashMapLiteral) As Variant
		  Dim hashMap As Lox.Misc.CSDictionary= expr.HashMap
		  For i As Integer= 0 To hashMap.Count- 1
		    resolve lox.Ast.Expr(hashMap.Key(i))
		    resolve lox.Ast.Expr(hashMap.Value(hashMap.Key(i)))
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIfStmt(stmt As Lox.Ast.IfStmt) As Variant
		  resolve stmt.Condition
		  resolve stmt.ThenBranch
		  If Not (stmt.ElseBranch Is Nil ) Then resolve stmt.ElseBranch
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLiteral(expr As Lox.Ast.Literal) As Variant
		  // TODO: string interpolation
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLogical(expr As Lox.Ast.Logical) As Variant
		  resolve expr.Left
		  resolve expr.Right
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitModuleStmt(stmt As Lox.Ast.ModuleStmt) As Variant
		  declare_ stmt.Name
		  define stmt.Name
		  
		  Dim enclosingClass As ClassType= mCurrentClass
		  mCurrentClass= ClassType.MODULE_
		  
		  // Analyse any classes in this module.
		  For i As Integer= 0 To stmt.Classes.Ubound
		    Call VisitClassStmt stmt.Classes(i)
		  Next
		  
		  // Before we start analysing the method bodies we start a new scope and define `self` as if it were
		  // a new variable.
		  beginScope
		  mScopes(mScopes.Ubound).Value(Self)= True
		  
		  // Analyse methods.
		  For i As Integer= 0 To stmt.Modules.Ubound
		    beginScope
		    mScopes(mScopes.Ubound).Value(Self)= True
		    resolveFunction Lox.Ast.FunctionStmt(stmt.Modules(i)), FunctionType.METHOD
		    endScope
		  Next
		  
		  endScope
		  
		  mCurrentClass= enclosingClass
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitPostfix(expr As Lox.Ast.Postfix) As Variant
		  resolve expr.Left
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitPrint(stmt As Lox.Ast.Print) As Variant
		  resolve stmt.Expression
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitReturnStmt(stmt As Lox.Ast.ReturnStmt) As Variant
		  If mCurrentFunction= FunctionType.NONE Then
		    Error stmt.Keyword, "Can't return from top-level code."
		    HadError= True
		  End If
		  
		  If Not (stmt.Value Is Nil) Then
		    If mCurrentFunction= FunctionType.INITIALIZER Then
		      Error stmt.Keyword, "Can't return a value from an initializer."
		      HadError= True
		    End If
		    
		    resolve stmt.Value
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSet(expr As Lox.Ast.Set) As Variant
		  resolve expr.Value
		  resolve expr.Obj
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSuperExpr(expr As Lox.Ast.SuperExpr) As Variant
		  If mCurrentClass= ClassType.NONE Then
		    Error expr.Keyword, "Can't use 'super' outside of a class."
		    HadError= True
		  ElseIf mCurrentClass<> ClassType.SUBCLASS Then
		    Error expr.Keyword, "Can't use 'super' in a class with no superclass."
		    HadError= True
		  End If
		  
		  resolveLocal expr, expr.Keyword
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitTernary(expr As Lox.Ast.Ternary) As Variant
		  resolve expr.Expression
		  resolve expr.ThenBranch
		  If Not (expr.ElseBranch Is Nil ) Then resolve expr.ElseBranch
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitThis(expr As Lox.Ast.This) As Variant
		  If mCurrentClass= ClassType.NONE Then
		    Error expr.Keyword, "Can't use 'this' outside of a class."
		    HadError= True
		  End If
		  
		  resolveLocal expr, expr.Keyword
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitUnary(expr As Lox.Ast.Unary) As Variant
		  resolve expr.Right
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitVariable(expr As Lox.Ast.Variable) As Variant
		  If mScopes.Ubound> -1 Then
		    Dim scope As Lox.Misc.CSDictionary= mScopes(mScopes.Ubound)
		    If scope.HasKey(expr.Name.Lexeme) And _
		      scope.Value(expr.Name.Lexeme).BooleanValue= False Then
		      Error expr.Name, "Can't read local variable in its own initializer."
		      HadError= True
		    End If
		  End If
		  
		  resolveLocal expr, expr.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitVarStmt(stmt As Lox.Ast.VarStmt) As Variant
		  declare_ stmt.Name
		  If Not (stmt.Initializer Is Nil) Then resolve stmt.Initializer
		  define stmt.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitWhileStmt(stmt As Lox.Ast.WhileStmt) As Variant
		  mLoopLevel= mLoopLevel+ 1 // enter
		  
		  resolve stmt.Condition
		  resolve stmt.Body
		  
		  mLoopLevel= mLoopLevel- 1 // exit
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		HadError As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentClass As ClassType
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentFunction As FunctionType
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInterpreter As Interpreter
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLoopLevel As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScopes() As Lox.Misc.CSDictionary
	#tag EndProperty


	#tag Enum, Name = ClassType, Type = Integer, Flags = &h21
		NONE
		  CLASS_
		  SUBCLASS
		MODULE_
	#tag EndEnum

	#tag Enum, Name = FunctionType, Type = Integer, Flags = &h21
		NONE
		  FUNC
		  INITIALIZER
		METHOD
	#tag EndEnum


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
