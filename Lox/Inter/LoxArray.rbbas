#tag Class
Protected Class LoxArray
Inherits Lox.Inter.LoxClass
	#tag Method, Flags = &h0
		Sub Arity()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant) As Variant
		  Select Case args.Ubound
		  Case -1
		    Return New Lox.Inter.LoxArray
		  Case 0
		    Return New Lox.Inter.LoxArray(args(0).IntegerValue)
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Constructor -1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(size As Integer)
		  // Calling the overridden superclass constructor.
		  Super.Constructor Self
		  
		  If size>= 0 Then ReDim Elements(size)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(elements() As Variant)
		  // Calling the overridden superclass constructor.
		  Super.Constructor Self
		  
		  For Each element As Variant In elements
		    Self.Elements.Append element
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As Variant
		  Select Case name
		  Case "empty"
		    Return Elements.Ubound= -1
		  Case "length"
		    Return Elements.Ubound+ 1
		  Case "pop", "push", "each", "indexOf", "map", "deleteAt"
		    Return New Lox.Inter.LoxArrayMethods(name, Self)
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "<class Array>"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Elements() As Variant
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
