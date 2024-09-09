#tag Class
Protected Class AstPrinter
Implements Lox.Ast.IExprVisitor,Lox.Ast.IStmtVisitor
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
		  
		  sb.Append "("+ name
		  
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
		      sb.Append Print(Lox.Ast.Expr(part))
		    ElseIf part IsA Lox.Ast.Stmt Then
		      sb.Append Print(Lox.Ast.Stmt(part))
		    ElseIf part IsA Lox.Token Then
		      sb.Append Lox.Token(part).Lexeme
		    ElseIf part.IsArray Then
		      Dim elems() As Lox.Ast.Expr= part
		      For i As Integer= 0 To elems.Ubound
		        sb.Append Print(elems(i))+ ", "
		      Next
		    Else
		      sb.Append part.StringValue
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitArrayAssign(expr As Lox.Ast.ArrayAssign) As Variant
		  Return Parenthesize2("array "+ expr.Operator.Lexeme, expr.Name.Lexeme, expr.Index, expr.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitArrayExpr(expr As Lox.Ast.ArrayExpr) As Variant
		  Return Parenthesize2("array", "", expr.Name, expr.Index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitArrayLiteral(expr As Lox.Ast.ArrayLiteral) As Variant
		  Return Parenthesize2("array", "", expr.Elements)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitAssign(expr As Lox.Ast.Assign) As Variant
		  Return Parenthesize2("=", expr.Name.Lexeme, expr.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBinary(expr As Lox.Ast.Binary) As Variant
		  Return Parenthesize(expr.Operator.Lexeme, expr.Left, expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(stmt As Lox.Ast.Block) As Variant
		  Dim sb() As String
		  
		  sb.Append "(block "
		  
		  For Each statement As Lox.Ast.Stmt In stmt.Statements
		    sb.Append statement.Accept(Self)
		  Next
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBreakStmt(stmt As Lox.Ast.BreakStmt) As Variant
		  Return "(break)"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitCallExpr(expr As Lox.Ast.CallExpr) As Variant
		  Dim sb() As String
		  
		  sb.Append "(call "
		  sb.Append Print(expr.Callee)+ "("
		  
		  For i As Integer= 0 To expr.Arguments.Ubound
		    Dim argument As Lox.Ast.Expr= expr.Arguments(i)
		    If i> 0 Then sb.Append ","
		    sb.Append Print(argument)
		  Next
		  
		  sb.Append "))"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitClassStmt(stmt As Lox.Ast.ClassStmt) As Variant
		  Dim sb() As String
		  
		  sb.Append "(class "+ stmt.Name.Lexeme
		  
		  If Not (stmt.SuperClass Is Nil) Then
		    sb.Append " < "+ Print(stmt.SuperClass)
		  End If
		  
		  For Each method As Lox.Ast.FunctionStmt In stmt.Methods
		    sb.Append " "+ Print(method)
		  Next
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitContinueStmt(stmt As Lox.Ast.ContinueStmt) As Variant
		  Return "(continue)"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitElvis(expr As Lox.Ast.Elvis) As Variant
		  Dim sb() As String
		  
		  sb.Append "("
		  sb.Append Parenthesize("elvis", expr.Condition)
		  sb.Append Parenthesize2("", expr.RightExp)
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitElvisDot(expr As Lox.Ast.ElvisDot) As Variant
		  Dim sb() As String
		  
		  sb.Append "("
		  sb.Append Parenthesize("elvisDot", expr.Condition)
		  sb.Append Parenthesize2("", expr.RightExp)
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitExpression(stmt As Lox.Ast.Expression) As Variant
		  Return Parenthesize(";", stmt.Expression)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFunctionExpr(expr As Lox.Ast.FunctionExpr) As Variant
		  Break
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFunctionStmt(stmt As Lox.Ast.FunctionStmt) As Variant
		  Dim sb() As String
		  
		  sb.Append "(fun "+ stmt.Name.Lexeme+ "("
		  
		  For Each param As Lox.Token In stmt.Func.Parameters
		    If param<> stmt.Func.Parameters(0) Then sb.Append(" ")
		    sb.Append param.Lexeme
		  Next
		  
		  sb.Append ") "
		  
		  For Each body As Lox.Ast.Stmt In stmt.Func.Body
		    sb.Append body.Accept(Self)
		  Next
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitGet(expr As Lox.Ast.Get) As Variant
		  Return Parenthesize2(".", expr.Obj, expr.Name.Lexeme)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitGrouping(expr As Lox.Ast.Grouping) As Variant
		  Return Parenthesize("group", expr.Expression)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHashMapAssign(expr As Lox.Ast.HashMapAssign) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHashMapExpr(expr As Lox.Ast.HashMapExpr) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHashMapLiteral(expr As Lox.Ast.HashMapLiteral) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIfStmt(stmt As Lox.Ast.IfStmt) As Variant
		  Dim sb() As String
		  
		  sb.Append "("
		  sb.Append Parenthesize("if", stmt.Condition)
		  sb.Append Parenthesize2("", stmt.ThenBranch)
		  
		  For Each orBranch As Lox.Ast.Stmt In stmt.OrBranch
		    Dim orBranchIf As Lox.Ast.IfStmt= Lox.Ast.IfStmt(orBranch)
		    sb.Append Parenthesize2("or", orBranchIf.Condition, orBranchIf.ThenBranch)
		  Next
		  
		  If Not (stmt.ElseBranch Is Nil) Then
		    sb.Append Parenthesize2("else", stmt.ElseBranch)
		  End If
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLiteral(expr As Lox.Ast.Literal) As Variant
		  Return expr.Value.ToStringLox
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLogical(expr As Lox.Ast.Logical) As Variant
		  Return Parenthesize(expr.Operator.Lexeme, expr.Left, expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitModuleStmt(stmt As Lox.Ast.ModuleStmt) As Variant
		  Dim sb() As String
		  
		  sb.Append "(module "+ stmt.Name.Lexeme
		  
		  For Each modul As Lox.Ast.ModuleStmt In stmt.Modules
		    sb.Append " "+ Print(modul)
		  Next
		  
		  For Each cls As Lox.Ast.ClassStmt In stmt.Classes
		    sb.Append " "+ Print(cls)
		  Next
		  
		  For Each fun As Lox.Ast.FunctionStmt In stmt.Functions
		    sb.Append " "+ Print(fun)
		  Next
		  
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitPrint(stmt As Lox.Ast.Print) As Variant
		  Return Parenthesize("print", stmt.Expression)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitReturnStmt(stmt As Lox.Ast.ReturnStmt) As Variant
		  If stmt.Value Is Nil Then Return "(return)"
		  
		  Return Parenthesize("return", stmt.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSet(expr As Lox.Ast.Set) As Variant
		  Return Parenthesize2("=", expr.Obj, expr.Name.Lexeme, expr.Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSuperExpr(expr As Lox.Ast.SuperExpr) As Variant
		  Return Parenthesize2("super", expr.Method)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitTernary(expr As Lox.Ast.Ternary) As Variant
		  Dim sb() As String
		  
		  sb.Append "(? "
		  sb.Append Print(expr.Expression)
		  sb.Append Parenthesize("", expr.ThenBranch)
		  sb.Append Parenthesize("", expr.ElseBranch)
		  sb.Append ")"
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitThis(expr As Lox.Ast.This) As Variant
		  Return "this"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitUnary(expr As Lox.Ast.Unary) As Variant
		  Return Parenthesize(expr.Operator.Lexeme, expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitVariable(expr As Lox.Ast.Variable) As Variant
		  Return expr.Name.Lexeme
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitVarStmt(stmt As Lox.Ast.VarStmt) As Variant
		  If stmt.Initializer Is Nil Then Return Parenthesize2("var", stmt.Name)
		  
		  Return Parenthesize2("var", stmt.Name, "=", stmt.Initializer)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitWhileStmt(stmt As Lox.Ast.WhileStmt) As Variant
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
