#tag Class
Protected Class IfStmt
Inherits Lox.Ast.Stmt
	#tag Method, Flags = &h0
		Function Accept(visitor As IStmtVisitor) As Variant
		  Return visitor.VisitIfStmt(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(condition As Expr, thenBranch As Stmt, elseBranch As Stmt, Optional orbranch() As Stmt)
		  Self.Condition= condition
		  Self.ThenBranch= thenBranch
		  Self.ElseBranch= elseBranch
		  Self.OrBranch= orbranch
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Condition As Expr
	#tag EndProperty

	#tag Property, Flags = &h0
		ElseBranch As Stmt
	#tag EndProperty

	#tag Property, Flags = &h0
		OrBranch() As Stmt
	#tag EndProperty

	#tag Property, Flags = &h0
		ThenBranch As Stmt
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
