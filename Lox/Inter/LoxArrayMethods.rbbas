#tag Class
Protected Class LoxArrayMethods
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant) As Variant
		  Select Case MethodName
		  Case "pop"
		    Return Owner.Elements.Pop
		  Case "push"
		    Dim arr As New Lox.Inter.LoxArray(Owner.Elements)
		    Dim elems() As Variant= arr.Elements
		    For Each arg As Variant In args
		      elems.Append arg
		    Next
		    Return arr
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(methodName As String, owner As Lox.Inter.LoxArray)
		  Self.MethodName= methodName
		  Self.Owner= owner
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		MethodName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Owner As Lox.Inter.LoxArray
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
			Name="MethodName"
			Group="Behavior"
			Type="String"
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
