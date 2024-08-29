#tag Class
Protected Class Interpreter
Implements IExprVisitor
	#tag Method, Flags = &h21
		Private Sub CheckNumberOperand(operator As Lox.Lexical.Token, operand As Variant)
		  If operand.IsNumber Then Return
		  
		  Raise New RuntimeError(operator, "Operand must be a number.")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckNumberOperands(operator As Lox.Lexical.Token, left As Variant, right As Variant)
		  If left.IsNumeric And right.IsNumeric Then Return
		  
		  Raise New RuntimeError(operator, "Operands must be numbers.")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Evaluate(expr As Lox.Ast.Expr) As Variant
		  Return expr.Accept(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Interpret(expression As Lox.Ast.Expr)
		  Try
		    #pragma BreakOnExceptions Off
		    Dim value As Variant= Evaluate(expression)
		    StdOut.WriteLine Stringify(value)
		    #pragma BreakOnExceptions Default
		  Catch exc As RuntimeError
		    
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
		Function Visit(expr As Assign) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Binary) As Variant
		  Dim left As Variant= Evaluate(expr.Left)
		  Dim right As Variant= Evaluate(expr.Right)
		  
		  Select Case expr.Operator.TypeToken
		  Case Lox.TokenType.GREATER
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue> right.DoubleValue
		  Case Lox.TokenType.GREATER_EQUAL
		    
		    CheckNumberOperands expr.Operator, left, right
		    If left.DoubleValue> right.DoubleValue Then Return True
		    Return AreEqual(left.DoubleValue, right.DoubleValue)
		  Case Lox.TokenType.LESS
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue< right.DoubleValue
		  Case Lox.TokenType.LESS_EQUAL
		    
		    CheckNumberOperands expr.Operator, left, right
		    If left.DoubleValue< right.DoubleValue Then Return True
		    Return AreEqual(left.DoubleValue, right.DoubleValue)
		  Case Lox.TokenType.BANG_EQUAL
		    
		    Return Not IsEqual(left, right)
		  Case Lox.TokenType.EQUAL_EQUAL
		    
		    Return IsEqual(left, right)
		  Case Lox.TokenType.MINUS
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue- right.DoubleValue
		  Case Lox.TokenType.PLUS
		    
		    If left.IsNumeric And right.IsNumeric Then
		      Return left.DoubleValue+ right.DoubleValue
		    End If
		    If left.IsString And right.IsString Then
		      Return left.StringValue+ right.StringValue
		    End If
		    
		    Raise New RuntimeError(expr.Operator, "Operands must be two numbers or two strings.")
		  Case Lox.TokenType.SLASH
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue/ right.DoubleValue
		  Case Lox.TokenType.STAR
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue* right.DoubleValue
		    
		  End Select
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As CallExpr) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Get) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Grouping) As Variant
		  Return Evaluate(expr.Expression)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Literal) As Variant
		  Return expr.Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Logical) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Set) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As SuperExpr) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As This) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Unary) As Variant
		  Dim right As Variant= Evaluate(expr.Right)
		  
		  Select Case expr.Operator.TypeToken
		  Case lox.TokenType.BANG
		    
		    Return Not IsTruthy(right)
		  Case Lox.TokenType.MINUS
		    
		    CheckNumberOperand expr.Operator, right
		    Return -right.DoubleValue
		    
		  End Select
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Variable) As Variant
		  
		End Function
	#tag EndMethod


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
