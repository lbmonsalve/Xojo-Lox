#tag Class
Protected Class RangeLiteral
Inherits Lox.Ast.Expr
	#tag Method, Flags = &h0
		Function Accept(visitor As IExprVisitor) As Variant
		  Return visitor.VisitRangeLiteral(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(from As Expr, op As Token, to_ As Expr, by As Expr)
		  Self.From= from
		  Self.Operator= op
		  Self.To_= to_
		  Self.By= by
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		By As Expr
	#tag EndProperty

	#tag Property, Flags = &h0
		From As Expr
	#tag EndProperty

	#tag Property, Flags = &h0
		Operator As Token
	#tag EndProperty

	#tag Property, Flags = &h0
		To_ As Expr
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
