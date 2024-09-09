#tag Class
Protected Class HashMapAssign
Inherits Lox.Ast.Expr
	#tag Method, Flags = &h0
		Function Accept(visitor As IExprVisitor) As Variant
		  Return visitor.VisitHashMapAssign(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(name As Token, key As Lox.Ast.Expr, operator As Token, value As Lox.Ast.Expr)
		  Self.Name= name
		  Self.Key= key
		  Self.Value= value
		  Self.Operator= operator
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Key As Expr
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As Token
	#tag EndProperty

	#tag Property, Flags = &h0
		Operator As Token
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
