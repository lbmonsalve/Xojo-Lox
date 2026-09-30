#tag Class
Protected Class Number
Inherits Lox.Inter.LoxClass
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
		  Case "PI"
		    Return 3.14159265358979323846264338327950
		    
		  Case "abs", "sin", "cos", "tan", "sqrt"
		    Return New Lox.Inter.Std.NumberMethods(name, Self)
		    
		  Case "acos", "asin", "atan", "atan2"
		    Return New Lox.Inter.Std.NumberMethods(name, Self)
		    
		  Case "bin", "cdbl", "ceil", "exp", "floor", "hex", "log", "max", "min", "oct", "pow"
		    Return New Lox.Inter.Std.NumberMethods(name, Self)
		    
		  Case "round", "val", "str"
		    Return New Lox.Inter.Std.NumberMethods(name, Self)
		    
		  Case "equal"
		    Return New Lox.Inter.Std.NumberMethods(name, Self)
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "<class Number>"
		End Function
	#tag EndMethod


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
