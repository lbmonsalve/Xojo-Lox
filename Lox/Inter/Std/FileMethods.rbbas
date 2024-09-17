#tag Class
Protected Class FileMethods
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
		    Case "read"
		      Dim ti As TextInputStream= TextInputStream.Open(mFile.FileItem)
		      Return ti.ReadAll(Encodings.UTF8)
		    Case "write"
		      Dim source As String= args(0)
		      If source.Len= 0 Then Return mFile
		      
		      Dim tt As TextOutputStream= TextOutputStream.Create(mFile.FileItem)
		      tt.Write source
		    End Select
		  Catch exc As IOException
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(New Token(Lox.TokenType.NIL_, "",Nil,  -1), _
		    "IOException")
		  Catch
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "mismatch in num/type of arguments.")
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(methodName As String, file As Lox.Inter.Std.File)
		  mMethodName= methodName
		  mFile= file
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mFile As Lox.Inter.Std.File
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMethodName As String
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
