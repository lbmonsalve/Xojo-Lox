#tag Class
Protected Class ModuleStmt
Inherits Lox.Ast.Stmt
	#tag Method, Flags = &h0
		Function Accept(visitor As IStmtVisitor) As Variant
		  Return visitor.VisitModuleStmt(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(name As Lox.Token, modules() As ModuleStmt, classes() As ClassStmt, functions() As FunctionStmt)
		  Self.Name= name
		  Self.Modules= modules
		  Self.Classes= classes
		  Self.Functions= functions
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Classes() As ClassStmt
	#tag EndProperty

	#tag Property, Flags = &h0
		Functions() As FunctionStmt
	#tag EndProperty

	#tag Property, Flags = &h0
		Modules() As ModuleStmt
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As Lox.Token
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
