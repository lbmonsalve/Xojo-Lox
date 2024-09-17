#tag Class
Protected Class TextMethods
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  Try
		    #pragma BreakOnExceptions Off
		    Select Case mMethodName
		    Case "asc"
		      Return Asc(args(0).StringValue)
		      
		    Case "chr"
		      Return Encodings.UTF8.Chr(args(0).IntegerValue)
		      
		    Case "decodeHex"
		      Return DecodeHex(args(0).StringValue)
		      
		    Case "encodeBase64"
		      Return EncodeBase64(args(0).StringValue, 0)
		      
		    Case "encodeHex"
		      Return EncodeHex(args(0).StringValue)
		      
		    Case "inStr"
		      Return InStr(args(0).StringValue, args(1).StringValue)
		      
		    Case "left"
		      Return Left(args(0).StringValue, args(1).IntegerValue)
		      
		    Case "len"
		      Return Len(args(0).StringValue)
		      
		    Case "lower"
		      Return Lowercase(args(0).StringValue)
		      
		    Case "mid"
		      If args.Ubound= 1 Then
		        Return Mid(args(0).StringValue, args(1).IntegerValue)
		      ElseIf args.Ubound= 2 Then
		        Return Mid(args(0).StringValue, args(1).IntegerValue, args(2).IntegerValue)
		      End If
		      
		    Case "nthField"
		      Return NthField(args(0).StringValue, args(1).StringValue, args(2).IntegerValue)
		      
		    Case "replace"
		      Return Replace(args(0).StringValue, args(1).StringValue, args(2).StringValue)
		      
		    Case "replaceAll"
		      Return ReplaceAll(args(0).StringValue, args(1).StringValue, args(2).StringValue)
		      
		    Case "right"
		      Return Right(args(0).StringValue, args(1).IntegerValue)
		      
		    Case "titleCase"
		      Return Titlecase(args(0).StringValue)
		      
		    Case "trim"
		      Return Trim(args(0).StringValue)
		      
		    Case "upper"
		      Return Uppercase(args(0).StringValue)
		      
		    Case "eol"
		      Dim eol As String= EndOfLine
		      Return eol
		      
		    End Select
		  Catch
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "mismatch in num/type of arguments.")
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(methodName As String, text As Lox.Inter.Std.Text)
		  mMethodName= methodName
		  mText= text
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mMethodName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mText As Lox.Inter.Std.Text
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
