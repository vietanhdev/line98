#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=LineIcon.ico
#AutoIt3Wrapper_Outfile=Line98.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=Line98 Game
#AutoIt3Wrapper_Res_Fileversion=0.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Nguyen Viet Anh - vietanh@vietanhdev.com - fb.com/vietanh197
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "GIFAnimation.au3"
#include <File.au3>
Opt("MustDeclareVars", 1)

Global $LastMoveX, $LastMoveY
Dim $Ball[10][10]
Global $NewBall[4] ;Lưu màu;~
Global $NewBallX[4], $NewBallY[4], $NumberOfNewBall = 0
Global $i, $j
Global $nMsg
Global $MainForm
Global $Pic_NewGame, $Pic_HowToPlay, $Pic_HighScore, $Pic_AboutMe, $Pic_ScoreBoard
Global $sb
Global $a[5], $b[5]
Global $gcp[10][10]
Global $gcNewGame, $gcHighScore, $gcHowToPlay, $gcAboutMe
Global $Pic_Number[11]
Global $YourScore = 0, $HighestScore = 0, $HighScoreName
Global $HighScoreFile = @ScriptDir & "\Line98.Lin"
$Pic_ScoreBoard = "Images\ScoreBoard.png"
$Pic_Number[0] = "Images\number 0.bmp"
$Pic_Number[1] = "Images\number 1.bmp"
$Pic_Number[2] = "Images\number 2.bmp"
$Pic_Number[3] = "Images\number 3.bmp"
$Pic_Number[4] = "Images\number 4.bmp"
$Pic_Number[5] = "Images\number 5.bmp"
$Pic_Number[6] = "Images\number 6.bmp"
$Pic_Number[7] = "Images\number 7.bmp"
$Pic_Number[8] = "Images\number 8.bmp"
$Pic_Number[9] = "Images\number 9.bmp"
$Pic_NewGame = "Images\NewGame.bmp"
$Pic_HowToPlay = "Images\HowToPlay.bmp"
$Pic_HighScore = "Images\HighScore.bmp"
$Pic_AboutMe = "Images\AboutMe.bmp"
Dim $Pic_pA[18], $Pic_pB[8], $Pic_pC[8]
Global $Pic_pE = "Images\0.gif"
$Pic_pA[1] = "Images\1.gif"
$Pic_pA[2] = "Images\2.gif"
$Pic_pA[3] = "Images\3.gif"
$Pic_pA[4] = "Images\4.gif"
$Pic_pA[5] = "Images\5.gif"
$Pic_pA[6] = "Images\6.gif"
$Pic_pA[7] = "Images\7.gif"
$Pic_pB[1] = "Images\1b.gif"
$Pic_pB[2] = "Images\2b.gif"
$Pic_pB[3] = "Images\3b.gif"
$Pic_pB[4] = "Images\4b.gif"
$Pic_pB[5] = "Images\5b.gif"
$Pic_pB[6] = "Images\6b.gif"
$Pic_pB[7] = "Images\7b.gif"
$Pic_pC[1] = "Images\1c.gif"
$Pic_pC[2] = "Images\2c.gif"
$Pic_pC[3] = "Images\3c.gif"
$Pic_pC[4] = "Images\4c.gif"
$Pic_pC[5] = "Images\5c.gif"
$Pic_pC[6] = "Images\6c.gif"
$Pic_pC[7] = "Images\7c.gif"
Global $Pic_pMove = "Images\move.gif"
Global $Pic_boom = "Images\boom.gif"
Global $Sound_Move = "Sound\MOVE.WAV"
Global $Sound_Destroy = "Sound\DESTROY.WAV"


Func IsGameOver()
	Local $i, $j
	Local $GameOver
	Local $Name
	Local $file
	$GameOver = True
	For $i = 1 To 9
		For $j = 1 To 9
			If $Ball[$i][$j] <= 0 Then
				$GameOver = False
				ExitLoop (2)
			EndIf
		Next
	Next
	If $GameOver Then
		If $YourScore > $HighestScore Then
			$HighestScore = $YourScore
			Update_Score()
			$Name = InputBox("Game Over!", "Game Over! Your Score: " & $YourScore & @LF & "Enter your name:")
			$HighScoreName = $Name
			If Not FileExists($HighScoreFile) Then
				_FileCreate($HighScoreFile)
			EndIf
			$file = FileOpen($HighScoreFile, $FO_APPEND)
			FileWriteLine($file, $Name)
			FileWriteLine($file, $HighestScore)
			FileClose($file)
		Else
			MsgBox(0, "Game Over!", "Game Over! Your Score: " & $YourScore)
		EndIf
	EndIf
EndFunc   ;==>IsGameOver

Global $X[82], $Y[82], $Count
Func IsEmpty() ;trả về True nếu tất cả các ô trong bảng đều có bóng to hoặc bóng nhỏ
	$Count = 0
	For $i = 1 To 9 ;Thống kê các ô trống
		For $j = 1 To 9
			If $Ball[$i][$j] = 0 Then
				$Count = $Count + 1
				$X[$Count] = $i
				$Y[$Count] = $j
			EndIf
		Next
	Next
	If $Count > 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsEmpty


Func AddBall()
	Local $i, $j
	Local $BallPosition ;Lưu số $Count vị trí Ball khi bị trí định đặt bóng đã bị đẩy bóng vào
	Local $NewBallPosition[4] ;Lưu số $Count vị trí NewBall
;~ Phóng to bóng cũ
	For $i = 1 To $NumberOfNewBall
		If $Ball[$NewBallX[$i]][$NewBallY[$i]] < 0 Then ;Nếu vị trí đặt bóng mới vẫn trống (chưa bị đẩy bóng vào)
			$Ball[$NewBallX[$i]][$NewBallY[$i]] = $NewBall[$i] ;Màu bóng mới
		Else ;Nếu vị trí bóng ko còn trống
			If IsEmpty() Then ;Nếu còn ô trống trong bảng
				$BallPosition = Random(1, $Count, 1)
				$NewBallX[$i] = $X[$BallPosition]
				$NewBallY[$i] = $Y[$BallPosition]
				$Ball[$NewBallX[$i]][$NewBallY[$i]] = $NewBall[$i]
			Else
				$NumberOfNewBall = $NumberOfNewBall - 1 ;Giảm bóng mới nếu ko có ô trống
			EndIf
		EndIf
	Next
	For $i = 1 To $NumberOfNewBall
		_GIF_DeleteGIF($gcp[$NewBallX[$i]][$NewBallY[$i]])
		$gcp[$NewBallX[$i]][$NewBallY[$i]] = _GUICtrlCreateGIF($Pic_pA[$NewBall[$i]], "", $NewBallY[$i] * 50 - 35, $NewBallX[$i] * 50 - 25)
	Next
;~ Phóng to bóng cũ
	CheckPoint()
	IsGameOver()
;~ Tạo bóng nhỏ mới
	If Not IsEmpty() Then ;Xem có thể thêm bóng không, Nếu thêm đc giá trị AddBall() trả về true, ko thì trả về False
		Return False
	EndIf
	If $Count < 3 Then ;Xem có thể tạo bao nhiêu bóng mới
		$NumberOfNewBall = $Count
	Else
		$NumberOfNewBall = 3
	EndIf
	Local $NewBallPosition[4] ;Lưu số $Count vị trí NewBall
	For $i = 1 To $NumberOfNewBall
		$NewBallPosition[$i] = Random(1, $Count, 1)
		$NewBallX[$i] = $X[$NewBallPosition[$i]]
		$NewBallY[$i] = $Y[$NewBallPosition[$i]]
		$X[$NewBallPosition[$i]] = $X[$Count]
		$Y[$NewBallPosition[$i]] = $Y[$Count]
		$Count = $Count - 1
	Next
;~ Chọn màu NewBall
	For $i = 1 To $NumberOfNewBall
		$NewBall[$i] = Random(1, 7, 1) ;Chọn màu
	Next
;~ Chọn màu NewBall
;~ Vẽ bóng nhỏ mới
	For $i = 1 To $NumberOfNewBall
		$Ball[$NewBallX[$i]][$NewBallY[$i]] = -$NewBall[$i]
		_GIF_DeleteGIF($gcp[$NewBallX[$i]][$NewBallY[$i]])
		$gcp[$NewBallX[$i]][$NewBallY[$i]] = _GUICtrlCreateGIF($Pic_pC[$NewBall[$i]], "", $NewBallY[$i] * 50 - 35, $NewBallX[$i] * 50 - 25)
	Next
;~ Vẽ bóng nhỏ mới

;~ Tạo bóng nhỏ mới
	Return True
EndFunc   ;==>AddBall

Func Update_Score() ;~ Cập nhật bảng điểm
	Local $i, $sc
	$sc = $YourScore
	For $i = 1 To 4
		_GIF_DeleteGIF($a[$i])
		$a[$i] = _GUICtrlCreateGIF($Pic_Number[Mod($sc, 10)], "", 612 - 25 * ($i - 1), 150)
		$sc = ($sc - Mod($sc, 10)) / 10
	Next
	$sc = $HighestScore
	For $i = 1 To 4
		_GIF_DeleteGIF($b[$i])
		$b[$i] = _GUICtrlCreateGIF($Pic_Number[Mod($sc, 10)], "", 610 - 25 * ($i - 1), 250)
		$sc = ($sc - Mod($sc, 10)) / 10
	Next
EndFunc   ;==>Update_Score

Func CheckPoint2($X, $Y)
	Local $Color
	Local $Line[5] ;Lưu số ô cùng màu ô đang xét không kể nó
	Local $AddScore = 0
	Local $CheckX[5][9], $CheckY[5][9]
	$Color = $Ball[$X][$Y]
	; --------------------------------------- Xét hàng dọc -------------------------------------------------------------------
	$Line[1] = 0
	$j = $Y
	$i = $X - 1
	While $i > 0
		If $Ball[$i][$j] = $Color Then
			$Line[1] = $Line[1] + 1
			$CheckX[1][$Line[1]] = $i
			$CheckY[1][$Line[1]] = $j
		Else
			ExitLoop (1)
		EndIf
		$i = $i - 1
	WEnd
	$i = $X + 1
	While $i <= 9
		If $Ball[$i][$j] = $Color Then
			$Line[1] = $Line[1] + 1
			$CheckX[1][$Line[1]] = $i
			$CheckY[1][$Line[1]] = $j
		Else
			ExitLoop (1)
		EndIf
		$i = $i + 1
	WEnd
	; --------------------------------------- Xét hàng dọc -------------------------------------------------------------------
	; --------------------------------------- Xét hàng ngang -----------------------------------------------------------------
	$Line[2] = 0
	$i = $X
	$j = $Y - 1
	While $j > 0
		If $Ball[$i][$j] = $Color Then
			$Line[2] = $Line[2] + 1
			$CheckX[2][$Line[2]] = $i
			$CheckY[2][$Line[2]] = $j
		Else
			ExitLoop (1)
		EndIf
		$j = $j - 1
	WEnd
	$j = $Y + 1
	While $j <= 9
		If $Ball[$i][$j] = $Color Then
			$Line[2] = $Line[2] + 1
			$CheckX[2][$Line[2]] = $i
			$CheckY[2][$Line[2]] = $j
		Else
			ExitLoop (1)
		EndIf
		$j = $j + 1
	WEnd
	; --------------------------------------- Xét hàng ngang -----------------------------------------------------------------
	; --------------------------------------- Xét chéo 1 -----------------------------------------------------------------
	$Line[3] = 0
	$i = $X - 1
	$j = $Y - 1
	While ($i > 0) And ($j > 0)
		If $Ball[$i][$j] = $Color Then
			$Line[3] = $Line[3] + 1
			$CheckX[3][$Line[3]] = $i
			$CheckY[3][$Line[3]] = $j
		Else
			ExitLoop (1)
		EndIf
		$i = $i - 1
		$j = $j - 1
	WEnd
	$i = $X + 1
	$j = $Y + 1
	While ($i <= 9) And ($j <= 9)
		If $Ball[$i][$j] = $Color Then
			$Line[3] = $Line[3] + 1
			$CheckX[3][$Line[3]] = $i
			$CheckY[3][$Line[3]] = $j
		Else
			ExitLoop (1)
		EndIf
		$i = $i + 1
		$j = $j + 1
	WEnd
	; --------------------------------------- Xét chéo 1 -----------------------------------------------------------------
	; --------------------------------------- Xét chéo 2 -----------------------------------------------------------------
	$Line[4] = 0
	$i = $X + 1
	$j = $Y - 1
	While ($i <= 9) And ($j > 0)
		If $Ball[$i][$j] = $Color Then
			$Line[4] = $Line[4] + 1
			$CheckX[4][$Line[4]] = $i
			$CheckY[4][$Line[4]] = $j
		Else
			ExitLoop (1)
		EndIf
		$i = $i + 1
		$j = $j - 1
	WEnd
	$i = $X - 1
	$j = $Y + 1
	While ($i > 0) And ($j <= 9)
		If $Ball[$i][$j] = $Color Then
			$Line[4] = $Line[4] + 1
			$CheckX[4][$Line[4]] = $i
			$CheckY[4][$Line[4]] = $j
		Else
			ExitLoop (1)
		EndIf
		$i = $i - 1
		$j = $j + 1
	WEnd
	; --------------------------------------- Xét chéo 2 -----------------------------------------------------------------

	$AddScore = 0
	For $i = 1 To 4 ;Xét 4 phương ăn điểm > Đặt bom
		If $Line[$i] >= 4 Then
			For $j = 1 To $Line[$i]
				_GIF_DeleteGIF($gcp[$CheckX[$i][$j]][$CheckY[$i][$j]])
				$gcp[$CheckX[$i][$j]][$CheckY[$i][$j]] = _GUICtrlCreateGIF($Pic_boom, "", $CheckY[$i][$j] * 50 - 35, $CheckX[$i][$j] * 50 - 25)
			Next
			$AddScore = $AddScore + $Line[$i] + 1
		EndIf
	Next
	If $AddScore > 0 Then ;Xóa nốt ô cuối
		_GIF_DeleteGIF($gcp[$X][$Y])
		$gcp[$X][$Y] = _GUICtrlCreateGIF($Pic_boom, "", $Y * 50 - 35, $X * 50 - 25)
		SoundPlay($Sound_Destroy)
	EndIf
	Sleep(200)
	For $i = 1 To 4 ;Xét 4 phương ăn điểm > Cho nổ
		If $Line[$i] >= 4 Then
			For $j = 1 To $Line[$i]
				$Ball[$CheckX[$i][$j]][$CheckY[$i][$j]] = 0
				_GIF_DeleteGIF($gcp[$CheckX[$i][$j]][$CheckY[$i][$j]])
				$gcp[$CheckX[$i][$j]][$CheckY[$i][$j]] = _GUICtrlCreateGIF($Pic_pE, "", $CheckY[$i][$j] * 50 - 35, $CheckX[$i][$j] * 50 - 25)
			Next
		EndIf
	Next
	If $AddScore > 0 Then ;Xóa nốt ô cuối
		$Ball[$X][$Y] = 0
		_GIF_DeleteGIF($gcp[$X][$Y])
		$gcp[$X][$Y] = _GUICtrlCreateGIF($Pic_pE, "", $Y * 50 - 35, $X * 50 - 25)
	EndIf

	If $AddScore > 0 Then
		$AddScore = 5 + 2 * ($AddScore - 5)
		$YourScore = $YourScore + $AddScore
		Update_Score()
	EndIf
EndFunc   ;==>CheckPoint2
Func CheckPoint()
	Local $i

	If $Ball[$LastMoveX][$LastMoveY] > 0 Then ;Nếu ô vừa di chuyển tới có bi (Chưa bị xóa bi do tính điểm)
		CheckPoint2($LastMoveX, $LastMoveY)
	EndIf

	For $i = 1 To $NumberOfNewBall ;Xét những ô có bóng mới xuất hiện
		CheckPoint2($NewBallX[$i], $NewBallY[$i])
	Next

EndFunc   ;==>CheckPoint


Global $moveX[82], $moveY[82], $mommy[82], $moveCount ;Lưu các giả định nước đi (x,y) dùng cho MoveOK() và MakeMove()
Func MoveOK($X1, $Y1, $X2, $Y2)
	Local $moveOK = False
	Local $i, $j, $k
	Local $CutDown[10][10] ;Giá trị True ô chưa xét tới, Giá trị False ô đã xét
	For $i = 1 To 9 ;Taọ giá trị mảng
		For $j = 1 To 9
			$CutDown[$i][$j] = True
		Next
	Next
	$CutDown[$X1][$Y1] = False
	$moveCount = 1
	$moveX[1] = $X1
	$moveY[1] = $Y1
	$i = 1
	While $i <= $moveCount
		If ($moveX[$i] - 1 > 0) Then ;Lùi X
			If ($Ball[$moveX[$i] - 1][$moveY[$i]] <= 0) And ($CutDown[$moveX[$i] - 1][$moveY[$i]] = True) Then
				$moveCount = $moveCount + 1
				$moveX[$moveCount] = $moveX[$i] - 1
				$moveY[$moveCount] = $moveY[$i]
				$mommy[$moveCount] = $i
				If ($moveX[$moveCount] = $X2) And ($moveY[$moveCount] = $Y2) Then
					$moveOK = True
					ExitLoop (1)
				EndIf
				$CutDown[$moveX[$i] - 1][$moveY[$i]] = False
			EndIf
		EndIf
		If ($moveX[$i] + 1 <= 9) Then ;Tiến X
			If ($Ball[$moveX[$i] + 1][$moveY[$i]] <= 0) And ($CutDown[$moveX[$i] + 1][$moveY[$i]] = True) Then
				$moveCount = $moveCount + 1
				$moveX[$moveCount] = $moveX[$i] + 1
				$moveY[$moveCount] = $moveY[$i]
				$mommy[$moveCount] = $i
				If ($moveX[$moveCount] = $X2) And ($moveY[$moveCount] = $Y2) Then
					$moveOK = True
					ExitLoop (1)
				EndIf
				$CutDown[$moveX[$i] + 1][$moveY[$i]] = False
			EndIf
		EndIf
		If ($moveY[$i] - 1 > 0) Then ;Lùi Y
			If ($Ball[$moveX[$i]][$moveY[$i] - 1] <= 0) And ($CutDown[$moveX[$i]][$moveY[$i] - 1] = True) Then
				$moveCount = $moveCount + 1
				$moveX[$moveCount] = $moveX[$i]
				$moveY[$moveCount] = $moveY[$i] - 1
				$mommy[$moveCount] = $i
				If ($moveX[$moveCount] = $X2) And ($moveY[$moveCount] = $Y2) Then
					$moveOK = True
					ExitLoop (1)
				EndIf
				$CutDown[$moveX[$i]][$moveY[$i] - 1] = False
			EndIf
		EndIf
		If ($moveY[$i] + 1 <= 9) Then ;Tiến Y
			If ($Ball[$moveX[$i]][$moveY[$i] + 1] <= 0) And ($CutDown[$moveX[$i]][$moveY[$i] + 1] = True) Then
				$moveCount = $moveCount + 1
				$moveX[$moveCount] = $moveX[$i]
				$moveY[$moveCount] = $moveY[$i] + 1
				$mommy[$moveCount] = $i
				If ($moveX[$moveCount] = $X2) And ($moveY[$moveCount] = $Y2) Then
					$moveOK = True
					ExitLoop (1)
				EndIf
				$CutDown[$moveX[$i]][$moveY[$i] + 1] = False
			EndIf
		EndIf
		$i = $i + 1
	WEnd
	Return $moveOK
EndFunc   ;==>MoveOK

; Ô bắt đầu và ô kết thúc lấy ở các biến $moveX[82], $moveY[82], $mommy[82], $moveCount

Func MakeMove()
	Local $X1, $Y1, $X2, $Y2
	Local $BuildMoveX[82], $BuildMoveY[82], $BuildMoveCount = 0 ;Lưu đường đi giữa 2 ô di chuyển
	Local $i
	$X1 = $moveX[1]
	$Y1 = $moveY[1]
	$X2 = $moveX[$moveCount]
	$Y2 = $moveY[$moveCount]
	While $moveCount <> 1
		$BuildMoveCount = $BuildMoveCount + 1
		$BuildMoveX[$BuildMoveCount] = $moveX[$moveCount]
		$BuildMoveY[$BuildMoveCount] = $moveY[$moveCount]
		$moveCount = $mommy[$moveCount]
	WEnd

	$Ball[$X2][$Y2] = $Ball[$X1][$Y1]
	$Ball[$X1][$Y1] = 0
	_GIF_DeleteGIF($gcp[$X1][$Y1])
	$gcp[$X1][$Y1] = _GUICtrlCreateGIF($Pic_pE, "", $Y1 * 50 - 35, $X1 * 50 - 25)
	;Vẽ hình nước đi
	$i = $BuildMoveCount
	While $i >= 1
		If $Ball[$BuildMoveX[$i]][$BuildMoveY[$i]] = 0 Then
			_GIF_DeleteGIF($gcp[$BuildMoveX[$i]][$BuildMoveY[$i]])
			$gcp[$BuildMoveX[$i]][$BuildMoveY[$i]] = _GUICtrlCreateGIF($Pic_pMove, "", $BuildMoveY[$i] * 50 - 35, $BuildMoveX[$i] * 50 - 25)
		EndIf
		$i = $i - 1
	WEnd
	Sleep(200)
	;Xóa hình nước đi
	$i = $BuildMoveCount
	While $i >= 1
		If $Ball[$BuildMoveX[$i]][$BuildMoveY[$i]] = 0 Then
			_GIF_DeleteGIF($gcp[$BuildMoveX[$i]][$BuildMoveY[$i]])
			$gcp[$BuildMoveX[$i]][$BuildMoveY[$i]] = _GUICtrlCreateGIF($Pic_pE, "", $BuildMoveY[$i] * 50 - 35, $BuildMoveX[$i] * 50 - 25)
		EndIf
		$i = $i - 1
	WEnd
	SoundPlay($Sound_Move)
	_GIF_DeleteGIF($gcp[$X2][$Y2])
	$gcp[$X2][$Y2] = _GUICtrlCreateGIF($Pic_pA[$Ball[$X2][$Y2]], "", $Y2 * 50 - 35, $X2 * 50 - 25)
	$LastMoveX = $X2
	$LastMoveY = $Y2
	AddBall()
EndFunc   ;==>MakeMove

Global $Picked = False, $PickedX, $PickedY

Func Pick($PickX, $PickY)
;~ 	Thực hiên nước đi nếu có thể
	If $Picked And ($Ball[$PickX][$PickY] <= 0) And MoveOK($PickedX, $PickedY, $PickX, $PickY) Then
		MakeMove()
		$Picked = False
		CheckPoint()
	Else
;~ 	;Nhả bóng chọn từ trước
		If $Picked And (($PickedX <> $PickX) Or ($PickedY <> $PickY)) And ($Ball[$PickedX][$PickedY] > 0) Then
			_GIF_DeleteGIF($gcp[$PickedX][$PickedY])
			$gcp[$PickedX][$PickedY] = _GUICtrlCreateGIF($Pic_pA[$Ball[$PickedX][$PickedY]], "", $PickedY * 50 - 35, $PickedX * 50 - 25)
			$Picked = False
		EndIf

;~ 	Đánh dấu bóng mới chọn
		If (Not $Picked) And ($Ball[$PickX][$PickY] > 0) Then
			SoundPlay($Sound_Move)
			_GIF_DeleteGIF($gcp[$PickX][$PickY])
			$gcp[$PickX][$PickY] = _GUICtrlCreateGIF($Pic_pB[$Ball[$PickX][$PickY]], "", $PickY * 50 - 35, $PickX * 50 - 25)
			$PickedX = $PickX
			$PickedY = $PickY
			$Picked = True
		EndIf
	EndIf
EndFunc   ;==>Pick


Func NewGame()
	Local $i, $j
;~ 	Tạo nhấn chuột
	_GIF_DeleteGIF($gcNewGame)
	$gcNewGame = _GUICtrlCreateGIF($Pic_NewGame, "", 500, 312)
	Sleep(50)
	_GIF_DeleteGIF($gcNewGame)
	$gcNewGame = _GUICtrlCreateGIF($Pic_NewGame, "", 500, 310)
;~ 	Tạo nhấn chuột

	$LastMoveX = 0
	$LastMoveY = 0
	$YourScore = 0
	Update_Score()
	For $i = 1 To 9
		For $j = 1 To 9
			$Ball[$i][$j] = 0
			_GIF_DeleteGIF($gcp[$i][$j])
			$gcp[$i][$j] = _GUICtrlCreateGIF($Pic_pE, "", $j * 50 - 35, $i * 50 - 25)
		Next
	Next
	$NumberOfNewBall = 0
	AddBall()
	AddBall()
EndFunc   ;==>NewGame

Func HighScore()
;~ 	Tạo nhấn chuột
	_GIF_DeleteGIF($gcHighScore)
	$gcHighScore = _GUICtrlCreateGIF($Pic_HighScore, "", 500, 392)
	Sleep(50)
	_GIF_DeleteGIF($gcHighScore)
	$gcHighScore = _GUICtrlCreateGIF($Pic_HighScore, "", 500, 390)
;~ 	Tạo nhấn chuột
	MsgBox(0, "High Score", "Score" & "            " & "Name" & @LF & $HighestScore & "           " & $HighScoreName)
EndFunc   ;==>HighScore

Func HowToPlay()
;~ 	Tạo nhấn chuột
	_GIF_DeleteGIF($gcHowToPlay)
	$gcHowToPlay = _GUICtrlCreateGIF($Pic_HowToPlay, "", 500, 352)
	Sleep(50)
	_GIF_DeleteGIF($gcHowToPlay)
	$gcHowToPlay = _GUICtrlCreateGIF($Pic_HowToPlay, "", 500, 350)
;~ 	Tạo nhấn chuột

	MsgBox(0, "How To Play", "Lines 98 is a game play on 9×9 board with balls of seven different colors. The player can move one ball per turn to remove balls by forming lines (horizontal, vertical or diagonal) of at least five balls of the same color. If the player does form such lines of at least five balls of the same color, the balls in those lines disappear, and he gains one turn, i.e. he can move another ball. If not, three new balls are added, and the game continues until the board is full." & @LF & "(from internet)" & @LF & "Đơn giản là sắp xếp các quả bóng sao cho chúng tạo thành hàng chéo, hàng dọc, hoặc hàng ngang nhiều hơn 5 viên cùng màu. Các viên bi sẽ biến mất, bạn có thêm điểm. Lưu ý các viên bi chỉ có thể di chuyển qua các ô vuông chung cạnh.")
EndFunc   ;==>HowToPlay

Func AboutMe()
;~ 	Tạo nhấn chuột
	_GIF_DeleteGIF($gcAboutMe)
	$gcAboutMe = _GUICtrlCreateGIF($Pic_AboutMe, "", 500, 432)
	Sleep(50)
	_GIF_DeleteGIF($gcAboutMe)
	$gcAboutMe = _GUICtrlCreateGIF($Pic_AboutMe, "", 500, 430)
;~ 	Tạo nhấn chuột
	MsgBox(0, "About me", "Game Line98" & @LF & "Designed and Coded by Viet Anh" & @LF & "Email: vietanh@vietanhdev.com" & @LF & "(F) fb.com/vietanh197" & @LF & "Have fun!")
EndFunc   ;==>AboutMe


$MainForm = GUICreate("Line98 by Viet Anh", 665, 495, 296, 146, -1, BitOR($WS_EX_APPWINDOW, $WS_EX_WINDOWEDGE))
GUISetBkColor(0x996600, $MainForm)
$sb = _GUICtrlCreateGIF($Pic_ScoreBoard, "", 480, 20)
$a[4] = _GUICtrlCreateGIF($Pic_Number[0], "", 537, 150)
$a[3] = _GUICtrlCreateGIF($Pic_Number[0], "", 562, 150)
$a[2] = _GUICtrlCreateGIF($Pic_Number[0], "", 587, 150)
$a[1] = _GUICtrlCreateGIF($Pic_Number[0], "", 612, 150)
$b[4] = _GUICtrlCreateGIF($Pic_Number[0], "", 535, 250)
$b[3] = _GUICtrlCreateGIF($Pic_Number[0], "", 560, 250)
$b[2] = _GUICtrlCreateGIF($Pic_Number[0], "", 585, 250)
$b[1] = _GUICtrlCreateGIF($Pic_Number[0], "", 610, 250)
$gcNewGame = _GUICtrlCreateGIF($Pic_NewGame, "", 500, 310)
$gcHowToPlay = _GUICtrlCreateGIF($Pic_HowToPlay, "", 500, 350)
$gcHighScore = _GUICtrlCreateGIF($Pic_HighScore, "", 500, 390)
$gcAboutMe = _GUICtrlCreateGIF($Pic_AboutMe, "", 500, 430)

Global $ofile
If FileExists($HighScoreFile) Then
	$ofile = FileOpen($HighScoreFile)
	$HighScoreName = FileReadLine($ofile, 1)
	$HighestScore = FileReadLine($ofile, 2)
	FileClose($HighScoreFile)
EndIf


For $i = 1 To 9
	For $j = 1 To 9
		$gcp[$i][$j] = _GUICtrlCreateGIF($Pic_pE, "", $j * 50 - 35, $i * 50 - 25)
	Next
Next

NewGame()
GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $gcNewGame
			NewGame()
		Case $gcHowToPlay
			HowToPlay()
		Case $gcHighScore
			HighScore()
		Case $gcAboutMe
			AboutMe()
		Case $gcp[1][1]
			Pick(1, 1)
		Case $gcp[1][2]
			Pick(1, 2)
		Case $gcp[1][3]
			Pick(1, 3)
		Case $gcp[1][4]
			Pick(1, 4)
		Case $gcp[1][5]
			Pick(1, 5)
		Case $gcp[1][6]
			Pick(1, 6)
		Case $gcp[1][7]
			Pick(1, 7)
		Case $gcp[1][8]
			Pick(1, 8)
		Case $gcp[1][9]
			Pick(1, 9)
		Case $gcp[2][1]
			Pick(2, 1)
		Case $gcp[2][2]
			Pick(2, 2)
		Case $gcp[2][3]
			Pick(2, 3)
		Case $gcp[2][4]
			Pick(2, 4)
		Case $gcp[2][5]
			Pick(2, 5)
		Case $gcp[2][6]
			Pick(2, 6)
		Case $gcp[2][7]
			Pick(2, 7)
		Case $gcp[2][8]
			Pick(2, 8)
		Case $gcp[2][9]
			Pick(2, 9)
		Case $gcp[3][1]
			Pick(3, 1)
		Case $gcp[3][2]
			Pick(3, 2)
		Case $gcp[3][3]
			Pick(3, 3)
		Case $gcp[3][4]
			Pick(3, 4)
		Case $gcp[3][5]
			Pick(3, 5)
		Case $gcp[3][6]
			Pick(3, 6)
		Case $gcp[3][7]
			Pick(3, 7)
		Case $gcp[3][8]
			Pick(3, 8)
		Case $gcp[3][9]
			Pick(3, 9)
		Case $gcp[4][1]
			Pick(4, 1)
		Case $gcp[4][2]
			Pick(4, 2)
		Case $gcp[4][3]
			Pick(4, 3)
		Case $gcp[4][4]
			Pick(4, 4)
		Case $gcp[4][5]
			Pick(4, 5)
		Case $gcp[4][6]
			Pick(4, 6)
		Case $gcp[4][7]
			Pick(4, 7)
		Case $gcp[4][8]
			Pick(4, 8)
		Case $gcp[4][9]
			Pick(4, 9)
		Case $gcp[5][1]
			Pick(5, 1)
		Case $gcp[5][2]
			Pick(5, 2)
		Case $gcp[5][3]
			Pick(5, 3)
		Case $gcp[5][4]
			Pick(5, 4)
		Case $gcp[5][5]
			Pick(5, 5)
		Case $gcp[5][6]
			Pick(5, 6)
		Case $gcp[5][7]
			Pick(5, 7)
		Case $gcp[5][8]
			Pick(5, 8)
		Case $gcp[5][9]
			Pick(5, 9)
		Case $gcp[6][1]
			Pick(6, 1)
		Case $gcp[6][2]
			Pick(6, 2)
		Case $gcp[6][3]
			Pick(6, 3)
		Case $gcp[6][4]
			Pick(6, 4)
		Case $gcp[6][5]
			Pick(6, 5)
		Case $gcp[6][6]
			Pick(6, 6)
		Case $gcp[6][7]
			Pick(6, 7)
		Case $gcp[6][8]
			Pick(6, 8)
		Case $gcp[6][9]
			Pick(6, 9)
		Case $gcp[7][1]
			Pick(7, 1)
		Case $gcp[7][2]
			Pick(7, 2)
		Case $gcp[7][3]
			Pick(7, 3)
		Case $gcp[7][4]
			Pick(7, 4)
		Case $gcp[7][5]
			Pick(7, 5)
		Case $gcp[7][6]
			Pick(7, 6)
		Case $gcp[7][7]
			Pick(7, 7)
		Case $gcp[7][8]
			Pick(7, 8)
		Case $gcp[7][9]
			Pick(7, 9)
		Case $gcp[8][1]
			Pick(8, 1)
		Case $gcp[8][2]
			Pick(8, 2)
		Case $gcp[8][3]
			Pick(8, 3)
		Case $gcp[8][4]
			Pick(8, 4)
		Case $gcp[8][5]
			Pick(8, 5)
		Case $gcp[8][6]
			Pick(8, 6)
		Case $gcp[8][7]
			Pick(8, 7)
		Case $gcp[8][8]
			Pick(8, 8)
		Case $gcp[8][9]
			Pick(8, 9)
		Case $gcp[9][1]
			Pick(9, 1)
		Case $gcp[9][2]
			Pick(9, 2)
		Case $gcp[9][3]
			Pick(9, 3)
		Case $gcp[9][4]
			Pick(9, 4)
		Case $gcp[9][5]
			Pick(9, 5)
		Case $gcp[9][6]
			Pick(9, 6)
		Case $gcp[9][7]
			Pick(9, 7)
		Case $gcp[9][8]
			Pick(9, 8)
		Case $gcp[9][9]
			Pick(9, 9)
	EndSwitch
WEnd





