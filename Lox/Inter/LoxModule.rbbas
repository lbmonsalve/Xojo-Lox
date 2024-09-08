#tag Class
Protected Class LoxModule
Inherits Lox.Inter.LoxInstance
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant) As Variant
		  // Disallow instantiation of modules.
		  Raise New RuntimeError(New Token(TokenType.NIL_, "", Nil, -1), "Cannot create an instance of a module.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(metaClass As LoxClass, name As String, modules() As LoxModule, classes() As LoxClass, funcs As Lox.Misc.CSDictionary)
		  // Calling the overridden superclass constructor.
		  Super.Constructor metaClass
		  Self.Name= name
		  
		  // Modules.
		  For Each modul As LoxModule In modules
		    Fields.Value(modul.Name)= modul
		  Next
		  
		  // Classes.
		  For Each cls As LoxClass In classes
		    Fields.Value(cls.Name)= cls
		  Next
		  
		  // Functions.
		  Self.Funcs= funcs
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindFunc(instance As LoxInstance, name As String) As LoxFunction
		  // Does this module have the requested method?
		  If Funcs.HasKey(name) Then Return LoxFunction(Funcs.Value(name)).Bind(instance)
		  
		  // Can't find this method.
		  Return Nil
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Funcs As Lox.Misc.CSDictionary
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
