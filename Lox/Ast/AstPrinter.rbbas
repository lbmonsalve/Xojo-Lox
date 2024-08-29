#tag Class
Protected Class AstPrinter
Implements IExprVisitor,IStmtVisitor
	#tag Method, Flags = &h21
		Private Function Parenthesize(name As String, ParamArray exprs As Lox.Ast.Expr) As String
		  Dim sb() As String
		  
		  sb.Append "("
		  sb.Append name
		  
		  For Each expr As Lox.Ast.Expr In exprs
		    sb.Append " "
		    sb.Append expr.Accept(Self)
		  Next
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Parenthesize2(name As String, ParamArray parts As Variant) As String
		  Dim sb() As String
		  
		  sb.Append "("
		  sb.Append name
		  
		  Transform sb, parts
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Print(expr As Lox.Ast.Expr) As String
		  Return expr.Accept(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Print(stmt As Lox.Ast.Stmt) As String
		  Return stmt.Accept(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Transform(sb() As String, parts() As Variant)
		  For Each part As Variant In parts
		    sb.Append " "
		    If part IsA Lox.Ast.Expr Then
		      Break
		    ElseIf part IsA Lox.Lexical.Token Then
		      Break
		    Else
		      sb.Append part.StringValue
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Assign) As Variant
		  Return Parenthesize2("=", expr.Name.Lexeme, expr.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Binary) As Variant
		  Return Parenthesize(expr.Operator.Lexeme, expr.Left, expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Block) As Variant
		  Dim sb() As String
		  
		  sb.Append "(block "
		  
		  For Each statement As Stmt In stmt.Statements
		    sb.Append statement.Accept(Self)
		  Next
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As CallExpr) As Variant
		  Return Parenthesize2("call", expr.Callee, expr.Arguments)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As ClassStmt) As Variant
		  Dim sb() As String
		  
		  sb.Append "(class "+ stmt.Name.Lexeme
		  
		  If Not (stmt.SuperClass Is Nil) Then
		    sb.Append " < "+ Print(stmt.SuperClass)
		  End If
		  
		  For Each method As FunctionStmt In stmt.Methods
		    sb.Append " "+ Print(method)
		  Next
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Expression) As Variant
		  Return Parenthesize(";", stmt.Expression)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As FunctionStmt) As Variant
		  Dim sb() As String
		  
		  sb.Append "(fun "+ stmt.Name.Lexeme+ "("
		  
		  For Each param As Lox.Lexical.Token In stmt.Params
		    If param<> stmt.Params(0) Then sb.Append(" ")
		    sb.Append param.Lexeme
		  Next
		  
		  sb.Append ") "
		  
		  For Each body As Stmt In stmt.Body
		    sb.Append body.Accept(Self)
		  Next
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Get) As Variant
		  Return Parenthesize2(".", expr.Obj, expr.Name.Lexeme)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Grouping) As Variant
		  Return Parenthesize("group", expr.Expression)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As IfStmt) As Variant
		  If stmt.ElseBranch Is Nil Then
		    Return Parenthesize2("if", stmt.Condition, stmt.ThenBranch)
		  End If
		  
		  Return Parenthesize2("if-else", stmt.Condition, stmt.ThenBranch, stmt.ElseBranch)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Literal) As Variant
		  If expr.Value.IsNull Then Return "nil"
		  
		  Return expr.Value.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Logical) As Variant
		  Return Parenthesize(expr.Operator.Lexeme, expr.Left, expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Print) As Variant
		  Return Parenthesize("print", stmt.Expression)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As ReturnStmt) As Variant
		  If stmt.Value Is Nil Then Return "(return)"
		  
		  Return Parenthesize("return", stmt.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Set) As Variant
		  Return Parenthesize2("=", expr.Obj, expr.Name.Lexeme, expr.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As SuperExpr) As Variant
		  Return Parenthesize2("super", expr.Method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As This) As Variant
		  Return "this"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Unary) As Variant
		  Return Parenthesize(expr.Operator.Lexeme, expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Variable) As Variant
		  Return expr.Name.Lexeme
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As VarStmt) As Variant
		  If stmt.Initializer Is Nil Then Return Parenthesize2("var", stmt.Name)
		  
		  Return Parenthesize2("var", stmt.Name, "=", stmt.Initializer)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As WhileStmt) As Variant
		  Return Parenthesize2("while", stmt.Condition, stmt.Body)
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
