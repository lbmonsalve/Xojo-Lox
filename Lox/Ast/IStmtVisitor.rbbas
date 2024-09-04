#tag Interface
Protected Interface IStmtVisitor
	#tag Method, Flags = &h0
		Function VisitBlock(stmt As Lox.Ast.Block) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBreakStmt(stmt As Lox.Ast.BreakStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitClassStmt(stmt As Lox.Ast.ClassStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitContinueStmt(stmt As Lox.Ast.ContinueStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitExpression(stmt As Lox.Ast.Expression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFunctionStmt(stmt As Lox.Ast.FunctionStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIfStmt(stmt As Lox.Ast.IfStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitModuleStmt(stmt As Lox.Ast.ModuleStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitPrint(stmt As Lox.Ast.Print) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitReturnStmt(stmt As Lox.Ast.ReturnStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitVarStmt(stmt As Lox.Ast.VarStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitWhileStmt(stmt As Lox.Ast.WhileStmt) As Variant
		  
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
End Interface
#tag EndInterface
