#tag Class
Protected Class Environment
	#tag Method, Flags = &h0
		Function Ancestor(distance As Integer) As Environment
		  Dim env As Environment= Self
		  For i As Integer= 0 To distance- 1
		    env= env.Enclosing
		  Next
		  Return env
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Assign(name As Lox.Token, value As Variant)
		  If mValues.HasKey(name.Lexeme) Then
		    mValues.Value(name.Lexeme)= value
		    Return
		  End If
		  
		  If Not (Enclosing Is Nil) Then
		    Enclosing.Assign name, value
		    Return
		  End If
		  
		  #pragma BreakOnExceptions Off
		  Raise New RuntimeError(name, "Undefined variable '" + name.lexeme + "'.")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssignAt(distance As Integer, name As Lox.Token, value As Variant)
		  Ancestor(distance).Values.Value(name.Lexeme)= value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  mValues= New Lox.Misc.CSDictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(enclosing As Environment)
		  Constructor
		  Self.Enclosing= enclosing
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Define(name As String, value As Variant)
		  mValues.Value(name)= value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Get(name As Lox.Token) As Variant
		  If mValues.HasKey(name.Lexeme) Then Return mValues.Value(name.Lexeme)
		  
		  If Not (Enclosing Is Nil) Then Return Enclosing.Get(name)
		  
		  #pragma BreakOnExceptions Off
		  Raise New RuntimeError(name, "Undefined variable '" + name.lexeme + "'.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetAt(distance As Integer, name As String) As Variant
		  Return Ancestor(distance).Values.Value(name)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Enclosing As Environment
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mValues As Lox.Misc.CSDictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mValues
			End Get
		#tag EndGetter
		Values As Lox.Misc.CSDictionary
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
