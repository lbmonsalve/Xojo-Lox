#tag Module
Protected Module Lox
	#tag Method, Flags = &h0
		Function AbsoluteNativePathLox(Extends obj As FolderItem) As String
		  #if RBVersion< 2013
		    Return obj.AbsolutePath
		  #else
		    Return obj.NativePath
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddSearchPath(path As String)
		  Dim folder As FolderItem
		  
		  Try
		    #pragma BreakOnExceptions Off
		    folder= New FolderItem(path)
		  Catch
		    Return
		  End Try
		  
		  If Not folder.Directory Then Return
		  
		  ChkSearchPaths
		  
		  mSearchPaths.Append folder
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AreEqual(expected As Double, actual As Double, tolerance As Double = 0.000001) As Boolean
		  Dim diff As Double= Abs(expected- actual)
		  
		  If diff<= (Abs(tolerance) + 0.00000001) Then
		    Return True
		  Else
		    Return False
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AssertAreNumbers(where As Token, ParamArray operands As Variant)
		  // Asserts that the passed operands are Numbers. If any aren't, raise an error.
		  
		  For Each operand As Variant In operands
		    If Not operand.IsNumberLox Then
		      Raise New RuntimeError(where, "Expected a number operand.")
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ChkSearchPaths()
		  If mSearchPaths.Ubound= -1 Then
		    mSearchPaths.Append app.ExecutableFile.Parent
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count(Extends obj() As Token) As Integer
		  Return obj.Ubound+ 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CountLox(Extends obj() As Variant) As Integer
		  Return obj.Ubound+ 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DbgLog(msg As String)
		  System.DebugLog msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EnvVar(name As String) As String
		  Return System.EnvironmentVariable(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Error(line As Integer, message As String)
		  Report line, "", message
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Error(token As Token, message As String)
		  If token.TypeToken= TokenType.EOF Then
		    Report token.Line, " at end", message
		  Else
		    Report token.Line, " at '"+ token.Lexeme+ "'", message
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Error(token As Token, message As String) As ParseError
		  Error token, message
		  
		  Return New ParseError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindFile(name As String) As FolderItem
		  ChkSearchPaths
		  
		  If name.InStr(".")= 0 Then name= name+ ".lox"
		  
		  Dim file As FolderItem
		  Try
		    #pragma BreakOnExceptions Off
		    file= New FolderItem(name) // full path
		  Catch
		    Return file
		  End Try
		  
		  If Not (file Is Nil) And file.Exists Then Return file
		  
		  For Each path As FolderItem In mSearchPaths // search paths
		    file= path.Child(name)
		    If Not (file Is Nil) And file.Exists Then Return file
		  Next
		  
		  Return file
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetOSVersion(AsNumber As Boolean = False) As String
		  If AsNumber Then
		    If mOSVersionNumber<> "" Then Return mOSVersionNumber
		  Else
		    If mOSVersion<> "" Then Return mOSVersion
		  End
		  
		  Dim os As String
		  Dim OS_CODE As Integer
		  
		  #If TargetMacOS
		    #if RBVersion< 2012.21
		      Dim noerror As Boolean
		      Dim result As Integer
		      Dim sver As String
		      Dim sversion As String
		      
		      noerror=System.Gestalt("sysv",result)
		      If noerror Then
		        sver=Hex(result)
		        sversion=sver.Left(2) + "." + sver.Mid(3,1) + "." + sver.Right(1)
		        
		        If AsNumber Then
		          mOSVersionNumber= sver.Mid(3,1)
		          Return mOSVersionNumber
		        End
		        
		        OS_CODE=Val(sver.Mid(3,1))
		        
		        Select Case OS_CODE
		        Case 0
		          os="Cheetah"
		        Case 1
		          os="Puma"
		        Case 2
		          os="Jaguar"
		        Case 3
		          os="Panther"
		        Case 4
		          os="Tiger"
		        Case 5
		          os="Leopard"
		        Case 6
		          os="Snow Leopard"
		        Case 7
		          os="Lion"
		        Case 8
		          os="Mountain Lion"
		        case 9
		          os="Mavericks"
		        case 10
		          os="Yosemite"
		        case 11
		          os="El Capitan"
		        case 12
		          os="Sierra"
		        Case 13
		          os="High Sierra"
		        Case Else
		          os="Unknown"
		        End Select
		        mOSVersion= "MacOS "+ os +" "+ sversion
		        Return mOSVersion
		      Else
		        Return "Unknown"
		      End If
		    #else
		      Dim major, minor, bug As Integer
		      
		      If System.Gestalt("sys1", major) Then
		        If System.Gestalt("sys2", minor) Then
		          If System.Gestalt("sys3", bug) Then
		            'MsgBox "Max OS X v" + Str(major) + "." + Str(minor) + "." + Str(bug)
		          End If
		        End If
		      End If
		      
		      If AsNumber Then
		        mOSVersionNumber= Str(minor)
		        Return mOSVersionNumber
		      End
		      
		      OS_CODE= minor
		      
		      Select Case OS_CODE
		      Case 0
		        os="Cheetah"
		      Case 1
		        os="Puma"
		      Case 2
		        os="Jaguar"
		      Case 3
		        os="Panther"
		      Case 4
		        os="Tiger"
		      Case 5
		        os="Leopard"
		      Case 6
		        os="Snow Leopard"
		      Case 7
		        os="Lion"
		      Case 8
		        os="Mountain Lion"
		      case 9
		        os="Mavericks"
		      case 10
		        os="Yosemite"
		      case 11
		        os="El Capitan"
		      case 12
		        os="Sierra"
		      Case 13
		        os="High Sierra"
		      Case Else
		        os="Unknown"
		      End Select
		      
		      mOSVersion= "MacOS "+ os +" "+ Str(major)+ "."+ Str(minor)+ "."+ Str(bug)
		      
		      Return mOSVersion
		    #endif
		  #ElseIf TargetWin32
		    os = "Windows"
		    
		    //try to be more specific of windows version
		    Soft Declare Sub GetVersionExA Lib "Kernel32" ( info As Ptr )
		    Soft Declare Sub GetVersionExW Lib "Kernel32" ( info As Ptr )
		    
		    Dim info As MemoryBlock
		    
		    If System.IsFunctionAvailable( "GetVersionExW", "Kernel32" ) Then
		      info =  New MemoryBlock( 20 + (2 * 128) )
		      info.Long( 0 ) = info.Size
		      GetVersionExW( info )
		    Else
		      info =  New MemoryBlock( 148 )
		      info.Long( 0 ) = info.Size
		      GetVersionExA( info )
		    End If
		    
		    Dim str As String
		    OS_CODE= info.Long(4)*100+info.long(8)
		    
		    If AsNumber Then
		      If OS_CODE= 602 Then
		        Dim s As New Shell
		        s.Execute("ver")
		        Dim res As String = s.Result
		        
		        Dim rg As New RegEx
		        rg.SearchPattern= "\d+\.*"
		        Dim match As RegExMatch= rg.Search(res)
		        
		        While Not (match Is Nil)
		          str= str+ match.SubExpressionString(0)
		          
		          match= rg.Search
		        Wend
		        mOSVersionNumber= str
		      Else
		        mOSVersionNumber= Str(OS_CODE)
		      End If
		      
		      Return mOSVersionNumber
		    End
		    
		    Select Case OS_CODE
		    Case 400
		      os = "Windows 95/NT 4.0"
		    Case 410
		      os = "Windows 98"
		    Case 490
		      os = "Windows Me"
		    Case 300 To 399
		      os = "Windows NT 3.51"
		      OS_CODE=30
		    Case 500
		      os = "Windows 2000"
		    Case 501
		      os = "Windows XP"
		    Case 502
		      os = "Windows Server 2003"
		    Case 600
		      os = "Windows Vista"
		    Case 601
		      os = "Windows 7"
		    Case 602
		      Dim s As New Shell
		      s.Execute("ver")
		      Dim res As String = s.Result
		      
		      If Val(Mid(res, 30, 2)) = 10 Then
		        os = "Windows 10/11"
		      Else
		        os = "Windows 8/8.1"
		      End If
		      
		      Dim rg As New RegEx
		      rg.SearchPattern= "\d+\.*"
		      Dim match As RegExMatch= rg.Search(res)
		      
		      While Not (match Is Nil)
		        str= str+ match.SubExpressionString(0)
		        
		        match= rg.Search
		      Wend
		      str=  " "+ str
		      
		    End Select
		    
		    If str= "" Then
		      str= " Build " + str(info.Long(12))
		      
		      If System.IsFunctionAvailable( "GetVersionExW", "Kernel32" ) Then
		        str= str+ " "+ Trim( info.WString( 20 ) )
		      Else
		        str= str+ " "+ Trim( info.CString( 20 ) )
		      End If
		    End If
		    
		    mOSVersion= os+ str
		    Return mOSVersion
		  #EndIf
		  
		  Dim s As New Shell
		  s.Execute("uname -a")
		  mOSVersion= s.Result
		  
		  s.Execute("uname -r")
		  mOSVersionNumber= s.Result
		  
		  If AsNumber Then Return mOSVersionNumber Else Return mOSVersion
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IIf(stmt As Boolean, ifTrue As TokenType, ifFalse As TokenType) As TokenType
		  If stmt Then Return ifTrue Else Return ifFalse
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsBooleanLox(Extends vart As Variant) As Boolean
		  If vart.Type= 11 Then Return True
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsCallableLox(Extends obj As Variant) As Boolean
		  If obj IsA lox.Inter.ICallable Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsNumberLox(Extends vart As Variant) As Boolean
		  Select Case vart.Type
		  Case 2, 3, 4, 5, 6
		    Return True
		  Case Else
		    Return False
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsStringLox(Extends vart As Variant) As Boolean
		  If vart.Type= 8 Then Return True
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsUIntegerLox(Extends vart As Variant) As Boolean
		  Select Case vart.Type
		  Case 2, 3, 4, 5, 6
		    If vart.DoubleValue>= 0 And vart.DoubleValue= vart.UInt64Value Then
		      Return True
		    Else
		      Return False
		    End If
		  Case Else
		    Return False
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Report(line As Integer, where As String, message As String)
		  Dim msg As String= "[line "+ Str(line)+ "] Error"+ where+ ": "+ message
		  
		  // TODO: add logging system
		  If ErrorOut Is Nil Then
		    System.DebugLog msg
		  Else
		    ErrorOut.Write msg+ EndOfLine
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ResolveFile(file As FolderItem, tok As Token, interp As Lox.Inter.Interpreter) As Lox.Ast.Stmt()
		  Dim ti As TextInputStream= TextInputStream.Open(file)
		  
		  Dim scanner As New Lox.Scanner(ti.ReadAll)
		  Dim tokens() As Lox.Token= scanner.Scan
		  If scanner.HadError Then
		    interp.HadRuntimeError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "scanner.HadError.")
		  End If
		  
		  Dim parser As New Lox.Parser(tokens)
		  Dim statements() As Lox.Ast.Stmt= parser.Parse
		  If parser.HadError Then
		    interp.HadRuntimeError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "parser.HadError.")
		  End If
		  
		  Dim resolver As New Lox.Inter.Resolver(Lox.Interpreter)
		  resolver.Resolve(statements)
		  If resolver.HadError Then
		    interp.HadRuntimeError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "resolver.HadError.")
		  End If
		  
		  Return statements
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RuntimeError(error As RuntimeError)
		  Dim msg As String= error.Message+ EndOfLine+ "[line "+ _
		  Str(error.Token.Line)+ "]"
		  
		  // TODO: add logging system
		  If ErrorOut Is Nil Then
		    DbgLog msg
		  Else
		    ErrorOut.Write msg+ EndOfLine
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SubstringLox(Extends obj As String, startIndex As Integer, endIndex As Integer) As String
		  Return obj.Mid(startIndex, endIndex- startIndex)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(Extends obj As Lox.TokenType) As String
		  Select Case obj
		  Case TokenType.LEFT_PAREN
		    Return "LEFT_PAREN"
		  Case TokenType.RIGHT_PAREN
		    Return "RIGHT_PAREN"
		  Case TokenType.LEFT_BRACE
		    Return "LEFT_BRACE"
		  Case TokenType.RIGHT_BRACE
		    Return "RIGHT_BRACE"
		  Case TokenType.COMMA
		    Return "COMMA"
		  Case TokenType.DOT
		    Return "DOT"
		  Case TokenType.MINUS
		    Return "MINUS"
		  Case TokenType.PLUS
		    Return "PLUS"
		  Case TokenType.SEMICOLON
		    Return "SEMICOLON"
		  Case TokenType.SLASH
		    Return "SLASH"
		  Case TokenType.STAR
		    Return "STAR"
		  Case TokenType.BANG
		    Return "BANG"
		  Case TokenType.BANG_EQUAL
		    Return "BANG_EQUAL"
		  Case TokenType.EQUAL
		    Return "EQUAL"
		  Case TokenType.EQUAL_EQUAL
		    Return "EQUAL_EQUAL"
		  Case TokenType.GREATER
		    Return "GREATER"
		  Case TokenType.GREATER_EQUAL
		    Return "GREATER_EQUAL"
		  Case TokenType.LESS
		    Return "LESS"
		  Case TokenType.LESS_EQUAL
		    Return "LESS_EQUAL"
		  Case TokenType.IDENTIFIER
		    Return "IDENTIFIER"
		  Case TokenType.STRING_
		    Return "STRING"
		  Case TokenType.NUMBER
		    Return "NUMBER"
		  Case TokenType.AND_
		    Return "AND"
		  Case TokenType.CLASS_
		    Return "CLASS"
		  Case TokenType.ELSE_
		    Return "ELSE"
		  Case TokenType.FALSE_
		    Return "FALSE"
		  Case TokenType.FUN
		    Return "FUN"
		  Case TokenType.FOR_
		    Return "FOR"
		  Case TokenType.IF_
		    Return "IF"
		  Case TokenType.NIL_
		    Return "NIL"
		  Case TokenType.OR_
		    Return "OR"
		  Case TokenType.PRINT_
		    Return "PRINT"
		  Case TokenType.RETURN_
		    Return "RETURN"
		  Case TokenType.SUPER_
		    Return "SUPER"
		  Case TokenType.THIS
		    Return "THIS"
		  Case TokenType.TRUE_
		    Return "TRUE"
		  Case TokenType.VAR_
		    Return "VAR"
		  Case TokenType.WHILE_
		    Return "WHILE"
		  Case TokenType.EOF
		    Return "EOF"
		  Case TokenType.PLUS_PLUS
		    Return "PLUS_PLUS"
		  Case TokenType.MINUS_MINUS
		    Return "MINUS_MINUS"
		  Case TokenType.QUESTION
		    Return "QUESTION"
		  Case TokenType.COLON
		    Return "COLON"
		  Case TokenType.PLUS_EQUAL
		    Return "PLUS_EQUAL"
		  Case TokenType.MINUS_EQUAL
		    Return "MINUS_EQUAL"
		  Case TokenType.STAR_EQUAL
		    Return "STAR_EQUAL"
		  Case TokenType.SLASH_EQUAL
		    Return "SLASH_EQUAL"
		  Case TokenType.BREAK_
		    Return "BREAK"
		  Case TokenType.CONTINUE_
		    Return "CONTINUE"
		  Case TokenType.MODULE_
		    Return "MODULE"
		  Case TokenType.AMPERSAND
		    Return "AMPERSAND"
		  Case TokenType.PIPE
		    Return "PIPE"
		  Case TokenType.LESS_LESS
		    Return "LESS_LESS"
		  Case TokenType.GREATER_GREATER
		    Return "GREATER_GREATER"
		  Case TokenType.ELVIS
		    Return "ELVIS"
		  Case TokenType.ELVIS_DOT
		    Return "ELVIS_DOT"
		  Case TokenType.LEFT_BRACKET
		    Return "LEFT_BRACKET"
		  Case TokenType.RIGHT_BRACKET
		    Return "RIGHT_BRACKET"
		  Case TokenType.FAT_ARROW
		    Return "FAT_ARROW"
		  Case TokenType.HASHTAG_BRACE
		    Return "HASHTAG_BRACE"
		  Case TokenType.STRING_INTERPOLATION
		    Return "STRING_INTERPOLATION"
		  Case TokenType.IMPORT
		    Return "IMPORT"
		    
		  Case Else
		    Return "STRINGIFY->"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringLox(Extends obj As Variant) As String
		  Select Case obj.Type
		  Case 0
		    Return "nil"
		  Case 2, 3, 4, 5, 6
		    #if TargetConsole
		      #if RBVersion < 2014
		        Return Str(obj.DoubleValue) // realstudio bug
		      #else
		        Return Str(obj.DoubleValue, PrintFormatNumber)
		      #endif
		    #else
		      Return Str(obj.DoubleValue, PrintFormatNumber)
		    #endif
		  Case 7 // date
		    Return obj.DateValue.SQLDateTime
		  Case 8, 16
		    Return obj.StringValue
		  Case 11 // boolean
		    Return obj.StringValue.Lowercase
		  Case 9 // obj TODO: cache methods
		    Dim ti As Introspection.TypeInfo= Introspection.GetType(obj)
		    Dim methods() As Introspection.MethodInfo= ti.GetMethods
		    For i As Integer= methods.Ubound DownTo 0
		      Dim method As Introspection.MethodInfo= methods(i)
		      If method.ReturnType Is Nil Then Continue
		      Dim mathodParams() As Introspection.ParameterInfo= method.GetParameters
		      If method.Name.Lowercase= "tostring" And _
		        method.ReturnType.Name.Lowercase= "string" And _
		        mathodParams.Ubound= -1 Then
		        Dim params() As Variant
		        Return method.Invoke(obj, params)
		      End If
		    Next
		    'For Each method As Introspection.MethodInfo In methods
		    'Next
		    Return ti.FullName
		  Case Else
		    Return "other"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValChar(asc As UInt8) As UInt64
		  Select Case asc
		  Case 48
		    Return 0
		  Case 49
		    Return 1
		  Case 50
		    Return 2
		  Case 51
		    Return 3
		  Case 52
		    Return 4
		  Case 53
		    Return 5
		  Case 54
		    Return 6
		  Case 55
		    Return 7
		  Case 56
		    Return 8
		  Case 57
		    Return 9
		  Case 97
		    Return 10
		  Case 98
		    Return 11
		  Case 99
		    Return 12
		  Case 100
		    Return 13
		  Case 101
		    Return 14
		  Case 102
		    Return 15
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValHexLox(extends cad As String) As Double
		  Dim len As Integer= cad.Len
		  If len> 16 Then Return &hffffffffffffffff
		  
		  Dim num3 As UInt64= ValChar(cad.Mid(len, 1).Lowercase.Asc)
		  Dim num4 As UInt64= num3
		  Dim i As Integer= 1
		  
		  For j As Integer= len- 1 DownTo 1 // bigendian
		    num3= ValChar(cad.Mid(j, 1).Lowercase.Asc)
		    num4= num4 Or Bitwise.ShiftLeft(num3, i* 4)
		    i= i+ 1
		  Next
		  
		  Return CType(num4, Double)
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetConsole
			    If mErrorOut Is Nil Then mErrorOut= StdErr
			  #endif
			  
			  return mErrorOut
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mErrorOut = value
			End Set
		#tag EndSetter
		ErrorOut As Writeable
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mInterpreter Is Nil Then mInterpreter= New Lox.Inter.Interpreter
			  
			  return mInterpreter
			End Get
		#tag EndGetter
		Interpreter As Lox.Inter.Interpreter
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mErrorOut As Writeable
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInterpreter As Lox.Inter.Interpreter
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mOSVersion As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mOSVersionNumber As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPrintFormatNumber As String = "-###########0.0#####"
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPrintOut As Writeable
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSearchPaths() As FolderItem
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mPrintFormatNumber
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mPrintFormatNumber = value
			End Set
		#tag EndSetter
		PrintFormatNumber As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetConsole
			    If mPrintOut Is Nil Then mPrintOut= StdOut
			  #endif
			  
			  return mPrintOut
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mPrintOut = value
			End Set
		#tag EndSetter
		PrintOut As Writeable
	#tag EndComputedProperty


	#tag Constant, Name = Version, Type = String, Dynamic = False, Default = \"0.0.260910", Scope = Public
	#tag EndConstant


	#tag Enum, Name = TokenType, Type = Integer, Flags = &h1
		LEFT_PAREN
		  RIGHT_PAREN
		  LEFT_BRACE
		  RIGHT_BRACE
		  COMMA
		  DOT
		  MINUS
		  PLUS
		  SEMICOLON
		  SLASH
		  STAR
		  BANG
		  BANG_EQUAL
		  EQUAL
		  EQUAL_EQUAL
		  GREATER
		  GREATER_EQUAL
		  LESS
		  LESS_EQUAL
		  IDENTIFIER
		  STRING_
		  NUMBER
		  AND_
		  CLASS_
		  ELSE_
		  FALSE_
		  FUN
		  FOR_
		  IF_
		  NIL_
		  OR_
		  PRINT_
		  RETURN_
		  SUPER_
		  THIS
		  TRUE_
		  VAR_
		  WHILE_
		  EOF
		  PLUS_PLUS
		  MINUS_MINUS
		  QUESTION
		  COLON
		  PLUS_EQUAL
		  MINUS_EQUAL
		  STAR_EQUAL
		  SLASH_EQUAL
		  BREAK_
		  CONTINUE_
		  MODULE_
		  AMPERSAND
		  PIPE
		  LESS_LESS
		  GREATER_GREATER
		  ELVIS
		  ELVIS_DOT
		  LEFT_BRACKET
		  RIGHT_BRACKET
		  FAT_ARROW
		  HASHTAG_BRACE
		  STRING_INTERPOLATION
		IMPORT
	#tag EndEnum


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
			Name="PrintFormatNumber"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
End Module
#tag EndModule
