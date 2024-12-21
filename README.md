Welcome to my Windows Patch Management Script. This was written as a project first to automate the CVE-2024-380229 
remedation patch. Then rememebered I wanted something like this before and PSWindowsUpdate is awesome.
                                                                                                                        
The purpose of this script is to give the administrator the option to either install just the patch for CVE-2024-380229   
(KB5044288) or go a step further and allow the patching of any available patch that has not already been installed.                   
                                                                                                                        
Key functions:                                                                                                           
-Preset patch or custom choice
-local or remote options
-Pre-check if patch is already installed or applicable as well as if available to install

Requirements:
-Must run as Admin
-Must have PSWindowsUpdate modules installed (Option to install available in script menu for local install only)
-Must have online connection to query the Microsoft Catalog

Version History:
1.0 - Initial script release

Created by 0ber1n
