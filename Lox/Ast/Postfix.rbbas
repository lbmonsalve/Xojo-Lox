#tag Class
Protected Class Postfix
Inherits Lox.Ast.Expr
	#tag Method, Flags = &h0
		Function Accept(visitor As IExprVisitor) As Variant
		  Return visitor.VisitPostfix(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(name As Token, operator As Lox.Token, left As Expr)
		  Self.Name= name
		  Self.Operator= operator
		  Self.Left= Left
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Left As Expr
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As Token
	#tag EndProperty

	#tag Property, Flags = &h0
		Operator As Lox.Token
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
