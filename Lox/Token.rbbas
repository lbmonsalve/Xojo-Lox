#tag Class
Protected Class Token
	#tag Method, Flags = &h0
		Sub Constructor(type As TokenType, lexeme As String, literal As Variant, line As Integer)
		  mTypeToken= type
		  mLexeme= lexeme
		  mLiteral= literal
		  mLine= line
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return TypeToken.ToString+ " "+ Lexeme+ " "+ Literal.ToString
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLexeme
			End Get
		#tag EndGetter
		Lexeme As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLine
			End Get
		#tag EndGetter
		Line As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLiteral
			End Get
		#tag EndGetter
		Literal As Variant
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mLexeme As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLine As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLiteral As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTypeToken As TokenType
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mTypeToken
			End Get
		#tag EndGetter
		TypeToken As TokenType
	#tag EndComputedProperty


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
			Name="Lexeme"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Line"
			Group="Behavior"
			Type="Integer"
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
