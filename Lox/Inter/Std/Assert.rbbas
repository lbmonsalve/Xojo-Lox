#tag Class
Protected Class Assert
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  Return 2
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant) As Variant
		  Dim eval As Variant= args(0)
		  Dim mess As String= args(1).StringValue
		  
		  If eval.IsNull Then
		    Raise New RuntimeError(New Token(TokenType.NIL_, "", Nil, -1), "Failed assertion: " + mess)
		  End If
		  
		  If eval.BooleanValue= False Then
		    Raise New RuntimeError(New Token(TokenType.NIL_, "", Nil, -1), "Failed assertion: " + mess)
		  End If
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "<fn assert>"
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
End Class
#tag EndClass
