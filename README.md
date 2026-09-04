# usbi.sh -> Excel 清单与双版本安装包工具

## 目录结构

- `src\usbi_xlsx_gui.py`：Python 源代码（可视化界面和命令行功能）。
- `test\`：测试输入文件和测试模板；不会被工具自动清理。
- `工作簿1.xlsx`：旧模板/参考样式文件；当前程序默认使用内置自动样式，不依赖这个文件。
- `dist\`：打包后的 EXE 文件。
- `build\`：PyInstaller 构建缓存。

## 启动

双击 `run_usbi_xlsx_gui.bat`，或执行：

```powershell
python .\src\usbi_xlsx_gui.py
```

## 双版本安装包（当前主要功能）

1. 选择“安装包版本 usbi.sh”（必选，基于点检表或真实需求打包的版本）。
2. 如果需要安装包，再选择“点检表版本 usbi.sh”（可选）。
3. 选择输出目录；默认使用安装包版本所在目录。
4. 默认使用程序内置自动样式生成 XLSX，不依赖本地 `工作簿1.xlsx`；如有特殊模板，也可以手动选择其他 `.xlsx` 文件。
5. 分别填写版本号；留空时会从文件所在目录名自动识别，例如 `_20260813-4C85ACF3H-V1.0` 会识别为 `V1.0`。
6. 点击“开始解压、计算 MD5 并生成/安装包”。
7. 生成成功后，点击“打开生成的 XLSX”。

如果选择了点检表版本，生成的一个 XLSX 包含三个工作表：

- `点检表版本`：点检表 usbi.sh 解压后的文件名、版本号、路径和 MD5。
- `安装包版本`：安装包 usbi.sh 解压后的文件名、版本号、路径和 MD5。
- `安装包结果`：按“新增”“缺少”“差异”三个区域列出安装包结果。
  - **新增**：安装包版本存在、点检表版本不存在的文件；显示安装包 MD5。
  - **缺少**：点检表版本存在、安装包版本不存在的文件；显示点检表 MD5。
  - **差异**：两个版本文件名和路径相同，但 MD5 不同的文件；同时显示点检表 MD5 和安装包 MD5。

文件通过“路径 + 文件名”匹配，路径分隔符 `/` 和 `\` 会统一处理，大小写差异不会被误判为新增或缺少。安装包结果工作表使用蓝色表示新增、黄色表示缺少、红色表示差异。清单工作表会按文件路径自动切换绿色/黄色底纹：同一路径保持同色，路径变化时切换底色。

## 单版本清单

如果只需要解析一个 usbi.sh，只选择“安装包版本 usbi.sh”并留空点检表版本即可。单版本模式会生成一个包含文件名、版本号、路径、MD5 和备注的工作表。

工具会识别 Shell 自解压文件中的 bzip2/gzip/zip 数据，解压内部 TAR/ZIP，逐个计算 MD5，并生成清单。默认样式由程序自动生成，输出内容始终来自本次解压结果。路径底纹按压缩包内部相对路径自动切换。

处理完成后默认删除本次生成的临时解压目录，只保留 Excel 清单和输入文件。勾选“保留临时解压目录”或使用 `--keep` 可保留目录以便检查；不会自动删除输入的 usbi.sh、模板或旧 Excel 文件。取消“包含 checksums.txt 和 .gitkeep”或使用 `--no-metadata` 可跳过这些元数据文件。

## 命令行

`--compare-input` 是必选项；`--input` 是可选点检表，提供后才会执行双版本安装包。

双版本安装包：

```powershell
python .\src\usbi_xlsx_gui.py --input "D:\path\baseline_usbi.sh" --compare-input "D:\path\real_usbi.sh" --output-dir "D:\output" --version V1.0 --compare-version V1.1
```

单版本清单：

```powershell
python .\src\usbi_xlsx_gui.py --compare-input "D:\path\usbi.sh" --output-dir "D:\output" --compare-version V1.0
```

保留解压目录（默认会自动删除）：

```powershell
python .\src\usbi_xlsx_gui.py --input "D:\path\baseline_usbi.sh" --compare-input "D:\path\real_usbi.sh" --keep
```

`--no-keep` 仍然保留，用于兼容旧命令；不传 `--keep` 时默认清理临时解压目录。

不写入 `checksums.txt` 和 `.gitkeep`：

```powershell
python .\src\usbi_xlsx_gui.py --input "D:\path\baseline_usbi.sh" --compare-input "D:\path\real_usbi.sh" --no-metadata
```

依赖：Python 3.10+、openpyxl。安装依赖：

```powershell
python -m pip install -r .\requirements-usbi-xlsx.txt
```

编译exe步骤
```powershell
python.exe -m pip install -r .\requirements-usbi-xlsx.txt

python.exe -m py_compile .\src\usbi_xlsx_gui.py

python.exe -m PyInstaller .\usbi_xlsx_tool.spec --clean --noconfirm

python.exe -m PyInstaller .\usbi_xlsx_tool_console.spec --clean --noconfirm




cd C:\Users\long\Documents\code
python.exe -m py_compile .\src\usbi_xlsx_gui.py
python.exe -m PyInstaller .\usbi_xlsx_tool.spec --clean --noconfirm --noupx --debug
python.exe -m PyInstaller .\usbi_xlsx_tool_console.spec --clean --noconfirm --noupx --debug
```