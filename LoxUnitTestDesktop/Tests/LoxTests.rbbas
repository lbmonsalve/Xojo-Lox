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
		Sub ArraysTest()
		  DoRun kArraysSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BitwiseTest()
		  DoRun kBitwiseSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BreakTest()
		  DoRun kBreakSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompoundAssignmentOperatorsTest()
		  DoRun kCompoundSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ContinueTest()
		  DoRun kContinueSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DateTimeTest()
		  DoRun kDatetimeSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DoRun(snnipet As String)
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
		    Assert.AreEqual expect, actual, "AreEqual expect, actual. "+ Str(actual.Ubound+ 1)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ElvisTest()
		  // https://github.com/sravand123/TinkerScript.git
		  
		  DoRun kElvisSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExtendIdNamesTest()
		  // emoji friendly!
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

	#tag Method, Flags = &h0
		Sub FileTest()
		  DoRun kFileSnnipet
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

	#tag Method, Flags = &h0
		Sub FunctionsTest()
		  DoRun kFunctionsSnnipet
		End Sub
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
		Sub HashMapsTest()
		  DoRun kHashMapSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IfOrElseTest()
		  DoRun kIfOrElseSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ImportTest()
		  DoRun kImportSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InterpreterTest()
		  Dim folders() As String= FindFolders
		  
		  For Each folder As String In folders
		    // skip folders:
		    If folder= "benchmark" Then Continue
		    If folder= "expressions" Then Continue // other test
		    If folder= "scanning" Then Continue // other test
		    If folder= "limit" Then Continue
		    If folder= "import" Then Continue
		    
		    Dim files() As FolderItem= FindFiles(folder)
		    
		    For Each file As FolderItem In files
		      // skip files:
		      If file.DisplayName= "get_on_class.lox" Then Continue // Static?
		      If file.DisplayName= "set_on_class.lox" Then Continue // Static?
		      
		      BufferPrint= ""
		      BufferError= ""
		      Lox.Interpreter.Reset
		      
		      Assert.Message folder+ "/"+ file.DisplayName+ " :"
		      
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
		Sub LamdaTest()
		  // https://github.com/munificent/craftinginterpreters/blob/master/note/answers/chapter10_functions.md
		  
		  DoRun kLamdaSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MathTest()
		  DoRun kMathSnnipets
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ModuleTest()
		  // https://github.com/gkjpettet/roo
		  
		  DoRun kModuleSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PostfixExprTest()
		  DoRun kPostfixSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrefixedNumbersTest()
		  DoRun kPrefixedNumberSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RegExTest()
		  DoRun kRegExSnnipet
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
		Sub StaticMethodTest()
		  // https://github.com/munificent/craftinginterpreters/blob/master/note/answers/chapter12_classes.md
		  
		  DoRun kStaticMethodsSnnipet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StringInterpolationTest()
		  DoRun kStringInterpolationSnnipet
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
		  
		  snnipet= "var c=a<b?1:2; print c;"
		  
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

	#tag Method, Flags = &h0
		Sub TextTest()
		  DoRun kTextSnnipet
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BufferError As String
	#tag EndProperty

	#tag Property, Flags = &h0
		BufferPrint As String
	#tag EndProperty


	#tag Constant, Name = kArraysSnnipet, Type = String, Dynamic = False, Default = \"var a\x3D[1\x2C2\x2C3];\rprint a.length; // expect: 3.0\rprint a.empty; // expect: false\rprint a[1]; // expect: 2.0\ra[0]\x3D4;\rprint a[0]; // expect: 4.0\r\rvar b\x3D[];\rprint b.length; // expect: 0.0\r\rvar foo\x3D [\"a\"\x2C \"b\"\x2C \"c\"];\rprint foo[2]; // // expect: c\r\rvar foo \x3D [1\x2C 1 + 1];\rprint foo; // expect: <class Array>\rprint foo[1]; // expect: 2.0\r\rfun add(a\x2Cb) { return a+ b; }\rprint foo[add(0\x2C 1)]; // expect: 2.0\r\r// pop\rvar c\x3D[4\x2C5\x2C6];\rvar elem\x3D c.pop();\rprint elem; // expect: 6.0\rprint c.length; // expect: 2.0\r\r// push\rvar b\x3D a.push(4\x2C5);\rprint a.length; // expect: 3.0\rprint b.length; // expect: 5.0\r\r\rvar a\x3D[\"a\"\x2C \"b\"\x2C \"c\"\x2C \"d\"\x2C 1];\ra.each(fun (e) {\r  print \"<\"+ e+ \">\";\r});\r\r// expect: <a>\r// expect: <b>\r// expect: <c>\r// expect: <d>\r// expect: <1.0>\r\r\rvar a\x3D[\"a\"\x2C \"b\"\x2C \"c\"\x2C \"d\"];\rvar find\x3D a.indexOf(\"c\");\rprint find; // expect: 2.0\r\r\rfun exclaim(e) { return e+ \"!\";}\rfun echo(e) { print e;}\r\rvar a\x3D[\"a\"\x2C \"b\"\x2C \"c\"\x2C \"d\"];\rvar b\x3D a.map(exclaim);\rprint b.length;\rb.each(echo);\r\r// expect: 4.0\r// expect: a!\r// expect: b!\r// expect: c!\r// expect: d!\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kBitwiseSnnipet, Type = String, Dynamic = False, Default = \"print 7 & 5;\rprint 7 | 5;\rprint 7 << 2;\rprint 40 >> 2;\r\r // expect: 5.0\r // expect: 7.0\r // expect: 28.0\r // expect: 10.0\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kBreakSnnipet, Type = String, Dynamic = False, Default = \"var bb\x3D0;\rwhile (true) {\r  if (bb\x3D10) break;\r  bb++;\r}\rprint bb; // expect: 10.0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCompoundSnnipet, Type = String, Dynamic = False, Default = \"var a\x3D5;\ra+\x3D5;\rprint a; // expect: 10.0\ra-\x3D3;\rprint a; // expect: 7.0\ra*\x3D5;\rprint a; // expect: 35.0\ra/\x3D2;\rprint a; // expect: 17.5", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kContinueSnnipet, Type = String, Dynamic = False, Default = \"var a \x3D 0;\rwhile (a < 10) {\r  a \x3D a + 1;\r  if (a\x3D\x3D 6) continue;\r  print a;\r}\r\r// expect: 1.0\r// expect: 2.0\r// expect: 3.0\r// expect: 4.0\r// expect: 5.0\r// expect: 7.0\r// expect: 8.0\r// expect: 9.0\r// expect: 10.0\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDatetimeSnnipet, Type = String, Dynamic = False, Default = \"var d\x3D DateTime();\r\rd\x3D DateTime(2000\x2C 1\x2C 1);\rprint d.year;\rprint d.month;\rprint d.day;\rprint d.SQLDatetime;\r\r// expect: 2000.0\r// expect: 1.0\r// expect: 1.0\r// expect: 2000-01-01 00:00:00", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kElvisSnnipet, Type = String, Dynamic = False, Default = \"var elvis \x3D true \?: false;\rprint elvis; // expect: true\rvar elvis2 \x3D false \?: true;\rprint elvis2; // expect: true\relvis\x3D false\?:false\?:true;\rprint elvis; // expect: true\r\rprint false\?.true; // expect: true\rprint nil\?.true; // expect: null\rprint true\?.nil\?.false\?.true; // expect: null\r\rprint (true\?.nil\?.false\?.true)\?:\"default\"; // expect: default\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExtendIdSnnipet, Type = String, Dynamic = False, Default = \"var a\xC3\xB1o\x3D2024; print a\xC3\xB1o; // expect: 2024.0\rvar \xCE\xA3\x3D \"sigma\"; print \xCE\xA3; // expect: sigma\rvar $emoji$\x3D \"smileyface\";\rprint $emoji$; // expect: smileyface", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kFileSnnipet, Type = String, Dynamic = False, Default = \"var f1\x3D File(\"test1.txt\");\rf1.write(\"hello\");\rprint f1.length;\r\rvar txt\x3D f1.read();\r\rvar f2\x3D File(\"test2.txt\");\rf2.write(txt+ \" world\");\rprint f2.length;\r\r// expect: 5.0\r// expect: 11.0\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kFunctionsSnnipet, Type = String, Dynamic = False, Default = \"fun count(n) {\r  if (n > 1) count(n - 1);\r  print n;\r}\rcount(3);\r// expect: 1.0\r// expect: 2.0\r// expect: 3.0\r\r\rfun add(a\x2C b\x2C c) {\r  print a + b + c;\r}\radd(1\x2C 2\x2C 3); // expect: 6.0\r\r\rfun add(a\x2C b) {\r  print a + b;\r}\rprint add; // expect: <fn add>\r\r\rfun sayHi(first\x2C last) {\r  print \"Hi\x2C \" + first + \" \" + last + \"!\";\r}\rsayHi(\"Dear\"\x2C \"Reader\"); // expect: Hi\x2C Dear Reader!\r\r\rfun procedure() {\r  print \"don\'t return anything\"; // expect: don\'t return anything\r}\rvar result \x3D procedure();\rprint result; // expect: null\r\rfun makeCounter() {\r  var i \x3D 0;\r  fun count() {\r    i \x3D i + 1;\r    print i;\r  }\r\r  return count;\r}\r\rvar counter \x3D makeCounter();\rcounter(); // expect: 1.0\rcounter(); // expect: 2.0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kHashMapSnnipet, Type = String, Dynamic = False, Default = \"var hm\x3D #{\"a\"\x3D>1\x2C\"b\"\x3D>2\x2C \"c\"\x3D>100};\rprint hm#{\"b\"}; // expect: 2.0\r\rhm#{\"a\"}\x3D 3;\rprint hm#{\"a\"}; // expect: 3.0\r\rvar a\x3D hm.delete(\"a\");\r\rprint a; // expect: 3.0\rprint hm.length; // expect: 2.0\r\rprint hm.value(\"b\"); // expect: 2.0\rprint hm.value(\"c\"); // expect: 100.0\rprint hm.value(\"d\"); // expect: null\r\rhm.put(1\x2C 200);\r\rvar one\x3D hm.value(1);\rprint one; // expect: 200.0\r\rfun foo(k\x2Cv) { print k; print v; }\rhm.each(foo);\r\r// expect: c\r// expect: 100.0\r// expect: b\r// expect: 2.0\r// expect: 1.0\r// expect: 200.0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kIfOrElseSnnipet, Type = String, Dynamic = False, Default = \"if (false) {print \"if\";}\r  or (true) {print \"or\";} // expect: or\r  else {print \"else\";} \r\rif (false) {print \"if\";}\r or (false) {print \"or\";}\r  else {print \"else\";} // expect: else", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kImportSnnipet, Type = String, Dynamic = False, Default = \"import \"a\";\r\r// expect: a.lox\r// expect: b.lox\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLamdaSnnipet, Type = String, Dynamic = False, Default = \"// https://github.com/munificent/craftinginterpreters/blob/master/note/answers/chapter10_functions.md\r\rfun whichFn(fn) {\r  fn(\"world\");\r}\r\rwhichFn(fun (a) {\r print \"hello \"+ a; // expect: hello world\r});\r\rfun named(a) { print a; }\rwhichFn(named);\r\r// expect: world\r\rfun whichFn(fn) {\r  for (var i \x3D 1; i <\x3D 3; i \x3D i + 1) {\r    fn(i);\r  }\r}\r\rwhichFn(fun (a) { print a; });\r\r// expect: 1.0\r// expect: 2.0\r// expect: 3.0\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMathSnnipets, Type = String, Dynamic = False, Default = \"print Math.abs(23.9); // expect: 23.9\r\rprint Math.abs(-23.9); // expect: 23.9\r\rprint Math.acos(0.5); // expect: 60.0\r\rprint Math.asin(0.5); // expect: 30.0\r\rprint Math.atan(1); // expect: 45.0\r\rprint Math.atan2(1\x2C0); // expect: 90.0\r\rprint Math.bin(15); // expect: 1111\rprint Math.bin(75); // expect: 1001011\rprint Math.bin(0xf); // expect: 1111\r\rprint Math.cdbl(\"12345\"); // expect: 12345.0\r//print Math.cdbl(\"12345.6789\"); // depends op system\r\rprint Math.ceil(1.234*100)/100; // expect: 1.24\r\rprint Math.cos(45); // expect: 0.707107\r\rprint Math.exp(10); // expect: 22026.465795\r\rprint Math.floor(1.234); // expect: 1.0\r\rprint Math.hex(5); // expect: 5\rprint Math.hex(75); // expect: 4B\rprint Math.hex(256); // expect: 100\r\rprint Math.log(10); // expect: 2.302585\r\rprint Math.max(3.01\x2C 4.05); // expect: 4.05\rprint Math.min(3.01\x2C 4.05); // expect: 3.01\r\rprint Math.oct(5); // expect: 5\rprint Math.oct(75); // expect: 113\rprint Math.oct(256); // expect: 400\r\rprint Math.pow(4\x2C7); // expect: 16384.0\r\rprint Math.round(1.499); // expect: 1.0\rprint Math.round(1.5); // expect: 2.0\r\rprint Math.sin(30); // expect: 0.5\r\rprint Math.sqrt(16); // expect: 4.0\r\rprint Math.tan(45); // expect: 1.0\r\rprint Math.val(\"12345\"); // expect: 12345.0\rprint Math.val(\"12345car45\"); // expect: 12345.0\rprint Math.val(\"123.45\"); // expect: 123.45\rprint Math.val(\"123 45\"); // expect: 123.0\rprint Math.val(\"car\"); // expect: 0.0\r\rprint Math.str(0); // expect: 0\rprint Math.str(12345); // expect: 12345\rprint Math.str(12345.67); // expect: 12345.67\rprint Math.str(12345.67\x2C \"###\x2C###.##\"); // expect: 12\x2C345.67\rprint Math.str(-12345.67\x2C \"###\x2C###.##\"); // expect: 12\x2C345.67\rprint Math.str(-12345.67\x2C \"-###\x2C###.##\"); // expect: -12\x2C345.67", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kModuleSnnipet, Type = String, Dynamic = False, Default = \"module M {\r  class C {\r    parse(cc) {print cc;}\r  }\r  fun F() {print \"hello\";}\r  fun hello() {return \"hello!\";}\r}\rM.hello2\x3D \"hello2\";\r\rM.F();\rvar a\x3D M.C();\ra.parse(\"b\");\r\rvar hello\x3D M.hello();\rprint hello;\rprint M.hello2;\r\r// expect: hello\r// expect: b\r// expect: hello!\r// expect: hello2\r\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPostfixSnnipet, Type = String, Dynamic = False, Default = \"var a\x3D5;\rvar b\x3D a++;\rprint a; // expect: 6.0\rprint b; // expect: 5.0\r{\r  var a\x3D10;\r  var b\x3D a++;\r  print a; // expect: 11.0\r  print b; // expect: 10.0\r}\r\rvar c\x3D b--;\rprint c; // expect: 5.0\rprint b; // expect: 4.0\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPrefixedNumberSnnipet, Type = String, Dynamic = False, Default = \"var h\x3D0x2324; \rvar o\x3D0o1056; \rvar b\x3D0b1110;\rprint h; // expect: 8996.0\rprint o; // expect: 558.0\rprint b; // expect: 14.0\r\rh\x3D0x1a2b3c4d5e6f;\rprint h; // expect: 28772997619311.0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kRegExSnnipet, Type = String, Dynamic = False, Default = \"var r\x3D RegEx(\"\\d+\");\rprint r.caseSensitive; // expect: false\rprint r.greedy; // expect: true\rprint r.match(\"10\"); // expect: 10\rprint r.match(\"rr\"); // expect: null", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kStaticMethodsSnnipet, Type = String, Dynamic = False, Default = \"class Math {\r  class square(n) {\r    return n * n;\r  }\r}\r\rprint Math.square(3); // expect: 9.0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kStringInterpolationSnnipet, Type = String, Dynamic = False, Default = \"var name\x3D\"luis\";\rprint \"welcome ${name}!\";\r\r// expect: welcome luis!\r\rprint \"one plus two times tree: ${1+2*3}.\";\r\r// expect: one plus two times tree: 7.0.", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kTextSnnipet, Type = String, Dynamic = False, Default = \"print Text.asc(\"@\"); // expect: 64.0\r\rprint Text.chr(9); // expect: \t\r\rprint Text.decodeBase64(\"dGVzdA\x3D\x3D\"); // expect: test\r\rprint Text.decodeHex(\"61\"); // expect: a\r\rprint Text.encodeBase64(\"test\"); // expect: dGVzdA\x3D\x3D\r\rprint Text.encodeHex(\"test\"); // expect: 74657374\r\rprint Text.inStr(\"hello world\"\x2C \"world\"); // expect: 7.0\r\rprint Text.left(\"hello world\"\x2C 5); // expect: hello\r\rprint Text.len(\"hello world\"); // expect: 11.0\r\rprint Text.lower(\"HELLO WORLD\"); // expect: hello world\r\rprint Text.mid(\"hello world\"\x2C 7); // expect: world\rprint Text.mid(\"hello world\"\x2C 7\x2C 1); // expect: w\r\rprint Text.nthField(\"this*is*the*end\"\x2C \"*\"\x2C 3); // expect: the\r\rprint Text.replace(\"The quick fox\"\x2C \"quick\"\x2C \"slow\"); // expect: The slow fox\r\rprint Text.replaceAll(\"xyxyxy\"\x2C \"x\"\x2C \"z\"); // expect: zyzyzy\r\rprint Text.right(\"hello world\"\x2C 5); // expect: world\r\rprint Text.titleCase(\"tHe Quick fOX\"); // expect: The Quick Fox\r\rprint Text.trim(\" tHe Quick fOX \"); // expect: The Quick Fox\r\rprint Text.upper(\"tHe Quick fOX\"); // expect: THE QUICK FOX", Scope = Private
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
