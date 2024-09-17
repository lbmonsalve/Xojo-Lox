#tag Class
Protected Class RegExLox
Inherits Lox.Inter.LoxClass
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  Try
		    #pragma BreakOnExceptions Off
		    Select Case args.Ubound
		    Case 0
		      Return New Lox.Inter.Std.RegExLox(args(0).StringValue)
		      
		    End Select
		  Catch
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "mismatch in num/type of arguments.")
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  Super.Constructor Self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(pattern As String)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(metaclass As LoxClass, name As String, superClass As LoxClass, methods As Lox.Misc.CSDictionary) -- From LoxClass
		  // Constructor(klass As LoxClass) -- From LoxInstance
		  Constructor
		  
		  mRegEx= New RegEx
		  mRegEx.SearchPattern= pattern
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As Variant
		  Select Case name
		  Case "caseSensitive"
		    Return mRegEx.Options.CaseSensitive
		    
		  Case "greedy"
		    Return mRegEx.Options.Greedy
		    
		  Case "match"
		    Return New Lox.Inter.Std.RegExLoxMatch(mRegEx)
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "<class RegEx>"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Match As RegExMatch
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRegEx As RegEx
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
