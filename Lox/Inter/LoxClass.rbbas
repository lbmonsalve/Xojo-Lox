#tag Class
Protected Class LoxClass
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  Dim initializer As LoxFunction= FindMethod("init")
		  If initializer Is Nil Then Return 0
		  
		  Return initializer.Arity
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant) As Variant
		  Dim instance As New LoxInstance(Self)
		  
		  Dim initializer As LoxFunction= FindMethod("init")
		  If Not (initializer Is Nil) Then
		    Call initializer.Bind(instance).Call_(inter, args)
		  End If
		  
		  Return instance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(name As String, methods As Dictionary)
		  Self.Name= name
		  mMethods= methods
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As LoxFunction
		  If mMethods.HasKey(name) Then Return mMethods.Value(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return Name
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mMethods As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String
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
