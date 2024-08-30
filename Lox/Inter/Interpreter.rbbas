#tag Class
Protected Class Interpreter
Implements Lox.Ast.IExprVisitor,Lox.Ast.IStmtVisitor
	#tag Method, Flags = &h21
		Private Sub CheckNumberOperand(operator As Lox.Token, operand As Variant)
		  If operand.IsNumber Then Return
		  
		  Raise New RuntimeError(operator, "Operand must be a number.")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckNumberOperands(operator As Lox.Token, left As Variant, right As Variant)
		  If left.IsNumeric And right.IsNumeric Then Return
		  
		  Raise New RuntimeError(operator, "Operands must be numbers.")
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

	#tag Method, Flags = &h21
		Private Sub executeBlock(statements() As Lox.Ast.Stmt, env As Environment)
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
		    #pragma BreakOnExceptions Off
		    
		    For Each statement As Lox.Ast.Stmt In statements
		      execute statement
		    Next
		    
		    #pragma BreakOnExceptions Default
		  Catch exc As RuntimeError
		    Lox.RuntimeError exc
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
		Private Function Stringify(obj As Variant) As String
		  If obj.IsNull Then Return "nil"
		  
		  Return obj.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Assign) As Variant
		  Dim value As Variant= Evaluate(expr.Value)
		  Env.Assign expr.Name, value
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
		    If left.IsString And right.IsString Then
		      Return left.StringValue+ right.StringValue
		    End If
		    
		    Raise New RuntimeError(expr.Operator, "Operands must be two numbers or two strings.")
		  Case TokenType.SLASH
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue/ right.DoubleValue
		  Case TokenType.STAR
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue* right.DoubleValue
		    
		  End Select
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.Block) As Variant
		  executeBlock stmt.Statements, New Environment(Env)
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.CallExpr) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.ClassStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.Expression) As Variant
		  Call Evaluate stmt.Expression
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.FunctionStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Get) As Variant
		  
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
		  
		  Return Nil
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
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.ReturnStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Set) As Variant
		  
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
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Variable) As Variant
		  Return Env.Get(expr.Name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Lox.Ast.VarStmt) As Variant
		  Dim value As Variant
		  If Not (stmt.Initializer Is Nil) Then
		    value= Evaluate(stmt.Initializer)
		  End If
		  
		  Env.Define stmt.Name.Lexeme, value
		  Return Nil
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
			  If mEnv Is Nil Then mEnv= New Environment
			  
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

	#tag Property, Flags = &h21
		Private mEnv As Environment
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
