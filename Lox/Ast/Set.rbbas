#tag Class
Protected Class Set
Inherits Lox.Ast.Expr
	#tag Method, Flags = &h0
		Function Accept(visitor As IExprVisitor) As Variant
		  Return visitor.VisitSet(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(obj As Expr, name As Lox.Token, value As Expr)
		  Self.Obj= obj
		  Self.Name= name
		  Self.Value= value
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Name As Lox.Token
	#tag EndProperty

	#tag Property, Flags = &h0
		Obj As Expr
	#tag EndProperty

	#tag Property, Flags = &h0
		Value As Expr
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
