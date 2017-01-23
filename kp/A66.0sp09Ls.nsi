; 该脚本使用 HM VNISEdit 脚本编辑器向导产生

; 安装程序初始定义常量
!define PRODUCT_NAME "A6 V6.0SP09支持升级版开票临时升级包"
!define PRODUCT_NAME_TXT "A6 V6.0SP09支持升级版开票临时升级包"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "航天信息软件技术有限公司"
!define PRODUCT_WEB_SITE "http://soft.aisino.com/"
;每次发新补丁改这个参数，如VIP1.0就是!define PRODUCT_UDPATE_SCRIPTS_PATH "web\updateScripts\mssql\VIP"
;!define PRODUCT_UDPATE_SCRIPTS_PATH "web\updateScripts\mssql\VIP"

SetCompressor /solid lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"
!include "OLEDB.NSH"
!include "XML.nsh"
!include "WordFunc.nsh"
!include "LogicLib.nsh"
; MUI 预定义常量
;!define MUI_WELCOMEPAGE_TEXT "\r\n 相比原程序，本安装包主要进行了以下增强\n		$_CLICK"
!define MUI_WELCOMEPAGE_TITLE "欢迎使用 ${PRODUCT_NAME_TXT} 安装向导"
!define MUI_WELCOMEPAGE_TEXT "这个向导将指引你完成 ${PRODUCT_NAME_TXT} 的安装。\r\n\
在使用前，建议先关闭其他所有应用程序，这将允许更新指定的系统文件，而不需要重新启动你的计算机。\r\n\
单击[下一步(N) >]继续。"
!define MUI_WELCOMEFINISHPAGE_BITMAP "left.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "left.bmp"
!define MUI_PAGE_HEADER_TEXT "最终用户许可协议"
!define MUI_PAGE_HEADER_SUBTEXT "您必须接受此协议才能继续使用"
!define MUI_LICENSEPAGE_TEXT_TOP "要阅读协议的其余部分请向下拖拽滚动条。"
!define MUI_LICENSEPAGE_TEXT_BOTTOM "如果你已经仔细阅读了许可协议，点击 下一步(N) > 。"
Caption "${PRODUCT_NAME} ${PRODUCT_VERSION}"
;!define MUI_HEADER_TEXT "${PRODUCT_NAME} ${PRODUCT_VERSION}"
!define MUI_LICENSEPAGE_BUTTON "下一步(N) >"
!define MUI_INSTFILESPAGE_FINISHHEADER_TEXT "安装完成"
!define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT ""
!define MUI_FINISHPAGE_TITLE "已完成 ${PRODUCT_NAME_TXT} 安装"
!define MUI_FINISHPAGE_TEXT "已完成${PRODUCT_NAME}安装，如果使用后仍不能解决问题，请将问题提交支持系统。"
!define MUI_ABORTWARNING
!define MUI_ICON "A6.ico"
;!define MUI_FINISHPAGE_NOAUTOCLOSE
; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
!insertmacro MUI_PAGE_LICENSE "license.txt"
; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!insertmacro MUI_PAGE_FINISH

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------
;文件版本声明
  VIProductVersion "1.0.0.0"                                                                                          ;文件版本
  VIAddVersionKey /LANG=2052 "ProductName" "${PRODUCT_NAME}"                                      ;产品描述
  VIAddVersionKey /LANG=2052 "Comments" "限免"                                                                        ;备注
  VIAddVersionKey /LANG=2052 "CompanyName" "航天信息软件技术有限公司"                                                 ;公司
  VIAddVersionKey /LANG=2052 "LegalTrademarks" "Aisino"                                                               ;合法商标
  VIAddVersionKey /LANG=2052 "LegalCopyright" "Aisino"                                                                ;版权
  VIAddVersionKey /LANG=2052 "FileDescription" "航天信息软件技术有限公司${PRODUCT_NAME}"          ;文件描述
  VIAddVersionKey /LANG=2052 "FileVersion" "1.0.0000"                                                                 ;文件版本
  viaddversionkey /LANG=2052 "InternalName" "a6_ls"                                                                  ;内部名称
  VIAddVersionKey /LANG=2052 "OriginalFilename" "Aisino-A6-common-formula-5.1"                                                   ;源文件名
  VIAddVersionKey /LANG=2052 "PrivateBulid" "20141129"                                                                ;privatebuild
  VIAddVersionKey /LANG=2052 "SpecialBuild" "20141129"                                                                ;特殊内部版本说明
  
;CreateDirectory "$SMPROGRAMS\My Company"
;CreateShortCut "$SMPROGRAMS\My Company\My Program.lnk" "$INSTDIR\My Program.exe" "some command line parameters" "$INSTDIR\My Program.exe" 2 SW_SHOWNORMAL ALT|CTRL|SHIFT|F5 "a description"
;为快捷方式添加参数

;InstallDirRegKey HKLM "SOFTWARE\aisino\A8"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}.exe"
ShowInstDetails nevershow
ShowUnInstDetails nevershow
DirText "安装向导将把 $PRODUCT_NAME安装在下列文件夹，如果要安装到其他文件夹请单击 [浏览(B)] 进行选择。"
BrandingText "航天信息软件技术有限公司"
Var SQLSERVER
Var PORT
Var SQLUSER
Var SQLPASSWORD
Var VERSION1
Var INS_PATH
Var SERVICE

Section "MainSection" SEC01
SetShellVarContext all
;带升级工具老版本6.0
  ReadRegStr $SQLSERVER HKLM 'SOFTWARE\Aisino\A6 2013' "IS_SQLSERVER_ADDRESS"
  ReadRegStr $PORT HKLM 'SOFTWARE\Aisino\A6 2013' "IS_SQLSERVER_PORT"
  ReadRegStr $SQLUSER HKLM 'SOFTWARE\Aisino\A6 2013' "IS_SQLSERVER_USERNAME"
  ReadRegStr $SQLPASSWORD HKLM 'SOFTWARE\Aisino\A6 2013' "IS_SQLSERVER_PASSWORD"
  ReadRegStr $INS_PATH HKLM 'SOFTWARE\Aisino\A6 2013' "INSTALL_PATH"
  ReadRegStr $0 HKLM 'SOFTWARE\Aisino\A6 2013' "VERSION"
  StrCpy $SERVICE AASA6
  DetailPrint "A6当前大版本: $0"
  StrCmp $0 "" 0 updateSql
  	DetailPrint "未检测到企业管理软件A6服务（带升级工具），将检测不带升级工具版本"
;不带升级工具版本
  ReadRegStr $SQLSERVER HKLM 'SOFTWARE\Aisino\A6 2008' "IS_SQLSERVER_ADDRESS"
  ReadRegStr $PORT HKLM 'SOFTWARE\Aisino\A6 2008' "IS_SQLSERVER_PORT"
  ReadRegStr $SQLUSER HKLM 'SOFTWARE\Aisino\A6 2008' "IS_SQLSERVER_USERNAME"
  ReadRegStr $SQLPASSWORD HKLM 'SOFTWARE\Aisino\A6 2008' "IS_SQLSERVER_PASSWORD"
  ReadRegStr $INS_PATH HKLM 'SOFTWARE\Aisino\A6 2008' "INSTALL_PATH"
  ReadRegStr $0 HKLM 'SOFTWARE\Aisino\A6 2008' "VERSION"
  StrCpy $SERVICE AAS
  DetailPrint "A6当前大版本: $0"
  StrCmp $0 "" 0 +3
  	MessageBox MB_OK "未检测到企业管理软件A6服务，将安装此临时补丁客户端版本"
    goto client
  updateSql:
  MSSQL_OLEDB::SQL_Logon "$SQLSERVER,$PORT" "$SQLUSER" "$SQLPASSWORD"
  pop $0
	detailprint $0
	pop $0
	detailprint $0
	MSSQL_OLEDB::SQL_GetError
	Pop $0
  DetailPrint $0
  Pop $0
  DetailPrint "acc_sys库状态SQL_GetError：$0"
  MSSQL_OLEDB::SQL_Execute "use acc_sys"
  MSSQL_OLEDB::SQL_Execute "select cWebVersion from versioninfo"
  MSSQL_OLEDB::SQL_GetRow
  Pop $0
  DetailPrint $0
  Pop $0
  StrCpy $VERSION1 $0
  DetailPrint "当前A6版本：$0"
  MSSQL_OLEDB::SQL_Logout
;比较版本
    ${VersionConvert}  "$VERSION1" "" $R0
    ${VersionConvert}  "A6 6.0.sp09" "" $R1
    ${VersionCompare}  $R0 $R1 $R2
  ${If} $R2 == 1
  DetailPrint '企业管理软件A6版本高于6.0.sp09，不符合安装条件'
    MessageBox MB_OK "对不起，该临时补丁只能安装在6.0.sp09，可能企业管理软件A6版本较高或没启动数据库服务，安装程序将退出。"
    quit
  ${ElseIf} $R2 == 2
  DetailPrint '企业管理软件A6版本低于6.0.sp09，不符合安装条件'
  	MessageBox MB_OK "对不起，企业管理软件A6版本较低，请升级到6.0.sp09版本，安装程序将退出。"
  	quit
  ${Else}
  DetailPrint '企业管理软件A6版本符合条件'
  ${EndIf}
  DetailPrint "A6安装目录: $INS_PATH"
  StrCpy $INSTDIR $INS_PATH
  SetOutPath "$INSTDIR"
  nsExec::Exec "cmd /c sc stop $SERVICE"
  SetOverwrite on
  Delete "$INSTDIR\web\ptrun.ini"
  File /r "A6ls\*.*"
;执行脚本
	MSSQL_OLEDB::SQL_Logon "$SQLSERVER,$PORT" "$SQLUSER" "$SQLPASSWORD"
	pop $0
	detailprint $0
	pop $0
	detailprint $0
	MSSQL_OLEDB::SQL_GetError
	Pop $0
	DetailPrint $0
	Pop $0
	DetailPrint $0

FileOpen $2 "$INSTDIR\allDB.ini" w

MSSQL_OLEDB::SQL_Execute "use acc_sys"
MSSQL_OLEDB::SQL_Execute "select DBNAME from accinfo"
DetailPrint "$0$\n获取查询结果，遍历所有账套DetailPrint"
MSSQL_OLEDB::SQL_GetRow
Pop $0
DetailPrint "Pop一次状态$0"
StrCmp $0 "2" +4 0
Pop $0
FileWrite $2 "use $0$\n"
Goto -6
DetailPrint "已获取所有用户账套"
FileClose $2
MSSQL_OLEDB::SQL_Logout
;MSQL_OLEDB每个安装程序只能定义一个，
;MSSQL_OLEDB::SQL_Logon后只能定义一次上下文
;如果要更新上下文，需要退出后重新登陆MSSQL_OLEDB::SQL_Logout
;sql脚本不能用GO提交，只能用;
FileOpen $2 "$INSTDIR\allDB.ini" r
DetailPrint "opened file"
FileRead $2 $1
DetailPrint $1
${while} $1 != ""
MSSQL_OLEDB::SQL_Logon "$SQLSERVER,$PORT" "$SQLUSER" "$SQLPASSWORD"
MSSQL_OLEDB::SQL_Execute "$1"
Pop $0
DetailPrint $0
Pop $0
DetailPrint $0
MSSQL_OLEDB::SQL_GetError
Pop $0
DetailPrint $0
Pop $0
DetailPrint $0

MSSQL_OLEDB::SQL_ExecuteScript "$INSTDIR\ReportUpdate.sql"
Pop $0
DetailPrint $0
Pop $0
DetailPrint $0
MSSQL_OLEDB::SQL_GetError
Pop $0
DetailPrint $0
Pop $0
DetailPrint $0
FileRead $2 $1
MSSQL_OLEDB::SQL_Logout
${endWhile}
FileClose $2
Delete $INSTDIR\ReportUpdate.sql
Delete $INSTDIR\allDB.ini
;新版本开票接口
  ReadRegStr $0 HKLM 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\fwkp.exe' "Path"
      StrCmp $0 "" 0 +2
    Goto OldFWSK
  DetailPrint "新版防伪开票系统安装路径: $0"
  SetOutPath "$INSTDIR"
  SetOverwrite on
  File /r /x RegAsm.exe /x regasm.exe.config "client_setup\kaipiao_new\*.*"
  SetOutPath "$0\BIN"
  SetOverwrite on
  File /r "client_setup\kaipiao_new\client_setup\KaiPiao\*.*"
  ExecWait 'RegAsm.exe "$0\Bin\SBAXCommon.dll" /codebase'
  Delete "$0\Bin\RegAsm.exe"
  Delete "$0\Bin\regasm.exe.config"
  RegDLL $0\BIN\RepFace.dll
  RegDLL $0\BIN\TaxOutPutInv.ocx
  Goto startAASA6
  OldFWSK:
	;注册老版本发票接口
  ReadRegStr $0 HKLM 'SOFTWARE\航天信息\防伪开票\路径' ""
    StrCmp $0 "" 0 +2
    Goto NoFWSK
    DetailPrint "老版本防伪开票系统安装路径: $0"
	 ;拷贝开票文件并注册
  SetOutPath "$0\bin"
  SetOverwrite on
  File /r "client_setup\kaipiao_old\client_setup\KaiPiao\*.*"
  
  RegDLL $0\bin\ASRepFace.dll
  RegDLL $0\bin\TaxOutPutInv.ocx
  Goto startAASA6
	NoFWSK:
     DetailPrint "未检测到防伪开票系统，跳过此部分的安装设置。"
	startAASA6:
  nsExec::Exec "cmd /c sc start $SERVICE"
	Goto 	ClientEnd
  client:
    ;新版本开票接口
  ReadRegStr $0 HKLM 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\fwkp.exe' "Path"
      StrCmp $0 "" 0 +2
    Goto OldclientFWSK
  DetailPrint "新版防伪开票系统安装路径: $0"
  SetOutPath "$0\BIN"
  SetOverwrite on
  File /r "client_setup\kaipiao_new\client_setup\KaiPiao\*.*"
  ExecWait 'RegAsm.exe "$0\Bin\SBAXCommon.dll" /codebase'
  Delete "$0\Bin\RegAsm.exe"
  Delete "$0\Bin\regasm.exe.config"
  RegDLL $0\BIN\RepFace.dll
  RegDLL $0\bin\TaxOutPutInv.ocx
  Goto ClientEnd
  OldclientFWSK:
    ReadRegStr $0 HKLM 'SOFTWARE\航天信息\防伪开票\路径' ""
    StrCmp $0 "" 0 +2
    Goto NoFWSKClient
    DetailPrint "防伪开票系统安装路径: $0"
	 ;拷贝开票文件并注册
  SetOutPath "$0\bin"
  SetOverwrite on
  File /r "client_setup\kaipiao_old\client_setup\KaiPiao\*.*"
  RegDLL $0\bin\ASRepFace.dll
  RegDLL $0\bin\TaxOutPutInv.ocx
	NoFWSKClient:
     DetailPrint "未检测到防伪开票系统，跳过此部分的安装设置。"
	ClientEnd:
  detailprint "已经完成所有安装操作。"
SectionEnd

;Section -AdditionalIcons
;	CreateDirectory "$SMPROGRAMS\航天信息 A6\业务日志统计工具"
;  CreateShortCut "$SMPROGRAMS\航天信息 A6\业务日志统计工具\卸载.lnk" "$INSTDIR\tools\uninst.exe"
;SectionEnd

;Section -Post
;WriteUninstaller "$INSTDIR\tools\uninst.exe"
;SectionEnd

;Section Uninstall
;  SetShellVarContext all
;  SetOutPath "$INSTDIR"
;  nsExec::Exec "cmd /c sc stop AASA6"

;  RMDir /r /REBOOTOK "$SMPROGRAMS\航天信息 A6\业务日志统计工具"
;  Delete /REBOOTOK "$INSTDIR\web\WEB-INF\lib\Aisino-A6-LOG-*.*"
;  Delete /REBOOTOK "$INSTDIR\web\updateScripts_a3\LOG\acc_sys_log.sql"
;  Delete /REBOOTOK "$INSTDIR\tools\uninst.exe"
;  nsExec::Exec "cmd /c sc start AASA6"
;  SetAutoClose true
;SectionEnd

;#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#
;Function .onInit
;FunctionEnd


;Function un.onInit
;  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确认要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
;  Abort
;FunctionEnd

;Function un.onUninstSuccess
;  HideWindow
;  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
;FunctionEnd

