#tag Class
Protected Class Interpreter
Implements Lox.Ast.IExprVisitor,Lox.Ast.IStmtVisitor
	#tag Method, Flags = &h21
		Private Sub CheckNumberOperand(operator As Lox.Token, operand As Variant)
		  If operand.IsNumberLox Then Return
		  
		  #pragma BreakOnExceptions Off
		  Raise New RuntimeError(operator, "Operand must be a number.")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckNumberOperands(operator As Lox.Token, left As Variant, right As Variant)
		  If left.IsNumeric And right.IsNumeric Then Return
		  
		  #pragma BreakOnExceptions Off
		  Raise New RuntimeError(operator, "Operands must be numbers.")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Reset
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Evaluate(expr As Lox.Ast.Expr) As Variant
		  Return expr.Accept(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub execute(stmt As Lox.Ast.Stmt)
		  Call stmt.Accept Self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExecuteBlock(statements() As Lox.Ast.Stmt, env As Environment)
		  Dim previous As Environment= Self.Env
		  
		  Try
		    Self.Env= env
		    
		    For Each statement As Lox.Ast.Stmt In statements
		      execute statement
		    Next
		  Finally
		    Self.Env= previous
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Interpret(statements() As Lox.Ast.Stmt)
		  Try
		    For Each statement As Lox.Ast.Stmt In statements
		      execute statement
		    Next
		  Catch exc As RuntimeError
		    RuntimeError exc
		  Catch exc As RuntimeException
		    System.DebugLog CurrentMethodName+ " unexpected error"
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsEqual(left As Variant, right As Variant) As Boolean
		  If left.IsNull And right.IsNull Then Return True
		  If left.IsNull Then Return False
		  
		  Return left.Equals(right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsTruthy(obj As Variant) As Boolean
		  If obj.IsNull Then Return False
		  If obj.Type= 11 Then Return obj.BooleanValue
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function lookUpVariable(name As Token, expr As Lox.Ast.Expr) As Variant
		  If mLocals.HasKey(expr) Then
		    Dim distance As Integer= mLocals.Value(expr).IntegerValue
		    Return Env.GetAt(distance, name.Lexeme)
		  Else
		    Return Globals.Get(name)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  mGlobals= New Environment
		  mGlobals.Define("clock", New LoxClock)
		  
		  mEnv= mGlobals
		  
		  mLocals= New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Resolve(expr As Lox.Ast.Expr, depth As Integer)
		  mLocals.Value(expr)= depth
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Stringify(obj As Variant) As String
		  If obj.IsNull Then Return "nil"
		  
		  Return obj.ToStringLox
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Assign) As Variant
		  Dim value As Variant= Evaluate(expr.Value)
		  
		  If mLocals.HasKey(expr) Then
		    Dim distance As Integer= mLocals.Value(expr).IntegerValue
		    Env.AssignAt(distance, expr.Name, value)
		  Else
		    Globals.Assign(expr.Name, value)
		  End If
		  
		  Return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Binary) As Variant
		  Dim left As Variant= Evaluate(expr.Left)
		  Dim right As Variant= Evaluate(expr.Right)
		  
		  Select Case expr.Operator.TypeToken
		  Case TokenType.GREATER
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue> right.DoubleValue
		  Case TokenType.GREATER_EQUAL
		    
		    CheckNumberOperands expr.Operator, left, right
		    If left.DoubleValue> right.DoubleValue Then Return True
		    Return AreEqual(left.DoubleValue, right.DoubleValue)
		  Case TokenType.LESS
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue< right.DoubleValue
		  Case TokenType.LESS_EQUAL
		    
		    CheckNumberOperands expr.Operator, left, right
		    If left.DoubleValue< right.DoubleValue Then Return True
		    Return AreEqual(left.DoubleValue, right.DoubleValue)
		  Case TokenType.BANG_EQUAL
		    
		    Return Not IsEqual(left, right)
		  Case TokenType.EQUAL_EQUAL
		    
		    Return IsEqual(left, right)
		  Case TokenType.MINUS
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue- right.DoubleValue
		  Case TokenType.PLUS
		    
		    If left.IsNumeric And right.IsNumeric Then
		      Return left.DoubleValue+ right.DoubleValue
		    End If
		    If left.IsStringLox And right.IsStringLox Then
		      Return left.StringValue+ right.StringValue
		    End If
		    
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(expr.Operator, "Operands must be two numbers or two strings.")
		  Case TokenType.SLASH
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue/ right.DoubleValue
		  Case TokenType.STAR
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue* right.DoubleValue
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.Block) As Variant
		  ExecuteBlock stmt.Statements, New Environment(Env)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.CallExpr) As Variant
		  Dim callee As Variant= Evaluate(expr.Callee)
		  
		  Dim arguments() As Variant
		  For Each argument As Variant In expr.Arguments
		    arguments.Append Evaluate(argument)
		  Next
		  
		  #pragma BreakOnExceptions Off
		  If Not (callee IsA ICallable) Then Raise New RuntimeError(expr.Paren, _
		  "Can only call functions and classes.")
		  
		  Dim func As ICallable= ICallable(callee)
		  
		  If arguments.CountLox<> func.Arity Then
		    Raise New RuntimeError(expr.Paren, "Expected "+ _
		    Str(func.Arity)+ " arguments but got "+ Str(arguments.CountLox) + ".")
		  End If
		  
		  
		  Return func.Call_(Self, arguments)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.ClassStmt) As Variant
		  Env.Define(stmt.Name.Lexeme, Nil)
		  
		  Dim methods As New Dictionary
		  For Each method As Lox.Ast.FunctionStmt In stmt.Methods
		    Dim func As LoxFunction= New LoxFunction(method, Env)
		    methods.Value(method.Name.Lexeme)= func
		  Next
		  
		  Dim klass As New LoxClass(stmt.Name.Lexeme, methods)
		  Env.Assign(stmt.Name, klass)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.Expression) As Variant
		  Call Evaluate stmt.Expression
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.FunctionStmt) As Variant
		  Dim func As New LoxFunction(stmt, mEnv)
		  Env.Define(stmt.Name.Lexeme, func)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Get) As Variant
		  Dim obj As Variant= Evaluate(expr.Obj)
		  If obj IsA LoxInstance Then
		    Dim objInstance As LoxInstance= LoxInstance(obj)
		    Return objInstance.Get(expr.Name)
		  End If
		  
		  #pragma BreakOnExceptions Off
		  Raise New RuntimeError(expr.Name, "Only instances have properties.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Grouping) As Variant
		  Return Evaluate(expr.Expression)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.IfStmt) As Variant
		  If isTruthy(Evaluate(stmt.Condition)) Then
		    execute stmt.ThenBranch
		  ElseIf Not (stmt.ElseBranch Is Nil) Then
		    execute stmt.ElseBranch
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Literal) As Variant
		  Return expr.Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Logical) As Variant
		  Dim left As Variant= evaluate(expr.Left)
		  
		  If expr.Operator.TypeToken= TokenType.OR_ Then
		    If IsTruthy(left) Then Return left
		  Else
		    If Not IsTruthy(left) Then Return left
		  End If
		  
		  Return Evaluate(expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.Print) As Variant
		  Dim value As Variant= Evaluate(stmt.Expression)
		  StdOut.WriteLine Stringify(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.ReturnStmt) As Variant
		  Dim value As Variant
		  If Not (stmt.Value Is Nil) Then value= Evaluate(stmt.Value)
		  
		  #pragma BreakOnExceptions Off
		  Raise New ReturnExc(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Set) As Variant
		  Dim obj As Variant= Evaluate(expr.Obj)
		  
		  If Not (obj IsA LoxInstance) Then
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(expr.Name, "Only instances have fields.")
		  End If
		  
		  Dim value As Variant= Evaluate(expr.Value)
		  Dim objInstance As LoxInstance= LoxInstance(obj)
		  objInstance.Set(expr.Name, value)
		  
		  Return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.SuperExpr) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.This) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Unary) As Variant
		  Dim right As Variant= Evaluate(expr.Right)
		  
		  Select Case expr.Operator.TypeToken
		  Case TokenType.BANG
		    
		    Return Not IsTruthy(right)
		  Case TokenType.MINUS
		    
		    CheckNumberOperand expr.Operator, right
		    Return -right.DoubleValue
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Variable) As Variant
		  Return lookUpVariable(expr.Name, expr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.VarStmt) As Variant
		  Dim value As Variant
		  If Not (stmt.Initializer Is Nil) Then
		    value= Evaluate(stmt.Initializer)
		  End If
		  
		  Env.Define stmt.Name.Lexeme, value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.WhileStmt) As Variant
		  While IsTruthy(Evaluate(stmt.Condition))
		    execute stmt.Body
		  Wend
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mEnv
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mEnv= value
			End Set
		#tag EndSetter
		Env As Environment
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mGlobals
			End Get
		#tag EndGetter
		Globals As Environment
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mEnv As Environment
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGlobals As Environment
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLocals As Dictionary
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
