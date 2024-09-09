#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  If args.Ubound= 0 Then
		    PrintWelcome
		    RunPrompt
		  ElseIf args.Ubound= 1 Then
		    RunFile args(1)
		  Else
		    Print "Usage: "+ ExecutableFile.DisplayName+ " [script]"
		    Quit 64
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
		Private Sub PrintWelcome()
		  Dim msg As String= ExecutableFile.DisplayName+ " "+ _
		  Str(MajorVersion)+ "."+ Str(MinorVersion)+ ".240909"+ _
		  " (fd03b11) type .help for more information"
		  
		  Print msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Run(source As String)
		  Dim scanner As New Lox.Scanner(source)
		  Dim tokens() As Lox.Token= scanner.Scan
		  If scanner.HadError Then
		    HadError= True
		    Return
		  End If
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim syntax As Variant= parser.ParseREPL
		  If parser.HadError Then
		    HadError= True
		    Return
		  End If
		  
		  If syntax.isArray Then
		    Dim statements() As Lox.Ast.Stmt= syntax
		    
		    Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		    resolver.Resolve(statements)
		    If resolver.HadError Then
		      HadError= True
		      Return
		    End If
		    
		    Lox.Interpreter.Interpret(statements)
		    If Lox.Interpreter.HadRuntimeError Then HadRuntimeError= True
		  Else
		    Dim expr As Lox.Ast.Expr= Lox.Ast.Expr(syntax)
		    Dim result As Variant= Lox.Interpreter.Interpret(expr)
		    If result.Type= 8 Then Lox.PrintOut.Write "= "+ result+ EndOfLine
		  End If
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
		    PrintText "Error ("+ Str(exc.ErrorNumber)+ ") loading "+ path
		  End Try
		  
		  If HadError Then Quit(65)
		  If HadRuntimeError Then Quit(70)
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
		    
		    Select Case line.Trim
		    Case ".quit", ".q"
		      Exit
		    Case ".run", ".r"
		      run source
		    Case ".version", ".ver"
		      PrintText Lox.Version
		    Case ".multi"
		      multiLine= True
		    Case ".reset"
		      multiLine= False
		      Lox.Interpreter.Reset
		    Case ".help"
		      PrintText kHelp
		    Case ".buffer"
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
		      Else // line:
		        run line
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


	#tag Property, Flags = &h21
		Private HadError As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private HadRuntimeError As Boolean
	#tag EndProperty


	#tag Constant, Name = kHelp, Type = String, Dynamic = False, Default = \"Lox language implementation in Xojo (https://github.com/lbmonsalve/Xojo-Lox)\rTaken from the (http://craftinginterpreters.com/) Book.\r\rCommands:\r\r  .multi\tenable multi-line\r  .run\t\trun multi-line buffer (or .r)\r  .reset\tREPL to default\r  .buffer\tshows multi-line buffer\r  .clear\tclear multi-line buffer\r  .load\t\tload file to buffer >.load file/to/load.lox\r  .save\t\tsave buffer to file >.save file/to/save.lox\r  .help\t\tthis info\r  .ver\t\tshows core language version (or .version)\r  .quit\t\tquit (or .q)\r\rLICENCE and COPYRIGHT on github site.\t\r", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
