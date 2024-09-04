#tag Class
Protected Class Expression
Inherits Lox.Ast.Stmt
	#tag Method, Flags = &h0
		Function Accept(visitor As IStmtVisitor) As Variant
		  Return visitor.VisitExpression(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(expression As Expr)
		  Self.Expression= expression
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Expression As Expr
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
