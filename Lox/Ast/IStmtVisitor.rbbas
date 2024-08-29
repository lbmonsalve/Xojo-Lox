#tag Interface
Protected Interface IStmtVisitor
	#tag Method, Flags = &h0
		Function Visit(stmt As Block) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As ClassStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Expression) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As FunctionStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As IfStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As Print) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As ReturnStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As VarStmt) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Visit(stmt As WhileStmt) As Variant
		  
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
