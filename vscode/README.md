## VS Code 学习 Python 脚本编程 IDE环境配置

![VScode.jpg][1]

## 安装好 VS Code 默认是英文，首先安装中文语言包
- `Ctrl+Shiht+X` 打开 扩展插件安装 输入 `Chinese` 搜索， 选择 `Chinese (Simplified) Language Pack` 安装后 VS Code 就能支持中文了
- 适用于 VS Code 的中文（简体）语言包，此中文（简体）语言包为 VS Code 提供本地化界面。
- 使用方法

通过使用“配置显示语言”命令显式设置 VS Code 显示语言，可以替代默认 UI 语言。 按 "Ctrl+Shift+P" 以显示“命令面板”，然后开始键入 "display" 以筛选和显示“配置显示语言”命令。按 "Enter"，然后会按区域设置显示安装的语言列表，并突出显示当前语言设置。选择另一个“语言”以切换 UI 语言。 请参阅文档并获取更多信息。

## 安装 Python 编程语言扩展包
- 打开 扩展插件安装面板，搜索 `@recommended:languages` 或者 `Python` ，安装 `Python extension for Visual Studio Code`

- Python扩展为Visual Studio代码
在Visual Studio代码扩展与Python语言丰富支持（对于语言的所有积极支持的版本：> = 3.6），包括特征，例如智能感知（Pylance），掉毛，调试，代码导航，代码格式，重构，变量资源管理器，测试资源管理，以及更多！

- 安装的扩展

Python的扩展将自动安装Pylance和Jupyter扩展与Python文件和Jupyter笔记本电脑工作时，给你最好的体验。但是，Pylance 是一个可选的依赖项，这意味着如果安装失败，Python 扩展将保持完整功能。您还可以卸载它在某些功能为代价的，如果您使用的是不同的语言服务器。

- 快速开始

第1步：您的系统上安装Python支持的版本（注：不支持，该系统在Mac OS的Python的安装）。
第2步：安装Python扩展为Visual Studio代码。
第3步：打开或创建一个Python文件，并开始编码！

![welcome.png][2]

## 安装 `Code Runner` 文件栏，增加运行△图标，方便运行
- 代码运行器

运行多种语言的代码片段或代码文件：C、C++、Java、JavaScript、PHP、Python、Perl、Perl 6、Ruby、Go、Lua、Groovy、PowerShell、BAT/CMD、BASH/SH、F# Script、F#（ .NET Core)、C# 脚本、C# (.NET Core)、VBScript、TypeScript、CoffeeScript、Scala、Swift、Julia、Crystal、OCaml Script、R、AppleScript、Elixir、Visual Basic .NET、Clojure、Haxe、Objective-C , Rust, Racket, Scheme, AutoHotkey, AutoIt, Kotlin, Dart, Free Pascal, Haskell, Nim, D, Lisp, Kit, V, SCSS, Sass, CUDA, Less, Fortran, 和自定义命令

## VS Code 【查看】->【外观】->【面板】主要快键
![kk.png][3]
- 切换底下输出和终端面板 `Ctrl+J` ; 切换侧栏 `Ctrl+B` ;放大缩小 `Ctrl+=` ;其他见图

## Python 代码格式化 快捷键 `Shift+Alt+F` ，可选 `yapf` 和 `autopep8`
- 如果没有指定帮你安装 `yapf` 或者 `autopep8` 可以按下面命令安装
```
pip install yapf autopep8
```
![pyformat.png][4]
- 【设置】 搜索 `python.formatting.provider` ，选择代码样式工具

### 【面板】终端显示 `宋体点阵字` 设置: 修改
![tm.png][5]
- 【设置】 搜索 `terminal.integrated.fontFamily` 修改成 "宋体"，或者修改配置文件
```
// VS Code settings.json
{
    "code-runner.executorMap": {
        "php": "php",
        "python": "set PYTHONIOENCODING=utf8  && python -u",
    },
    "editor.fontFamily": "'Fixedsys Excelsior 3.01',Consolas, 'Courier New', monospace",
    "editor.fontSize": 16,
    "terminal.integrated.defaultProfile.windows": "PowerShell",
    "terminal.integrated.fontFamily": "宋体",
    "editor.lineHeight": 16
}
```
## 字体使用 Fixedsys ，字体大小16px
- Fixedsys Excelsior 3.01 [字体下载](https://github.com/hongwenjun/pillow_font/raw/main/ttf/fixedsys_excelsior.ttf)
```
"editor.fontFamily": "'Fixedsys Excelsior 3.01',Consolas, 'Courier New', monospace"
```
  [1]: https://262235.xyz/usr/uploads/2021/08/3627711294.jpg
  [2]: https://262235.xyz/usr/uploads/2021/08/233973932.png
  [3]: https://262235.xyz/usr/uploads/2021/08/3090452545.png
  [4]: https://262235.xyz/usr/uploads/2021/08/1749171291.png
  [5]: https://262235.xyz/usr/uploads/2021/08/1974051124.png



## VSCode RunCode Python 输出中文乱码解决方案

![code-run.png](https://262235.xyz/usr/uploads/2021/08/2938074038.png)
### 设置搜索 `code-runner.executorMap` ; 在 `settings.json` 中编辑

        "python": "set PYTHONIOENCODING=utf8  && python -u",

修改其后方字典中"python"冒号后面的值为：“set PYTHONIOENCODING=utf8 && python”，直接复制粘贴引号及引号之间的内容粘贴到原文的冒号后面就行，如图，同样也可以修改其他脚本源于的命令行：

![22.png](https://262235.xyz/usr/uploads/2021/08/2097796441.png)
