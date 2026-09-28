#tag Class
Protected Class TextMethods
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  Dim hasValue As Boolean= mText.Value.Len> 0
		  
		  Try
		    #pragma BreakOnExceptions Off
		    
		    Select Case mMethodName
		    Case "asc"
		      Return Asc(Lox.Inter.Std.Text(args(0)).Value)
		      
		    Case "chr"
		      Return Encodings.UTF8.Chr(args(0).IntegerValue)
		      
		    Case "decodeBase64"
		      Return DecodeBase64(Lox.Inter.Std.Text(args(0)).Value)
		      
		    Case "decodeHex"
		      Return DecodeHex(Lox.Inter.Std.Text(args(0)).Value)
		      
		    Case "encodeBase64"
		      Return EncodeBase64(Lox.Inter.Std.Text(args(0)).Value, 0)
		      
		    Case "encodeHex"
		      Return EncodeHex(Lox.Inter.Std.Text(args(0)).Value)
		      
		    Case "inStr"
		      Dim arg0 As String= Lox.Inter.Std.Text(args(0)).Value
		      
		      If hasValue Then Return mText.Value.InStr(arg0)
		      Return InStr(arg0, Lox.Inter.Std.Text(args(1)).Value)
		      
		    Case "left"
		      Dim arg0 As String= Lox.Inter.Std.Text(args(0)).Value
		      
		      If hasValue Then Return mText.Value.Left(args(0).IntegerValue)
		      Return Left(arg0, args(1).IntegerValue)
		      
		    Case "len"
		      Return Len(Lox.Inter.Std.Text(args(0)).Value)
		      
		    Case "lower"
		      Return Lowercase(Lox.Inter.Std.Text(args(0)).Value)
		      
		    Case "mid"
		      Dim arg0 As String= Lox.Inter.Std.Text(args(0)).Value
		      
		      If hasValue Then
		        If args.Ubound= 0 Then
		          Return mText.Value.Mid(args(0).IntegerValue)
		        ElseIf args.Ubound= 1 Then
		          Return mText.Value.Mid(args(0).IntegerValue, args(1).IntegerValue)
		        End If
		      End If
		      
		      If args.Ubound= 1 Then
		        Return Mid(arg0, args(1).IntegerValue)
		      ElseIf args.Ubound= 2 Then
		        Return Mid(arg0, args(1).IntegerValue, args(2).IntegerValue)
		      End If
		      
		    Case "nthField"
		      Dim arg0 As String= Lox.Inter.Std.Text(args(0)).Value
		      
		      If hasValue Then Return mText.Value.NthField(arg0, args(1).IntegerValue)
		      Return NthField(arg0, Lox.Inter.Std.Text(args(1)).Value, args(2).IntegerValue)
		      
		    Case "replace"
		      Dim arg0 As String= Lox.Inter.Std.Text(args(0)).Value
		      
		      If hasValue Then Return mText.Value.Replace(arg0, Lox.Inter.Std.Text(args(1)).Value)
		      Return Replace(arg0, Lox.Inter.Std.Text(args(1)).Value, Lox.Inter.Std.Text(args(2)).Value)
		      
		    Case "replaceAll"
		      Dim arg0 As String= Lox.Inter.Std.Text(args(0)).Value
		      
		      If hasValue Then Return mText.Value.ReplaceAll(arg0, Lox.Inter.Std.Text(args(1)).Value)
		      Return ReplaceAll(arg0, Lox.Inter.Std.Text(args(1)).Value, Lox.Inter.Std.Text(args(2)).Value)
		      
		    Case "right"
		      Dim arg0 As String= Lox.Inter.Std.Text(args(0)).Value
		      
		      If hasValue Then Return mText.Value.Right(args(0).IntegerValue)
		      Return Right(arg0, args(1).IntegerValue)
		      
		    Case "titleCase"
		      Return Titlecase(Lox.Inter.Std.Text(args(0)).Value)
		      
		    Case "trim"
		      Return Trim(Lox.Inter.Std.Text(args(0)).Value)
		      
		    Case "upper"
		      Return Uppercase(Lox.Inter.Std.Text(args(0)).Value)
		      
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
