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
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep Examples
					AppliesTo = 0
					Destination = 0
					Subdirectory = 
					FolderItem = Li4ALi4ARXhhbXBsZXMAdGVzdC5sb3g=
				End
			End
#tag EndBuildAutomation
