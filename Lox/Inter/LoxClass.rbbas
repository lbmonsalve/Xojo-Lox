#tag Class
Protected Class LoxClass
Inherits Lox.Inter.LoxInstance
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
		Sub Constructor(metaclass As LoxClass, name As String, superClass As LoxClass, methods As Lox.Misc.CSDictionary)
		  Self.Name= name
		  Self.SuperClass= superClass
		  mMethods= methods
		  
		  Super.Constructor metaclass
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As LoxFunction
		  If mMethods.HasKey(name) Then Return mMethods.Value(name)
		  If Not (SuperClass Is Nil) Then Return SuperClass.FindMethod(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "<class "+ Name+ ">"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mMethods As Lox.Misc.CSDictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SuperClass As LoxClass
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
