; ============================================================
;  小笨蛋 1.0 安装包脚本（Inno Setup 6）
;  打包命令：
;    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" 安装包.iss
;  产物：dist\小笨蛋-Setup-1.0.exe
; ============================================================

#define MyAppName "小笨蛋"
#define MyAppVersion "1.2"
#define MyAppPublisher "Pei"
#define MyAppExeName "小笨蛋.exe"

[Setup]
; AppId 一旦发布就不要再改，否则升级时会被当成另一个程序
AppId={{7E1B93C2-4A5D-4F18-9B27-6D0C8E5A31F4}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={localappdata}\Programs\小笨蛋
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
; 装到 用户目录 而不是 Program Files —— 程序要在自己目录里写壁纸选择/语音缓存，
; 装进 Program Files 会因为没权限而写不进去。
PrivilegesRequired=lowest
OutputDir=dist
OutputBaseFilename=小笨蛋-Setup-{#MyAppVersion}
SetupIconFile=图标\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
ShowLanguageDialog=no
DisableWelcomePage=no

[Languages]
Name: "zh"; MessagesFile: "compiler:Default.isl"

[Messages]
; 界面汉化（Default.isl 是英文的，这里逐条覆盖）
SetupAppTitle=安装程序
SetupWindowTitle=安装 - %1
WelcomeLabel1=欢迎安装 [name]
WelcomeLabel2=这会把 [name] [ver] 装到你的电脑上。%n%n装完桌面会有图标，双击就能聊天。不想要了在「设置 → 应用」里卸载即可。%n%n建议先关掉杀毒软件的实时防护，PyInstaller 打的包偶尔会被误报。
WizardSelectDir=选择安装位置
SelectDirDesc=小笨蛋要装到哪儿？
SelectDirLabel3=安装程序会把 [name] 装进下面这个文件夹。
SelectDirBrowseLabel=点「浏览」可以换一个位置；直接点「下一步」就用默认的。
WizardReady=准备安装
ReadyLabel1=现在开始安装 [name]。
ReadyLabel2a=点「安装」开始；想改点什么就点「上一步」。
ReadyLabel2b=点「安装」开始。
WizardInstalling=正在安装
InstallingLabel=正在把文件复制到你的电脑上，请稍等……
FinishedHeadingLabel=[name] 装好了
FinishedLabel=桌面和开始菜单里都有「小笨蛋」，双击就能聊。%n%n第一次用想让她更会说话：打开程序文件夹里的 API.txt，把 DeepSeek 的钥匙填进去（README 里有步骤）。
FinishedLabelNoIcons=开始菜单里能找到「小笨蛋」。
ClickNext=下一步(&N) >
ClickFinish=完成(&F)
ButtonNext=下一步(&N) >
ButtonBack=< 上一步(&B)
ButtonInstall=安装(&I)
ButtonFinish=完成(&F)
ButtonCancel=取消
ButtonBrowse=浏览(&R)…
ButtonYes=是(&Y)
ButtonNo=否(&N)
ExitSetupTitle=退出安装
ExitSetupMessage=还没装完，确定要退出吗？%n%n下次要装的话，重新运行这个安装包就行。
ConfirmUninstall=确定要卸载 [name] 吗？%n%n程序、壁纸、表情都会删掉；你自己改过的人设和 API.txt 也会一起删。
UninstalledAll=[name] 已经卸载干净了。
UninstalledMost=卸载完成。%n%n有些文件没删掉（可能还被占用），你可以手动删除：%1
StatusExtractFiles=正在解压文件……
StatusCreateIcons=正在创建快捷方式……
StatusRollback=正在回滚……
SetupAppRunningError=「[name]」还在运行，请先关掉它，再点「确定」继续。
UninstallAppRunningError=「[name]」还在运行，请先关掉它，再点「确定」继续。

[Tasks]
Name: "desktopicon"; Description: "在桌面创建快捷方式"; GroupDescription: "附加任务："

[Files]
Source: "dist\小笨蛋\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; 快捷方式图标跟着系统深浅色走：Check 决定装哪一条（同名条目只会生效一条）
Name: "{group}\小笨蛋"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
Name: "{group}\使用说明"; Filename: "{app}\使用说明.txt"
Name: "{group}\卸载 小笨蛋"; Filename: "{uninstallexe}"
Name: "{autodesktop}\小笨蛋"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"; Tasks: desktopicon

[UninstallDelete]
; 程序运行后会自己生成这些，Inno 不知道，卸载时顺手清掉
Type: filesandordirs; Name: "{app}\语音缓存"
Type: files; Name: "{app}\壁纸选择.txt"
Type: files; Name: "{app}\待补语料.txt"
Type: filesandordirs; Name: "{app}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "现在打开 小笨蛋"; WorkingDir: "{app}"; Flags: nowait postinstall skipifsilent
