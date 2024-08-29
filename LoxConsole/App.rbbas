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
		Private Sub Run(source As String)
		  Dim scanner As New Lox.Scanner(source)
		  Dim tokens() As Lox.Lexical.Token= scanner.Scan
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  
		  'If Lox.HadError Then Return // Stop if there was a syntax error.
		  
		  'Dim printer As New Lox.Ast.AstPrinter
		  'Print printer.Print(expr)
		  
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
		    System.DebugLog "IOException: "+ path
		  End Try
		  
		  If Lox.HadError Then Quit(65)
		  If Lox.HadRuntimeError Then Quit(70)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunPrompt()
		  While True
		    StdOut.Write "> "
		    Dim line As String= Input // TODO: encodings?
		    run line
		    Lox.HadError= False
		  Wend
		End Sub
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
