#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Windows
				Begin IDEScriptBuildStep UpdateGitCommitHash , AppliesTo = 0
					Dim value As String
					value= DoShellCommand("%PROJECT_PATH%\git_hash.bat")
					value= Left(value, 7)
					
					Dim version As String
					version = PropertyValue("App.MajorVersion") + "." + _
					PropertyValue("App.MinorVersion") + "." + _
					PropertyValue("App.BugVersion") + _
					Format(Val(PropertyValue("App.NonReleaseVersion")), "0#") + _
					" ("+ value+ ")"
					
					If version <> PropertyValue("App.ShortVersion") Then
					PropertyValue("App.ShortVersion") = version
					End If
					
				End
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation
