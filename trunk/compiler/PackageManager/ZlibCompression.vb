'==========================================================================
'
'  File:        ZlibCompression.vb
'  Location:    CitiesXLLoc <Visual Basic .Net>
'  Description: zlib 压缩解压
'  Version:     2010.05.07.
'  Copyright(C) F.R.C. / 3DMGame
'
'==========================================================================

Imports System
Imports Firefly
Imports zlib

Public NotInheritable Class ZlibCompression
    Private Sub New()
    End Sub

    Public Shared Function Decompress(ByVal Data As Byte()) As Byte()
        Using Input As New StreamEx
            Input.Write(Data)
            Input.Position = 0
            Using Output As New StreamEx
                Using s As New zlib.ZInputStream(Input.ToUnsafeStream)
                    Dim b = s.Read()
                    Dim PreviousTotalOut = 0
                    While True
                        Output.WriteByte(b)
                        b = s.Read()
                        If s.TotalOut > PreviousTotalOut Then
                            PreviousTotalOut = s.TotalOut
                        Else
                            Exit While
                        End If
                    End While
                End Using
                Output.Position = 0
                Return Output.Read(Output.Length)
            End Using
        End Using
    End Function

    Public Shared Sub ZlibDecompress(ByVal Input As ZeroPositionStreamPasser, ByVal Output As ZeroLengthStreamPasser)
        Using s As New zlib.ZInputStream(Input.GetStream.ToUnsafeStream)
            Dim b = s.Read()
            Dim PreviousTotalOut = 0
            Dim o = Output.GetStream
            While True
                o.WriteByte(b)
                b = s.Read()
                If s.TotalOut > PreviousTotalOut Then
                    PreviousTotalOut = s.TotalOut
                Else
                    Exit While
                End If
            End While
        End Using
    End Sub

    Public Shared Function Compress(ByVal Data As Byte(), Optional ByVal Level As Integer = zlibConst.Z_DEFAULT_COMPRESSION) As Byte()
        Using Output As New StreamEx
            Using s As New ZOutputStream(Output.ToUnsafeStream(), Level)
                s.Write(Data, 0, Data.Length)
                s.finish()
                Output.Position = 0
                Return Output.Read(Output.Length)
            End Using
        End Using
    End Function

    Public Shared Sub ZlibCompress(ByVal Input As ZeroPositionStreamPasser, ByVal Output As ZeroLengthStreamPasser, Optional ByVal Level As Integer = zlibConst.Z_DEFAULT_COMPRESSION)
        Using s As New ZOutputStream(Output.GetStream.ToUnsafeStream(), Level)
            Dim i = Input.GetStream
            i.ReadToStream(s, i.Length)
            s.finish()
        End Using
    End Sub
End Class
