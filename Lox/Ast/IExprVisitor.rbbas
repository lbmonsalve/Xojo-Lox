#tag Interface
Protected Interface IExprVisitor
	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Assign) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Binary) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.CallExpr) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Get) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Grouping) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Literal) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Logical) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Set) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.SuperExpr) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.This) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Unary) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(expr As Lox.Ast.Variable) As Variant
		  
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
