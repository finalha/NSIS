; �ýű�ʹ�� HM VNISEdit �ű��༭���򵼲���

; ��װ�����ʼ���峣��
!define PRODUCT_NAME "AisinoA0���߰�"
!define PRODUCT_VERSION "1.0.0000"
!define PRODUCT_PUBLISHER "������Ϣ����������޹�˾"
!define PRODUCT_WEB_SITE "http://soft.aisino.com/"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_TRUST_SITE_KEY "Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\Range99"
;Internet ����
;!define PRODUCT_INTERNET_ACTIVEX_KEY "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
;����վ������
!define PRODUCT_TRUST_ACTIVEX_KEY "Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2"
!define PRODUCT_TRUST_SITE_ROOT_KEY "HKCU"
!define PRODUCT_INSTALL_KEY "SOFTWARE\AisinoA0"

SetCompressor /solid lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"
!include "XML.nsh"
!include "WordFunc.nsh"
!include "Registry.nsh"
!include "WinVer.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "A0online.ico"
!define MUI_UNICON "A0unload.ico"
; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
!insertmacro MUI_PAGE_LICENSE "Online\license.txt"
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\tools\README.txt"
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

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
  	DetailPrint "δ��װAisinoA0�����԰�װ��"
		Goto start
    ${Else}
    ;�����ﻹ��Ҫ���ϰ汾�ж�
    ${If} $R3 == ""
    DetailPrint "AisinoA0�汾��Ϊ�գ���װ�����˳�"
    Quit
    ${Else}
    ${VersionConvert} "$R2" "" $R4
    ${VersionConvert} "${PRODUCT_VERSION}" "" $R5
    ${VersionCompare}  "$R5" "$R4" $R6
    ;MessageBox MB_OK '���ذ汾"$R4";�����汾"$R5";�жϽ��"$R6"'
		${If} $R6 == "0"
		Goto success
		${ElseIf} $R6 == "1"
		Goto success
		${Else}
		MessageBox MB_OK "�Ѿ���װ��AisinoA0�����Ұ汾�ȵ�ǰ��װ�İ汾���ߣ��������°�װ������밲װ�Ͱ汾����ж�غ����°�װ"
    Quit
		${EndIf}
		success:
		;������������ж��Ƿ�װ��A0������ǾͲ�ɾdb���ٴΰ�װ��ʱ��Ҳ������db
		StrCpy $R9 "1"
    MessageBox MB_YESNO "�Ѿ���װ��AisinoA0��������װ�������ϴΰ�װ,Ҫ������" IDYES true IDNO false
	  true:
    StrCmp $R0 $INSTDIR 0 +2
    Goto next
		;��db�ļ��п�����ȥ
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
  Delete "$DESKTOP\A0���ɹ���.lnk"
  RMDir "$SMPROGRAMS\AisinoA0"
	;ɾ������db֮����ļ���
  SetOutPath "$R0"
  RMDir /r "$R0\bin"
  RMDir /r "$R0\container"
  RMDir /r "$R0\tools"
  ;���ﻹ����ɾ��ע�����Ϣ����Ȼ�޷��ж����ݿ��������ĸ��汾
  ;DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  ;DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_INSTALL_KEY}"
  SetAutoClose true
	start:
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  ;������������ж��Ƿ�װ��A0������ǾͲ�ɾdb���ٴΰ�װ��ʱ��Ҳ������db
	${If} $R9 == "1"
  File /r /x "db" "Online\*.*"
  ;����С�ε���������
	ExecWait '"$INSTDIR\tools\A0UpdateProgram.exe"'
  ${Else}
  File /r "Online\*.*"
  ${EndIf}
  ;��ǰA0��װ������win2000����Ҫgdiplus.dll�ļ��ŵ�ϵͳ�̰�װӲ����
  ${If} ${IsWin2000}
  CopyFiles /SILENT $INSTDIR\tools\gdiplus.dll $WINDIR\system32
  ${EndIf}
SectionEnd

Section -AdditionalIcons
	WriteIniStr "$INSTDIR\bin\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "http://127.0.0.1:8800/A0/pt/canvas?formid=a0login&shellsize=max"
	WriteIniStr "$INSTDIR\bin\${PRODUCT_NAME}.url" "InternetShortcut" "IconFile" "$INSTDIR\bin\LOGO.ico"
	WriteIniStr "$INSTDIR\bin\${PRODUCT_NAME}.url" "InternetShortcut" "IconIndex" "0"

	NSISdl::download /TIMEOUT=3000 "http://211.94.145.64:8889/A6/A0container.rar" "A0container.rar"
		Pop $R0 ;��ȡ����ֵ
  	StrCmp $R0 "success" +2
    NSISdl::download /TIMEOUT=3000 "http://192.168.4.28:8889/A6/A0container.rar" "A0container.rar"


	;MessageBox MB_OK "$INSTDIR\tools\unrar.exe x -y $INSTDIR\A0container.rar $INSTDIR"
	ExecWait '"$INSTDIR\tools\UnRAR.exe" x -y $INSTDIR\A0container.rar $INSTDIR'
	Delete $INSTDIR\A0container.rar

  SetOutPath "$INSTDIR\container\bin"
  Call UpdateTomcatConfig
	nsExec::Exec "cmd /C service install AisinoA0"
  CreateDirectory "$SMPROGRAMS\AisinoA0"
  CreateShortCut "$DESKTOP\A0���ɹ���.lnk" "$INSTDIR\bin\${PRODUCT_NAME}.url" "" "$INSTDIR\bin\LOGO.ico"
  CreateShortCut "$SMPROGRAMS\AisinoA0\A0���ɹ���.lnk" "$INSTDIR\bin\${PRODUCT_NAME}.url" "" "$INSTDIR\bin\LOGO.ico"
  CreateShortCut "$SMPROGRAMS\AisinoA0\ж��A0.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  ;��127.0.0.1�������վ��
  WriteRegStr ${PRODUCT_TRUST_SITE_ROOT_KEY} "${PRODUCT_TRUST_SITE_KEY}" ":Range" "127.0.0.1"
  WriteRegDWORD ${PRODUCT_TRUST_SITE_ROOT_KEY} "${PRODUCT_TRUST_SITE_KEY}" "http" "0x00000002"
  ;����װ·���Ͱ汾��д��ע�������װ·�����ж��Ƿ��Ѿ���װ�����汾�����ж��Ƿ�����
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_INSTALL_KEY}" "INSTALL_PATH" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_INSTALL_KEY}" "VERSION" "${PRODUCT_VERSION}"
  ;��Internet ���򣬶�δ���Ϊ�ɰ�ȫִ�нű���Activex�ؼ���ʼ����ִ�нű���0-���� 3-����(Ĭ��) 1-��ʾ ����Ϊ��ʾ
  ;WriteRegDWORD ${PRODUCT_TRUST_SITE_ROOT_KEY} "${PRODUCT_INTERNET_ACTIVEX_KEY}" "1201" "0x00000000"
  ;�ڿ���վ�����򣬶�δ���Ϊ�ɰ�ȫִ�нű���Activex�ؼ���ʼ����ִ�нű���0-���� 3-����(Ĭ��) 1-��ʾ ����Ϊ��ʾ
  WriteRegDWORD ${PRODUCT_TRUST_SITE_ROOT_KEY} "${PRODUCT_TRUST_ACTIVEX_KEY}" "1201" "0x00000000"
SectionEnd

/******************************
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/

Section Uninstall
  SetShellVarContext all
  SetOutPath "$INSTDIR\container\bin"
	nsExec::Exec "cmd /C service remove AisinoA0"

  Delete "$SMPROGRAMS\AisinoA0\*.*"
  Delete "$DESKTOP\A0���ɹ���.lnk"
  RMDir "$SMPROGRAMS\AisinoA0"

  SetOutPath "$INSTDIR"
  ;������������޷���ȫɾ��
  SetOutPath "$SMPROGRAMS"
  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_INSTALL_KEY}"
  SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#
Function .onInit

FunctionEnd


Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
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
