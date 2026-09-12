#tag Class
Protected Class LoxRange
Inherits Lox.Inter.LoxClass
	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  Select Case args.Ubound
		  Case -1
		    Return New Lox.Inter.LoxRange
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(metaclass As LoxClass, name As String, superClass As LoxClass, methods As Lox.Misc.CSDictionary) -- From LoxClass
		  // Constructor(klass As LoxClass) -- From LoxInstance
		  Super.Constructor Self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As Variant
		  Select Case name
		  Case "from"
		    Return From
		  Case "to"
		    Return To_
		  Case "by"
		    Return By
		  Case "includeTo"
		    Return IncludeTo_
		  Case "makeIterator", "next"
		    Return New Lox.Inter.LoxRangeMethods(name, Self)
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "<class Range>"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		By As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		From As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		IncludeTo_ As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		To_ As Double
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
