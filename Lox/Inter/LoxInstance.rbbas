#tag Class
Protected Class LoxInstance
	#tag Method, Flags = &h0
		Sub Constructor(klass As LoxClass)
		  mClass= klass
		  mFields= New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Get(name As Token) As Variant
		  If mFields.HasKey(name.Lexeme) Then
		    Return mFields.Value(name.Lexeme)
		  End If
		  
		  Dim method As LoxFunction= mClass.FindMethod(name.Lexeme)
		  If Not (method Is Nil) Then Return method
		  
		  #pragma BreakOnExceptions Off
		  Raise New RuntimeError(name, "Undefined property '" + name.lexeme + "'.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(name As Token, value As Variant)
		  mFields.Value(name.Lexeme)= value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return mClass.Name+ " instance"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mClass As LoxClass
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFields As Dictionary
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
