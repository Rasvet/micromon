#������� �������� ����������
.\makecert.exe -n "CN=PowerShell Local Certificate Root" -a sha1 -eku 1.3.6.1.5.5.7.3.3 -r -sv ps-mkucou-root.pvk ps-mkucou-root.cer -ss Root -sr localMachine

#������� ���������� �������� �� ������ ������ ���������
.\makecert.exe -pe -n "CN=PowerShell User" -ss MY -a sha1 -eku 1.3.6.1.5.5.7.3.3 -iv ps-mkucou-root.pvk -ic ps-mkucou-root.cer

#����������� ���������� ����
Set-AuthenticodeSignature c:\Scripts\remote-script.ps1 @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]

#����������� ��� ps1 ����� � ������� �������� � ������������
$cert = @(dir cert:\currentuser\my -codesigning)[0]
dir -Include *.ps1 -Recurse | %{Set-AuthenticodeSignature "$_" $cert}

# SIG # Begin signature block
# MIIO2wYJKoZIhvcNAQcCoIIOzDCCDsgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUy50NAf7uP33aoWRkF+C7kWwa
# SnqgggrWMIICOTCCAaagAwIBAgIQKGHI25grnKdHemZqVCYo6TAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNTEwMjMwOTIxMjhaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAxxDgcdAMBB2W
# +LSkInXuJeBmpQwBmylNHDAeLOOwJLs+bJeaN/MJTmueyHDTGd+8S9H54VCARRgX
# RcYSd/lRyHUGpEc6TI/IG9CZkqA1JFgyBM5an1dr3ZjFehcgfAsLdu0oGPZ/5UZ6
# cwGnHaDwdpZKRi0JKTu8/soRhAghi8cCAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwXQYDVR0BBFYwVIAQm5WQ3DvHZy8wpPr0wr3d+6EuMCwxKjAoBgNVBAMT
# IVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQksF9F+PhZ5ZKSe/5
# 9JOggTAJBgUrDgMCHQUAA4GBAE5f4P0paFhfOSZZMFFGDO9PW0E85ovraqtFREqf
# Rmi27EIV8LR9ScCXCAiNpzcEcT5MelgaWoanT60F2KkTzz0t0Eas+WXPx/AQdo1C
# Wcm7iu2hKwWFTukRc1912VEhND0HJ1XA5fbn2ZYxpC7CzJ79DxoL+0VIB79s8wjm
# GmJnMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0BAQUF
# ADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIGA1UE
# BxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhhd3Rl
# IENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcgQ0Ew
# HhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJVUzEd
# MBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFudGVj
# IFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5QWvsU
# wnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeCi2m0
# K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4ezPk
# eQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3+3R8
# J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujIfKVO
# SET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAdBgNV
# HQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIGCCsG
# AQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYBAf8C
# AQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1RoYXd0
# ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNVHQ8B
# Af8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0yMDQ4
# LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdfplKf
# Fo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y0DGm
# CFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhqIhKj
# URmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3DQEB
# BQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlv
# bjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBDQSAt
# IEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UEBhMC
# VVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytTeW1h
# bnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjANBgkq
# hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5OwmNut
# LA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0jkBP
# 7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfultth
# O0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqhd5Nb
# ZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeozC9Lx
# oxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQABo4IB
# VzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRwOi8v
# dHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90cy1h
# aWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAxoC+g
# LYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNybDAo
# BgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNVHQ4E
# FgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa1N19
# 7z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcHbxiy
# 3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73BaQ1
# bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDREfzd
# XHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IWyhOB
# bQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysue7nc
# IAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUxggNv
# MIIDawIBATBAMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNh
# dGUgUm9vdAIQKGHI25grnKdHemZqVCYo6TAJBgUrDgMCGgUAoHgwGAYKKwYBBAGC
# NwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUHdgdTRVx
# PY7ra/83cmvqIIDejlwwDQYJKoZIhvcNAQEBBQAEgYAqcULYqmpJMWkYKxGCOnTE
# 7jQeL2HMzB5RffDFWtRGGDgJZlyCoqaQ4RgLXnR3yEjbxmtR2ubSiMGqB97mgMEB
# t8dfNpoDJ2qRYJ25GOE7ATK/I5ptOwJ/1iNQpLQ2JHMV3mFWF4HB6oWty6GbOX2v
# Zsj0pekNpNZWdTHRqP0ClKGCAgswggIHBgkqhkiG9w0BCQYxggH4MIIB9AIBATBy
# MF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEw
# MC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBDQSAtIEcy
# AhAOz/Q4yP6/NW4E2GqYGxpQMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJ
# KoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNTEwMjQwMzU3MzVaMCMGCSqGSIb3
# DQEJBDEWBBSAKLzw/+gCDa4ulLyPIWLejPXwmDANBgkqhkiG9w0BAQEFAASCAQCK
# iWZzLOjUbjorHwtlPAQ6NDoJgrWT6r2+6KZnsBsxJk2d5cVg+xhUlO4AonRUOOPd
# seOAplG2QosQK5mhcLeIcgBNkDKyZKlVBguIFlJ11lDfEP2LZVE4N4uGCUTLY1nv
# 3JFGsuSh1gSSHliB9c5iwHf2wNbwyZeH9fVxX8x8s6A2dhHbOdU1rfj3bsxUv8Tp
# hBBWGI4JrI77PpE6oEzpB7r6Xdojj+506SSCib0JGaERTYkmyT7teTWrRPulaNwj
# M74Ne7xurIADwtz3g2kXa5D2C6R2rxvnDFDWnP3jHaizrm0in+ngGcV3874yVv4b
# A4v/n9EgK8Btaau18c0Q
# SIG # End signature block
