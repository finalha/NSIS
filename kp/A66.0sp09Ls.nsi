; �ýű�ʹ�� HM VNISEdit �ű��༭���򵼲���

; ��װ�����ʼ���峣��
!define PRODUCT_NAME "A6 V6.0SP09֧�������濪Ʊ��ʱ������"
!define PRODUCT_NAME_TXT "A6 V6.0SP09֧�������濪Ʊ��ʱ������"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "������Ϣ����������޹�˾"
!define PRODUCT_WEB_SITE "http://soft.aisino.com/"
;ÿ�η��²����������������VIP1.0����!define PRODUCT_UDPATE_SCRIPTS_PATH "web\updateScripts\mssql\VIP"
;!define PRODUCT_UDPATE_SCRIPTS_PATH "web\updateScripts\mssql\VIP"

SetCompressor /solid lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"
!include "OLEDB.NSH"
!include "XML.nsh"
!include "WordFunc.nsh"
!include "LogicLib.nsh"
; MUI Ԥ���峣��
;!define MUI_WELCOMEPAGE_TEXT "\r\n ���ԭ���򣬱���װ����Ҫ������������ǿ\n		$_CLICK"
!define MUI_WELCOMEPAGE_TITLE "��ӭʹ�� ${PRODUCT_NAME_TXT} ��װ��"
!define MUI_WELCOMEPAGE_TEXT "����򵼽�ָ������� ${PRODUCT_NAME_TXT} �İ�װ��\r\n\
��ʹ��ǰ�������ȹر���������Ӧ�ó����⽫�������ָ����ϵͳ�ļ���������Ҫ����������ļ������\r\n\
����[��һ��(N) >]������"
!define MUI_WELCOMEFINISHPAGE_BITMAP "left.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "left.bmp"
!define MUI_PAGE_HEADER_TEXT "�����û����Э��"
!define MUI_PAGE_HEADER_SUBTEXT "��������ܴ�Э����ܼ���ʹ��"
!define MUI_LICENSEPAGE_TEXT_TOP "Ҫ�Ķ�Э������ಿ����������ק��������"
!define MUI_LICENSEPAGE_TEXT_BOTTOM "������Ѿ���ϸ�Ķ������Э�飬��� ��һ��(N) > ��"
Caption "${PRODUCT_NAME} ${PRODUCT_VERSION}"
;!define MUI_HEADER_TEXT "${PRODUCT_NAME} ${PRODUCT_VERSION}"
!define MUI_LICENSEPAGE_BUTTON "��һ��(N) >"
!define MUI_INSTFILESPAGE_FINISHHEADER_TEXT "��װ���"
!define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT ""
!define MUI_FINISHPAGE_TITLE "����� ${PRODUCT_NAME_TXT} ��װ"
!define MUI_FINISHPAGE_TEXT "�����${PRODUCT_NAME}��װ�����ʹ�ú��Բ��ܽ�����⣬�뽫�����ύ֧��ϵͳ��"
!define MUI_ABORTWARNING
!define MUI_ICON "A6.ico"
;!define MUI_FINISHPAGE_NOAUTOCLOSE
; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
!insertmacro MUI_PAGE_LICENSE "license.txt"
; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!insertmacro MUI_PAGE_FINISH

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------
;�ļ��汾����
  VIProductVersion "1.0.0.0"                                                                                          ;�ļ��汾
  VIAddVersionKey /LANG=2052 "ProductName" "${PRODUCT_NAME}"                                      ;��Ʒ����
  VIAddVersionKey /LANG=2052 "Comments" "����"                                                                        ;��ע
  VIAddVersionKey /LANG=2052 "CompanyName" "������Ϣ����������޹�˾"                                                 ;��˾
  VIAddVersionKey /LANG=2052 "LegalTrademarks" "Aisino"                                                               ;�Ϸ��̱�
  VIAddVersionKey /LANG=2052 "LegalCopyright" "Aisino"                                                                ;��Ȩ
  VIAddVersionKey /LANG=2052 "FileDescription" "������Ϣ����������޹�˾${PRODUCT_NAME}"          ;�ļ�����
  VIAddVersionKey /LANG=2052 "FileVersion" "1.0.0000"                                                                 ;�ļ��汾
  viaddversionkey /LANG=2052 "InternalName" "a6_ls"                                                                  ;�ڲ�����
  VIAddVersionKey /LANG=2052 "OriginalFilename" "Aisino-A6-common-formula-5.1"                                                   ;Դ�ļ���
  VIAddVersionKey /LANG=2052 "PrivateBulid" "20141129"                                                                ;privatebuild
  VIAddVersionKey /LANG=2052 "SpecialBuild" "20141129"                                                                ;�����ڲ��汾˵��
  
;CreateDirectory "$SMPROGRAMS\My Company"
;CreateShortCut "$SMPROGRAMS\My Company\My Program.lnk" "$INSTDIR\My Program.exe" "some command line parameters" "$INSTDIR\My Program.exe" 2 SW_SHOWNORMAL ALT|CTRL|SHIFT|F5 "a description"
;Ϊ��ݷ�ʽ��Ӳ���

;InstallDirRegKey HKLM "SOFTWARE\aisino\A8"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}.exe"
ShowInstDetails nevershow
ShowUnInstDetails nevershow
DirText "��װ�򵼽��� $PRODUCT_NAME��װ�������ļ��У����Ҫ��װ�������ļ����뵥�� [���(B)] ����ѡ��"
BrandingText "������Ϣ����������޹�˾"
Var SQLSERVER
Var PORT
Var SQLUSER
Var SQLPASSWORD
Var VERSION1
Var INS_PATH
Var SERVICE

Section "MainSection" SEC01
SetShellVarContext all
;�����������ϰ汾6.0
  ReadRegStr $SQLSERVER HKLM 'SOFTWARE\Aisino\A6 2013' "IS_SQLSERVER_ADDRESS"
  ReadRegStr $PORT HKLM 'SOFTWARE\Aisino\A6 2013' "IS_SQLSERVER_PORT"
  ReadRegStr $SQLUSER HKLM 'SOFTWARE\Aisino\A6 2013' "IS_SQLSERVER_USERNAME"
  ReadRegStr $SQLPASSWORD HKLM 'SOFTWARE\Aisino\A6 2013' "IS_SQLSERVER_PASSWORD"
  ReadRegStr $INS_PATH HKLM 'SOFTWARE\Aisino\A6 2013' "INSTALL_PATH"
  ReadRegStr $0 HKLM 'SOFTWARE\Aisino\A6 2013' "VERSION"
  StrCpy $SERVICE AASA6
  DetailPrint "A6��ǰ��汾: $0"
  StrCmp $0 "" 0 updateSql
  	DetailPrint "δ��⵽��ҵ�������A6���񣨴��������ߣ�������ⲻ���������߰汾"
;�����������߰汾
  ReadRegStr $SQLSERVER HKLM 'SOFTWARE\Aisino\A6 2008' "IS_SQLSERVER_ADDRESS"
  ReadRegStr $PORT HKLM 'SOFTWARE\Aisino\A6 2008' "IS_SQLSERVER_PORT"
  ReadRegStr $SQLUSER HKLM 'SOFTWARE\Aisino\A6 2008' "IS_SQLSERVER_USERNAME"
  ReadRegStr $SQLPASSWORD HKLM 'SOFTWARE\Aisino\A6 2008' "IS_SQLSERVER_PASSWORD"
  ReadRegStr $INS_PATH HKLM 'SOFTWARE\Aisino\A6 2008' "INSTALL_PATH"
  ReadRegStr $0 HKLM 'SOFTWARE\Aisino\A6 2008' "VERSION"
  StrCpy $SERVICE AAS
  DetailPrint "A6��ǰ��汾: $0"
  StrCmp $0 "" 0 +3
  	MessageBox MB_OK "δ��⵽��ҵ�������A6���񣬽���װ����ʱ�����ͻ��˰汾"
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
  DetailPrint "acc_sys��״̬SQL_GetError��$0"
  MSSQL_OLEDB::SQL_Execute "use acc_sys"
  MSSQL_OLEDB::SQL_Execute "select cWebVersion from versioninfo"
  MSSQL_OLEDB::SQL_GetRow
  Pop $0
  DetailPrint $0
  Pop $0
  StrCpy $VERSION1 $0
  DetailPrint "��ǰA6�汾��$0"
  MSSQL_OLEDB::SQL_Logout
;�Ƚϰ汾
    ${VersionConvert}  "$VERSION1" "" $R0
    ${VersionConvert}  "A6 6.0.sp09" "" $R1
    ${VersionCompare}  $R0 $R1 $R2
  ${If} $R2 == 1
  DetailPrint '��ҵ�������A6�汾����6.0.sp09�������ϰ�װ����'
    MessageBox MB_OK "�Բ��𣬸���ʱ����ֻ�ܰ�װ��6.0.sp09��������ҵ�������A6�汾�ϸ߻�û�������ݿ���񣬰�װ�����˳���"
    quit
  ${ElseIf} $R2 == 2
  DetailPrint '��ҵ�������A6�汾����6.0.sp09�������ϰ�װ����'
  	MessageBox MB_OK "�Բ�����ҵ�������A6�汾�ϵͣ���������6.0.sp09�汾����װ�����˳���"
  	quit
  ${Else}
  DetailPrint '��ҵ�������A6�汾��������'
  ${EndIf}
  DetailPrint "A6��װĿ¼: $INS_PATH"
  StrCpy $INSTDIR $INS_PATH
  SetOutPath "$INSTDIR"
  nsExec::Exec "cmd /c sc stop $SERVICE"
  SetOverwrite on
  Delete "$INSTDIR\web\ptrun.ini"
  File /r "A6ls\*.*"
;ִ�нű�
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
DetailPrint "$0$\n��ȡ��ѯ�����������������DetailPrint"
MSSQL_OLEDB::SQL_GetRow
Pop $0
DetailPrint "Popһ��״̬$0"
StrCmp $0 "2" +4 0
Pop $0
FileWrite $2 "use $0$\n"
Goto -6
DetailPrint "�ѻ�ȡ�����û�����"
FileClose $2
MSSQL_OLEDB::SQL_Logout
;MSQL_OLEDBÿ����װ����ֻ�ܶ���һ����
;MSSQL_OLEDB::SQL_Logon��ֻ�ܶ���һ��������
;���Ҫ���������ģ���Ҫ�˳������µ�½MSSQL_OLEDB::SQL_Logout
;sql�ű�������GO�ύ��ֻ����;
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
;�°汾��Ʊ�ӿ�
  ReadRegStr $0 HKLM 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\fwkp.exe' "Path"
      StrCmp $0 "" 0 +2
    Goto OldFWSK
  DetailPrint "�°��α��Ʊϵͳ��װ·��: $0"
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
	;ע���ϰ汾��Ʊ�ӿ�
  ReadRegStr $0 HKLM 'SOFTWARE\������Ϣ\��α��Ʊ\·��' ""
    StrCmp $0 "" 0 +2
    Goto NoFWSK
    DetailPrint "�ϰ汾��α��Ʊϵͳ��װ·��: $0"
	 ;������Ʊ�ļ���ע��
  SetOutPath "$0\bin"
  SetOverwrite on
  File /r "client_setup\kaipiao_old\client_setup\KaiPiao\*.*"
  
  RegDLL $0\bin\ASRepFace.dll
  RegDLL $0\bin\TaxOutPutInv.ocx
  Goto startAASA6
	NoFWSK:
     DetailPrint "δ��⵽��α��Ʊϵͳ�������˲��ֵİ�װ���á�"
	startAASA6:
  nsExec::Exec "cmd /c sc start $SERVICE"
	Goto 	ClientEnd
  client:
    ;�°汾��Ʊ�ӿ�
  ReadRegStr $0 HKLM 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\fwkp.exe' "Path"
      StrCmp $0 "" 0 +2
    Goto OldclientFWSK
  DetailPrint "�°��α��Ʊϵͳ��װ·��: $0"
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
    ReadRegStr $0 HKLM 'SOFTWARE\������Ϣ\��α��Ʊ\·��' ""
    StrCmp $0 "" 0 +2
    Goto NoFWSKClient
    DetailPrint "��α��Ʊϵͳ��װ·��: $0"
	 ;������Ʊ�ļ���ע��
  SetOutPath "$0\bin"
  SetOverwrite on
  File /r "client_setup\kaipiao_old\client_setup\KaiPiao\*.*"
  RegDLL $0\bin\ASRepFace.dll
  RegDLL $0\bin\TaxOutPutInv.ocx
	NoFWSKClient:
     DetailPrint "δ��⵽��α��Ʊϵͳ�������˲��ֵİ�װ���á�"
	ClientEnd:
  detailprint "�Ѿ�������а�װ������"
SectionEnd

;Section -AdditionalIcons
;	CreateDirectory "$SMPROGRAMS\������Ϣ A6\ҵ����־ͳ�ƹ���"
;  CreateShortCut "$SMPROGRAMS\������Ϣ A6\ҵ����־ͳ�ƹ���\ж��.lnk" "$INSTDIR\tools\uninst.exe"
;SectionEnd

;Section -Post
;WriteUninstaller "$INSTDIR\tools\uninst.exe"
;SectionEnd

;Section Uninstall
;  SetShellVarContext all
;  SetOutPath "$INSTDIR"
;  nsExec::Exec "cmd /c sc stop AASA6"

;  RMDir /r /REBOOTOK "$SMPROGRAMS\������Ϣ A6\ҵ����־ͳ�ƹ���"
;  Delete /REBOOTOK "$INSTDIR\web\WEB-INF\lib\Aisino-A6-LOG-*.*"
;  Delete /REBOOTOK "$INSTDIR\web\updateScripts_a3\LOG\acc_sys_log.sql"
;  Delete /REBOOTOK "$INSTDIR\tools\uninst.exe"
;  nsExec::Exec "cmd /c sc start AASA6"
;  SetAutoClose true
;SectionEnd

;#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#
;Function .onInit
;FunctionEnd


;Function un.onInit
;  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷ��Ҫ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
;  Abort
;FunctionEnd

;Function un.onUninstSuccess
;  HideWindow
;  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
;FunctionEnd

