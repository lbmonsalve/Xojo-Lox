#tag Class
Protected Class CSDictionary
Inherits Dictionary
	#tag Method, Flags = &h1000
		Sub Constructor(ParamArray entries() As Pair)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  For Each entry As Pair In entries
		    Value(entry.Left)= entry.Right
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasKey(key As Variant) As Boolean
		  If key.Type= 8 Then key= EncodeHex(key.StringValue)
		  Return Super.HasKey(key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Key(index As Integer) As Variant
		  Dim key As Variant= Super.Key(index)
		  If key.Type= 8 Then key= DecodeHex(key.StringValue)
		  Return key
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Keys() As Variant()
		  Dim keys() As Variant= Super.Keys
		  Dim retu() As Variant
		  
		  For Each key As Variant In keys
		    If key.Type= 8 Then key= DecodeHex(key.StringValue)
		    retu.Append key
		  Next
		  
		  Return retu
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Lookup(key As Variant, defaultValue As Variant) As Variant
		  If key.Type= 8 Then key= EncodeHex(key.StringValue)
		  Return Super.Lookup(key, defaultValue)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(key As Variant)
		  If key.Type= 8 Then key= EncodeHex(key.StringValue)
		  Super.Remove(key)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(key As Variant) As Variant
		  If key.Type= 8 Then key= EncodeHex(key.StringValue)
		  Return Super.Value(key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(key As Variant, Assigns _value As Variant)
		  If key.Type= 8 Then key= EncodeHex(key.StringValue)
		  Super.Value(key)= _value
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="BinCount"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Dictionary"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Dictionary"
		#tag EndViewProperty
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
