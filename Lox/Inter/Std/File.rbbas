#tag Class
Protected Class File
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
		      Return New Lox.Inter.Std.File
		      
		    Case 0
		      Return New Lox.Inter.Std.File(args(0).StringValue)
		      
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
		  Constructor ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(file As FolderItem)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(metaclass As LoxClass, name As String, superClass As LoxClass, methods As Lox.Misc.CSDictionary) -- From LoxClass
		  // Constructor(klass As LoxClass) -- From LoxInstance
		  Super.Constructor Self
		  
		  FileItem= file
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(path As String)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(metaclass As LoxClass, name As String, superClass As LoxClass, methods As Lox.Misc.CSDictionary) -- From LoxClass
		  // Constructor(klass As LoxClass) -- From LoxInstance
		  Super.Constructor Self
		  
		  Try
		    #pragma BreakOnExceptions Off
		    FileItem= GetFolderItem(path)
		  Catch
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(New Token(Lox.TokenType.NIL_, "",Nil,  -1), "File access error")
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As Variant
		  Select Case name
		  Case "appdata"
		    Return New Lox.Inter.Std.File(SpecialFolder.ApplicationData)
		    
		  Case "documents"
		    Return New Lox.Inter.Std.File(SpecialFolder.Documents)
		    
		  Case "temp"
		    Return New Lox.Inter.Std.File(SpecialFolder.Temporary)
		    
		  Case "tempfile"
		    Return New Lox.Inter.Std.File(GetTemporaryFolderItem)
		    
		  Case "count"
		    Return FileItem.Count
		    
		  Case "directory"
		    Return FileItem.Directory
		    
		  Case "exists"
		    Return FileItem.Exists
		    
		  Case "length"
		    Return FileItem.Length
		    
		  Case "name"
		    Return FileItem.DisplayName
		    
		  Case "parent"
		    Return New Lox.Inter.Std.File(FileItem.Parent)
		    
		  Case "path"
		    Return FileItem.Parent.AbsoluteNativePathLox
		    
		  Case "read", "write", "item", "child"
		    Return New Lox.Inter.Std.FileMethods(name, Self)
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "<class File>"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		FileItem As FolderItem
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
