; 该脚本使用 HM VNISEdit 脚本编辑器向导产生

; 安装程序初始定义常量
!define PRODUCT_NAME "AisinoA0在线版"
!define PRODUCT_VERSION "1.0.0000"
!define PRODUCT_PUBLISHER "航天信息软件技术有限公司"
!define PRODUCT_WEB_SITE "http://soft.aisino.com/"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_TRUST_SITE_KEY "Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\Range99"
;Internet 区域
;!define PRODUCT_INTERNET_ACTIVEX_KEY "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
;可信站点区域
!define PRODUCT_TRUST_ACTIVEX_KEY "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2"
!define PRODUCT_TRUST_SITE_ROOT_KEY "HKCU"
!define PRODUCT_INSTALL_KEY "SOFTWARE\AisinoA0"

SetCompressor /solid lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"
!include "XML.nsh"
!include "WordFunc.nsh"
!include "Registry.nsh"
!include "WinVer.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "A0online.ico"
!define MUI_UNICON "A0unload.ico"
; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
!insertmacro MUI_PAGE_LICENSE "Online\license.txt"
; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\tools\README.txt"
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "A0_Online_Setup.exe"
InstallDir "C:\AisinoA0"
ShowInstDetails nevershow
ShowUnInstDetails nevershow

Section "MainSection" SEC01
    SetShellVarContext all
    ${registry::Read} "${PRODUCT_UNINST_ROOT_KEY}\${PRODUCT_INSTALL_KEY}" "INSTALL_PATH" $R0 $R1
    ${registry::Read} "${PRODUCT_UNINST_ROOT_KEY}\${PRODUCT_INSTALL_KEY}" "VERSION" $R2 $R3
    ${If} $R1 == ""
  	DetailPrint "未安装AisinoA0，可以安装。"
		Goto start
    ${Else}
    ;在这里还需要加上版本判断
    ${If} $R3 == ""
    DetailPrint "AisinoA0版本号为空，安装程序将退出"
    Quit
    ${Else}
    ${VersionConvert} "$R2" "" $R4
    ${VersionConvert} "${PRODUCT_VERSION}" "" $R5
    ${VersionCompare}  "$R5" "$R4" $R6
    ;MessageBox MB_OK '本地版本"$R4";补丁版本"$R5";判断结果"$R6"'
		${If} $R6 == "0"
		Goto success
		${ElseIf} $R6 == "1"
		Goto success
		${Else}
		MessageBox MB_OK "已经安装了AisinoA0，并且版本比当前安装的版本更高，无需重新安装。如果想安装低版本，请卸载后重新安装"
    Quit
		${EndIf}
		success:
		;这个参数用来判断是否安装了A0，如果是就不删db，再次安装的时候也不复制db
		StrCpy $R9 "1"
    MessageBox MB_YESNO "已经安装了AisinoA0，继续安装将覆盖上次安装,要继续吗？" IDYES true IDNO false
	  true:
    StrCmp $R0 $INSTDIR 0 +2
    Goto next
		;把db文件夹拷贝过去
		CreateDirectory $INSTDIR\db
		CopyFiles /SILENT $R0\db\*.* $INSTDIR\db
		Goto next
	  false:
    quit
    ${EndIf}
    ${EndIf}
  next:
  SetOutPath "$R0\container\bin"
	nsExec::Exec "cmd /C service remove AisinoA0"

  Delete "$SMPROGRAMS\AisinoA0\*.*"
  Delete "$DESKTOP\A0轻松管理.lnk"
  RMDir "$SMPROGRAMS\AisinoA0"
	;删除除了db之外的文件夹
  SetOutPath "$R0"
  RMDir /r "$R0\bin"
  RMDir /r "$R0\container"
  RMDir /r "$R0\tools"
  ;这里还不能删除注册表信息，不然无法判断数据库升级到哪个版本
  ;DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  ;DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_INSTALL_KEY}"
  SetAutoClose true
	start:
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  ;这个参数用来判断是否安装了A0，如果是就不删db，再次安装的时候也不复制db
	${If} $R9 == "1"
  File /r /x "db" "Online\*.*"
  ;调用小何的升级程序
	ExecWait '"$INSTDIR\tools\A0UpdateProgram.exe"'
  ${Else}
  File /r "Online\*.*"
  ${EndIf}
  ;当前A0安装环境是win2000，需要gdiplus.dll文件放到系统盘安装硬盘下
  ${If} ${IsWin2000}
  CopyFiles /SILENT $INSTDIR\tools\gdiplus.dll $WINDIR\system32
  ${EndIf}
SectionEnd

Section -AdditionalIcons
	WriteIniStr "$INSTDIR\bin\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "http://127.0.0.1:8800/A0/pt/canvas?formid=a0login&shellsize=max"
	WriteIniStr "$INSTDIR\bin\${PRODUCT_NAME}.url" "InternetShortcut" "IconFile" "$INSTDIR\bin\LOGO.ico"
	WriteIniStr "$INSTDIR\bin\${PRODUCT_NAME}.url" "InternetShortcut" "IconIndex" "0"

	NSISdl::download /TIMEOUT=3000 "http://211.94.145.64:8889/A6/A0container.rar" "A0container.rar"
		Pop $R0 ;获取返回值
  	StrCmp $R0 "success" +2
    NSISdl::download /TIMEOUT=3000 "http://192.168.4.28:8889/A6/A0container.rar" "A0container.rar"


	;MessageBox MB_OK "$INSTDIR\tools\unrar.exe x -y $INSTDIR\A0container.rar $INSTDIR"
	ExecWait '"$INSTDIR\tools\UnRAR.exe" x -y $INSTDIR\A0container.rar $INSTDIR'
	Delete $INSTDIR\A0container.rar

  SetOutPath "$INSTDIR\container\bin"
  Call UpdateTomcatConfig
	nsExec::Exec "cmd /C service install AisinoA0"
  CreateDirectory "$SMPROGRAMS\AisinoA0"
  CreateShortCut "$DESKTOP\A0轻松管理.lnk" "$INSTDIR\bin\${PRODUCT_NAME}.url" "" "$INSTDIR\bin\LOGO.ico"
  CreateShortCut "$SMPROGRAMS\AisinoA0\A0轻松管理.lnk" "$INSTDIR\bin\${PRODUCT_NAME}.url" "" "$INSTDIR\bin\LOGO.ico"
  CreateShortCut "$SMPROGRAMS\AisinoA0\卸载A0.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  ;将127.0.0.1加入可信站点
  WriteRegStr ${PRODUCT_TRUST_SITE_ROOT_KEY} "${PRODUCT_TRUST_SITE_KEY}" ":Range" "127.0.0.1"
  WriteRegDWORD ${PRODUCT_TRUST_SITE_ROOT_KEY} "${PRODUCT_TRUST_SITE_KEY}" "http" "0x00000002"
  ;将安装路径和版本号写入注册表，靠安装路径来判断是否已经安装，靠版本号来判断是否升级
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_INSTALL_KEY}" "INSTALL_PATH" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_INSTALL_KEY}" "VERSION" "${PRODUCT_VERSION}"
  ;在Internet 区域，对未标记为可安全执行脚本的Activex控件初始化并执行脚本：0-启用 3-禁用(默认) 1-提示 设置为提示
  ;WriteRegDWORD ${PRODUCT_TRUST_SITE_ROOT_KEY} "${PRODUCT_INTERNET_ACTIVEX_KEY}" "1201" "0x00000000"
  ;在可信站点区域，对未标记为可安全执行脚本的Activex控件初始化并执行脚本：0-启用 3-禁用(默认) 1-提示 设置为提示
  WriteRegDWORD ${PRODUCT_TRUST_SITE_ROOT_KEY} "${PRODUCT_TRUST_ACTIVEX_KEY}" "1201" "0x00000000"
SectionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
  SetShellVarContext all
  SetOutPath "$INSTDIR\container\bin"
	nsExec::Exec "cmd /C service remove AisinoA0"

  Delete "$SMPROGRAMS\AisinoA0\*.*"
  Delete "$DESKTOP\A0轻松管理.lnk"
  RMDir "$SMPROGRAMS\AisinoA0"

  SetOutPath "$INSTDIR"
  ;不加下面这句无法完全删除
  SetOutPath "$SMPROGRAMS"
  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_INSTALL_KEY}"
  SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#
Function .onInit

FunctionEnd


Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
FunctionEnd

Function UpdateTomcatConfig
    ${xml::LoadFile} "$INSTDIR\container\webapps\A0\WEB-INF\classes\product.xml" $0
    ${xml::CreateNode} "<link></link>" $R0
    ${xml::GotoPath} "/product/datasource/ds" $0
    ${xml::InsertEndChild} "$R0" $0
    ${xml::GotoPath} "/product/datasource/ds/link" $0
    ${xml::SetAttribute} "ip" "null" $0
    ${xml::SetAttribute} "port" "null" $0
		${WordReplace} $INSTDIR "\" "/" "+" $R0
    ${xml::SetAttribute} "dbname" "//$R0/db/A0.db" $0
    ${xml::SetAttribute} "user" "" $0
    ${xml::SetAttribute} "pwd" "" $0
    ${xml::SetAttribute} "timeout" "20000" $0

    ${xml::SaveFile} "$INSTDIR\container\webapps\A0\WEB-INF\classes\product.xml" $0
FunctionEnd
