#tag Class
Protected Class LoxTests
Inherits TestGroup
	#tag Event
		Sub Setup()
		  Lox.PrintOut= New PrintOutHelper(Self)
		  Lox.ErrorOut= New ErrorOutHelper(Self)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub BreakTest()
		  BufferPrint= ""
		  Lox.Interpreter.Reset
		  
		  Dim scanner As New Lox.Scanner(kBreakSnnipet)
		  Dim tokens() As Lox.Token= scanner.Scan
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  
		  Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  
		  Lox.Interpreter.Interpret(statements)
		  
		  Dim expect() As String= GetExpect(kBreakSnnipet)
		  Dim actual() As String= Split(BufferPrint, EndOfLine)
		  If actual.Ubound> -1 Then
		    actual.Remove actual.Ubound
		    Assert.AreEqual expect, actual, "AreEqual expect, actual"
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompoundAssignmentOperatorsTest()
		  BufferPrint= ""
		  Lox.Interpreter.Reset
		  
		  Dim scanner As New Lox.Scanner(kCompoundSnnipet)
		  Dim tokens() As Lox.Token= scanner.Scan
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  
		  Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  
		  Lox.Interpreter.Interpret(statements)
		  
		  Dim expect() As String= GetExpect(kCompoundSnnipet)
		  Dim actual() As String= Split(BufferPrint, EndOfLine)
		  If actual.Ubound> -1 Then
		    actual.Remove actual.Ubound
		    Assert.AreEqual expect, actual, "AreEqual expect, actual"
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExtendIdNamesTest()
		  Dim snnipet As String= kExtendIdSnnipet.ReplaceAll("$emoji$", Encodings.UTF8.Chr(&h1f600))
		  
		  BufferPrint= ""
		  Lox.Interpreter.Reset
		  
		  Dim scanner As New Lox.Scanner(snnipet)
		  Dim tokens() As Lox.Token= scanner.Scan
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  
		  Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  
		  Lox.Interpreter.Interpret(statements)
		  
		  Dim expect() As String= GetExpect(snnipet)
		  Dim actual() As String= Split(BufferPrint, EndOfLine)
		  If actual.Ubound> -1 Then
		    actual.Remove actual.Ubound
		    Assert.AreEqual expect, actual, "AreEqual expect, actual"
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindFiles(folderName As String) As FolderItem()
		  Dim parent As FolderItem= app.ExecutableFile.Parent
		  Dim folder As FolderItem, found As Boolean
		  
		  While parent<> Nil
		    
		    folder= parent.Child("Examples")
		    If folder.Exists And folder.Directory Then
		      found= True
		      Exit
		    End If
		    
		    parent= parent.Parent
		  Wend
		  
		  Dim files() As FolderItem
		  If Not found Then Return files
		  
		  Dim child As FolderItem= folder.Child(folderName)
		  If Not (child.Exists And child.Directory) Then Return files
		  
		  For i As Integer= 1 To child.Count
		    files.Append child.Item(i)
		  Next
		  
		  Return files
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindFolders() As String()
		  Dim parent As FolderItem= app.ExecutableFile.Parent
		  Dim folder As FolderItem, found As Boolean
		  
		  While parent<> Nil
		    
		    folder= parent.Child("Examples")
		    If folder.Exists And folder.Directory Then
		      found= True
		      Exit
		    End If
		    
		    parent= parent.Parent
		  Wend
		  
		  Dim folders() As String
		  If Not found Then Return folders
		  
		  For i As Integer= 1 To folder.Count
		    Dim item As FolderItem= folder.Item(i)
		    If item.Directory Then
		      folders.Append item.DisplayName
		    End If
		  Next
		  
		  Return folders
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetActualError(buffer As String) As String
		  Dim actualArr() As String= Split(buffer, EndOfLine)
		  If actualArr.Ubound> -1 Then
		    Dim actualStr As String= actualArr(0)
		    Return actualStr.Mid(actualStr.InStr("Error"))
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetExpect(source As String) As String()
		  Dim lines() As String= ReplaceLineEndings(source, EndOfLine).Split(EndOfLine)
		  Dim resul() As String
		  Dim search As String= "// expect: "
		  
		  For Each line As String In lines
		    Dim pos As Integer= line.InStr(search)
		    If pos> 0 Then
		      resul.Append line.Mid(pos+ 11)
		    End If
		  Next
		  
		  Return resul
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetExpectError(source As String) As String
		  Dim lines() As String= ReplaceLineEndings(source, EndOfLine).Split(EndOfLine)
		  Dim search As String= "Error"
		  
		  For Each line As String In lines
		    Dim pos As Integer= line.InStr(search)
		    If pos> 0 Then
		      Return line.Mid(pos)
		    End If
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetExpectRuntimeError(source As String) As String
		  Dim lines() As String= ReplaceLineEndings(source, EndOfLine).Split(EndOfLine)
		  Dim search As String= "// expect runtime error:"
		  
		  For Each line As String In lines
		    Dim pos As Integer= line.InStr(search)
		    If pos> 0 Then
		      Return line.Mid(pos+ 25)
		    End If
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IfOrElseTest()
		  BufferPrint= ""
		  Lox.Interpreter.Reset
		  
		  Dim scanner As New Lox.Scanner(kIfOrElseSnnipet)
		  Dim tokens() As Lox.Token= scanner.Scan
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  
		  Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  
		  Lox.Interpreter.Interpret(statements)
		  
		  Dim expect() As String= GetExpect(kIfOrElseSnnipet)
		  Dim actual() As String= Split(BufferPrint, EndOfLine)
		  If actual.Ubound> -1 Then
		    actual.Remove actual.Ubound
		    Assert.AreEqual expect, actual, "AreEqual expect, actual"
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InterpreterTest()
		  Dim folders() As String= FindFolders
		  
		  For Each folder As String In folders
		    // skip folders:
		    If folder= "benchmark" Then Continue
		    If folder= "expressions" Then Continue
		    If folder= "scanning" Then Continue
		    If folder= "limit" Then Continue
		    If folder= "operator" Then Continue
		    
		    Assert.Message folder+ ":"
		    
		    Dim files() As FolderItem= FindFiles(folder)
		    
		    For Each file As FolderItem In files
		      // skip files:
		      If file.DisplayName= "inherit_from_nil.lox" Then Continue
		      
		      BufferPrint= ""
		      BufferError= ""
		      Lox.Interpreter.Reset
		      
		      Assert.Message file.DisplayName
		      
		      Dim t As TextInputStream= TextInputStream.Open(file)
		      Dim source As String= t.ReadAll
		      
		      Dim scanner As New Lox.Scanner(source)
		      Dim tokens() As Lox.Token= scanner.Scan
		      If scanner.HadError Then
		        Dim expectStr As String= GetExpectError(source)
		        Dim actualStr As String= GetActualError(BufferError)
		        Assert.AreEqual expectStr, actualStr, "AreEqual expectStr, actualStr"
		        
		        Continue
		      End If
		      
		      Dim parser As New Lox.Parser(tokens)
		      Dim statements() As Lox.Ast.Stmt= parser.Parse
		      If parser.HadError Then
		        Dim expectStr As String= GetExpectError(source)
		        Dim actualStr As String= GetActualError(BufferError)
		        Assert.AreEqual expectStr, actualStr, "AreEqual expectStr, actualStr"
		        
		        Continue
		      End If
		      
		      Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		      resolver.Resolve(statements)
		      If resolver.HadError Then
		        Dim expectStr As String= GetExpectError(source)
		        Dim actualArr() As String= Split(BufferError, EndOfLine)
		        If actualArr.Ubound> -1 Then
		          Dim actualStr As String= actualArr(0).Mid(10)
		          Assert.AreEqual expectStr, actualStr, "AreEqual expectStr, actualStr"
		        Else
		          Break
		        End If
		        
		        Continue
		      End If
		      
		      Lox.Interpreter.Interpret(statements)
		      If Lox.Interpreter.HadRuntimeError Then
		        Dim expectStr As String= GetExpectRuntimeError(source)
		        Dim actualStr As String= BufferError.Left(BufferError.InStr(EndOfLine)- 1)
		        
		        Assert.AreEqual expectStr, actualStr, "AreEqual expectStr, actualStr"
		        
		        Continue
		      End If
		      
		      Dim expect() As String= GetExpect(source)
		      Dim actual() As String= Split(BufferPrint, EndOfLine)
		      
		      If expect.Ubound> -1 Then
		        actual.Remove actual.Ubound
		        Assert.AreEqual expect, actual, "AreEqual expect, actual"
		      End If
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PostfixExprTest()
		  Dim snnipet As String= "var i=1; i++; print i;"
		  
		  BufferPrint= ""
		  Lox.Interpreter.Reset
		  
		  Dim scanner As New Lox.Scanner(snnipet)
		  Dim tokens() As Lox.Token= scanner.Scan
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  
		  Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  
		  Lox.Interpreter.Interpret(statements)
		  
		  Dim actual As String= BufferPrint.Left(BufferPrint.InStr(EndOfLine)- 1)
		  Assert.AreEqual "2.0", actual, ".AreEqual ""2.0"", actual"
		  
		  
		  BufferPrint= ""
		  
		  snnipet= "i--; print i;"
		  
		  scanner= New Lox.Scanner(snnipet)
		  parser= New Lox.Parser(scanner.Scan)
		  statements= parser.Parse
		  'resolver= New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  Lox.Interpreter.Interpret(statements)
		  
		  actual= BufferPrint.Left(BufferPrint.InStr(EndOfLine)- 1)
		  Assert.AreEqual "1.0", actual, ".AreEqual ""1.0"", actual"
		  
		  'Break
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrefixedNumbersTest()
		  BufferPrint= ""
		  Lox.Interpreter.Reset
		  
		  Dim scanner As New Lox.Scanner(kPrefixedNumberSnnipet)
		  Dim tokens() As Lox.Token= scanner.Scan
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  
		  Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  
		  Lox.Interpreter.Interpret(statements)
		  
		  Dim expect() As String= GetExpect(kPrefixedNumberSnnipet)
		  Dim actual() As String= Split(BufferPrint, EndOfLine)
		  If actual.Ubound> -1 Then
		    actual.Remove actual.Ubound
		    Assert.AreEqual expect, actual, "AreEqual expect, actual"
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ScannerTest()
		  Dim files() As FolderItem= FindFiles("scanning")
		  
		  For Each file As FolderItem In files
		    Assert.Message file.DisplayName
		    
		    Dim t As TextInputStream= TextInputStream.Open(file)
		    Dim source As String= t.ReadAll
		    
		    Dim expect() As String= GetExpect(source)
		    Dim actual() As String
		    
		    Dim scanner As New Lox.Scanner(source)
		    Dim tokens() As Lox.Token= scanner.Scan
		    For Each token As Lox.Token In tokens
		      actual.Append token.TypeToken.ToString+ " "+ _
		      token.Lexeme+ " "+ token.Literal.ToStringLox
		    Next
		    
		    Assert.AreEqual expect, actual, "AreEqual expect, actual"
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TernaryTest()
		  Dim snnipet As String= "var a=1; var b=2; var c=a>b?1:2; print c;"
		  
		  BufferPrint= ""
		  Lox.Interpreter.Reset
		  
		  Dim scanner As New Lox.Scanner(snnipet)
		  Dim tokens() As Lox.Token= scanner.Scan
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  
		  Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  
		  Lox.Interpreter.Interpret(statements)
		  
		  Dim actual As String= BufferPrint.Left(BufferPrint.InStr(EndOfLine)- 1)
		  Assert.AreEqual "2.0", actual, ".AreEqual ""2.0"", actual"
		  
		  BufferPrint= ""
		  
		  snnipet= "var a=1; var b=2; var c=a<b?1:2; print c;"
		  
		  scanner= New Lox.Scanner(snnipet)
		  parser= New Lox.Parser(scanner.Scan)
		  statements= parser.Parse
		  'resolver= New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  Lox.Interpreter.Interpret(statements)
		  
		  actual= BufferPrint.Left(BufferPrint.InStr(EndOfLine)- 1)
		  Assert.AreEqual "1.0", actual, ".AreEqual ""1.0"", actual"
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BufferError As String
	#tag EndProperty

	#tag Property, Flags = &h0
		BufferPrint As String
	#tag EndProperty


	#tag Constant, Name = kBreakSnnipet, Type = String, Dynamic = False, Default = \"var bb\x3D0;\rwhile (true) {\r  if (bb\x3D10) break;\r  bb++;\r}\rprint bb; // expect: 10.0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCompoundSnnipet, Type = String, Dynamic = False, Default = \"var a\x3D5;\ra+\x3D5;\rprint a; // expect: 10.0\ra-\x3D3;\rprint a; // expect: 7.0\ra*\x3D5;\rprint a; // expect: 35.0\ra/\x3D2;\rprint a; // expect: 17.5", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExtendIdSnnipet, Type = String, Dynamic = False, Default = \"var a\xC3\xB1o\x3D2024; print a\xC3\xB1o; // expect: 2024.0\rvar \xCE\xA3\x3D \"sigma\"; print \xCE\xA3; // expect: sigma\rvar $emoji$\x3D \"smileyface\";\rprint $emoji$; // expect: smileyface", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kIfOrElseSnnipet, Type = String, Dynamic = False, Default = \"if (false) {print \"if\";}\r  or (true) {print \"or\";} // expect: or\r  else {print \"else\";} \r\rif (false) {print \"if\";}\r or (false) {print \"or\";}\r  else {print \"else\";} // expect: else", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPrefixedNumberSnnipet, Type = String, Dynamic = False, Default = \"var h\x3D0x2324; \rvar o\x3D0o1056; \rvar b\x3D0b1110;\rprint h; // expect: 8996.0\rprint o; // expect: 558.0\rprint b; // expect: 14.0", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="BufferError"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BufferPrint"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="TestGroup"
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
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
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
