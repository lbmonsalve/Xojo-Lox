#tag Class
Protected Class Text
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
		    Case -1
		      Return New Lox.Inter.Std.Text
		      
		    Case 0
		      Return New Lox.Inter.Std.Text(args(0).StringValue)
		      
		    End Select
		  Catch
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "mismatch in num/type of arguments.")
		  End Try
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

	#tag Method, Flags = &h1000
		Sub Constructor(value As String)
		  Constructor
		  
		  Self.Value= value
		  
		  Set New Lox.Token(Lox.TokenType.STRING_, "len", Nil, -1), Value.Len
		  Set New Lox.Token(Lox.TokenType.STRING_, "lenB", Nil, -1), Value.LenB
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As Variant
		  If Value.Len> 0 Then
		    Select Case name
		    Case "encodeHex"
		      Return EncodeHex(Self.Value)
		    Case "decodeHex"
		      Return DecodeHex(Self.Value)
		    Case "encodeBase64"
		      Return EncodeBase64(Self.Value, 0)
		    Case "decodeBase64"
		      Return DecodeBase64(Self.Value)
		    Case "lower"
		      Return Lowercase(Self.Value)
		    Case "titleCase"
		      Return Titlecase(Self.Value)
		    Case "trim"
		      Return Trim(Self.Value)
		    Case "upper"
		      Return Uppercase(Self.Value)
		    End Select
		  End If
		  
		  Select Case name
		  Case "asc", "chr", "encodeHex", "decodeHex", "inStr", "left", "len", "lower"
		    Return New Lox.Inter.Std.TextMethods(name, Self)
		    
		  Case "mid", "nthField", "replace", "replaceAll", "right", "titleCase", "trim", "upper", "eol"
		    Return New Lox.Inter.Std.TextMethods(name, Self)
		    
		  Case "encodeBase64", "decodeBase64"
		    Return New Lox.Inter.Std.TextMethods(name, Self)
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return Self.Value
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Value As String
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
		#tag ViewProperty
			Name="Value"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
