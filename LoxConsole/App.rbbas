#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // CommandLineArgs: ..\Examples\precedence.lox
		  
		  If args.Ubound> 1 Then
		    Print "Usage: lox [script]"
		    Quit 64
		  ElseIf args.Ubound= 1 Then
		    RunFile args(1)
		  Else
		    RunPrompt
		  End If
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function LoadFile(path As String) As String
		  If path.Len= 0 Then Return ""
		  
		  Try
		    #pragma BreakOnExceptions Off
		    Dim ti As TextInputStream= TextInputStream.Open(GetFolderItem(path))
		    Return ti.ReadAll(Encodings.UTF8)
		    #pragma BreakOnExceptions Default
		  Catch exc As IOException
		    PrintText "Error ("+ Str(exc.ErrorNumber)+ ") loading "+ path
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PrintText(txt As String)
		  Dim buff As String= ReplaceLineEndings(txt, EndOfLine.UNIX)
		  Dim lines() As String= buff.Split(EndOfLine.UNIX)
		  For Each line As String In lines
		    If line.Len= 0 Then line= " " //+ EndOfLine
		    StdOut.WriteLine line
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Run(source As String)
		  Dim scanner As New Lox.Scanner(source)
		  Dim tokens() As Lox.Token= scanner.Scan
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  
		  If Lox.HadError Then Return // Stop if there was a syntax error.
		  
		  Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  
		  Lox.Interpreter.Interpret(statements)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunFile(path As String)
		  Try
		    #pragma BreakOnExceptions Off
		    Dim ti As TextInputStream= TextInputStream.Open(GetFolderItem(path))
		    Run ti.ReadAll(Encodings.UTF8)
		    #pragma BreakOnExceptions Default
		  Catch exc As IOException
		    System.DebugLog CurrentMethodName+ " IOException: "+ path
		  End Try
		  
		  If Lox.HadError Then Quit(65)
		  If Lox.HadRuntimeError Then Quit(70)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunPrompt()
		  Dim multiLine As Boolean
		  Dim source As String
		  
		  While True
		    If Not multiLine Then StdOut.Write "> "
		    
		    #if TargetWin32
		      Dim line As String= Input.DefineEncoding(Encodings.DOSLatin1)._
		      ConvertEncoding(Encodings.UTF8)
		    #else
		      Dim line As String= Input
		    #endif
		    If line.Len= 0 Then Continue
		    
		    Select Case line
		    Case ".quit", ".q"
		      Exit
		    Case ".run", ".r"
		      run source
		      Lox.HadError= False
		    Case ".version", ".ver"
		      PrintText Lox.Version
		    Case ".multi"
		      multiLine= True
		    Case ".reset"
		      multiLine= False
		      Lox.Interpreter.Reset
		    Case ".help"
		      PrintText kHelp
		    Case ".source"
		      PrintText source
		    Case ".clear"
		      source= ""
		    Case Else
		      Dim cmd As String= line.Left(5)
		      If cmd= ".save" Then
		        SaveFile line.Mid(6).Trim, source
		      ElseIf cmd= ".load" Then
		        source= LoadFile(line.Mid(6).Trim)
		      ElseIf multiLine Then
		        source= source+ line+ EndOfLine
		      Else
		        run line
		        Lox.HadError= False
		      End If
		    End Select
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SaveFile(path As String, source As String)
		  If path.Len= 0 Then Return
		  
		  Try
		    #pragma BreakOnExceptions Off
		    Dim tt As TextOutputStream= TextOutputStream.Create(GetFolderItem(path))
		    tt.Write source
		    tt.Close
		    #pragma BreakOnExceptions Default
		  Catch exc As IOException
		    PrintText "Error ("+ Str(exc.ErrorNumber)+ ") saving "+ path
		  End Try
		End Sub
	#tag EndMethod


	#tag Constant, Name = kHelp, Type = String, Dynamic = False, Default = \"Commands and special keys:\r\r  .multi\tenable multi-line\r\r  .run\t\trun multi-line buffer (or .r)\r\r  .reset\tREPL to default\r\r  .source\tshows multi-line buffer\r\r  .clear\tclear multi-line buffer\r\r  .load\t\tload file to buffer >.load file/to/load.lox\r\r  .save\t\tsave buffer to file >.save file/to/save.lox\r\r  .help\t\tthis info\r\r  .ver\t\tshows core version (or .version)\r\r  .quit\t\tquit (or .q)\r", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
