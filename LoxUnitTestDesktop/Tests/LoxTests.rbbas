#tag Class
Protected Class LoxTests
Inherits TestGroup
	#tag Event
		Sub Setup()
		  mOldPrintOut= Lox.PrintOut
		  Lox.PrintOut= New PrintOutHelper(Self)
		End Sub
	#tag EndEvent

	#tag Event
		Sub TearDown()
		  Lox.PrintOut= mOldPrintOut
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AssignmentTest()
		  Dim files() As FolderItem= FindFiles("assignment")
		  
		  For Each file As FolderItem In files
		    Assert.Message file.DisplayName
		    
		    Dim t As TextInputStream= TextInputStream.Open(file)
		    Dim source As String= t.ReadAll
		    
		    Dim expect() As String= GetExpect(source)
		    Dim actual() As String
		    
		    Dim scanner As New Lox.Scanner(source)
		    Dim tokens() As Lox.Token= scanner.Scan
		    
		    Dim parser As New Lox.Parser(tokens)
		    Dim statements() As Lox.Ast.Stmt= parser.Parse
		    'If parser.HadError Then Return
		    
		    Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		    resolver.Resolve(statements)
		    'If resolver.HadError Then Return
		    
		    Lox.Interpreter.Interpret(statements)
		    
		    Break
		    'Assert.AreEqual expect, actual, "AreEqual expect, actual"
		    
		  Next
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
		Private Function GetExpect(source As String) As String()
		  Dim lines() As String= source.Split(EndOfLine.UNIX)
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


	#tag Property, Flags = &h0
		BufferPrint As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOldPrintOut As Writeable
	#tag EndProperty


	#tag ViewBehavior
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
