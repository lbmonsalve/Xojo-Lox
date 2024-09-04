#tag Class
Protected Class ClassStmt
Inherits Lox.Ast.Stmt
	#tag Method, Flags = &h0
		Function Accept(visitor As IStmtVisitor) As Variant
		  Return visitor.VisitClassStmt(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(name As Lox.Token, superClass As Lox.Ast.Variable, methods() As FunctionStmt, classMethods() As FunctionStmt)
		  Self.Name= name
		  Self.SuperClass= superClass
		  Self.Methods= methods
		  Self.ClassMethods= classMethods
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		ClassMethods() As FunctionStmt
	#tag EndProperty

	#tag Property, Flags = &h0
		Methods() As FunctionStmt
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As Lox.Token
	#tag EndProperty

	#tag Property, Flags = &h0
		SuperClass As Lox.Ast.Variable
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
