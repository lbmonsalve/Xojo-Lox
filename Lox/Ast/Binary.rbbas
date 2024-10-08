#tag Class
Protected Class Binary
Inherits Lox.Ast.Expr
	#tag Method, Flags = &h0
		Function Accept(visitor As IExprVisitor) As Variant
		  Return visitor.VisitBinary(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(left As Expr, operator As Lox.Token, right As Expr)
		  Self.Left= left
		  Self.Operator= operator
		  Self.Right= right
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Left As Expr
	#tag EndProperty

	#tag Property, Flags = &h0
		Operator As Lox.Token
	#tag EndProperty

	#tag Property, Flags = &h0
		Right As Expr
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
