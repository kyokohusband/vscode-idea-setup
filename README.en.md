# VSCode → IntelliJ IDEA-style Setup

> Language: [English](README.en.md) · [中文](README.md)

A configuration that makes VSCode feel close to IntelliJ IDEA: theme, icons, keybindings, syntax colors, editor behavior, and project view are all aligned.

The setup was tuned on a local VSCode install between 2026-10-29 and 10-31 in six batches, with 101 top-level settings in total.

## Overview

There is no single "IDEA mode" extension. The result is four stacked layers:

| Layer | Where it lives | What it does |
| --- | --- | --- |
| Extensions | VSCode extensions | Theme, icons, IDEA keybinding pack, Java language support |
| Colors | `settings.json` | Theme + theme-scoped overrides + semantic/TextMate dual syntax coloring |
| Behavior | `settings.json` | ~90 settings for completion, indentation, tabs, project tree, fonts, and scrolling |
| Keybindings | `keybindings.json` | 5 manual patches that fix the keybinding extension's behavior |

## Files

| File | Purpose |
| --- | --- |
| `settings.json` | Main configuration; copy into the VSCode user config directory |
| `keybindings.json` | Keybinding patches; copy into the same directory |
| `extensions.txt` | Extension IDs to install, one per line |
| `publish.bat` | Windows helper to set the remote and push (maintainer only) |

User config directory:

- Windows: `%APPDATA%\Code\User\`
- macOS: `~/Library/Application Support/Code/User/`
- Linux: `~/.config/Code/User/`

## Quick start

### 1. Install extensions

```powershell
# Windows PowerShell
Get-Content extensions.txt | ForEach-Object { code --install-extension $_ }
```

```bash
# macOS / Linux
xargs -n1 code --install-extension < extensions.txt
```

If `code` is not on your PATH, use `bin\code.cmd` from the VSCode install directory on Windows.

### 2. Copy the configuration

Copy `settings.json` and `keybindings.json` into the user config directory listed above. Back up your existing files before overwriting.

### 3. Install the font

The editor, terminal, debug console, and Markdown preview all use **JetBrains Mono**. It falls back to Consolas if not installed.

### 4. Replace the placeholder

The only machine-specific value in `settings.json` has been sanitized:

```json
"python.defaultInterpreterPath": "<YOUR_PYTHON_INTERPRETER>"
```

Replace it with your local Python interpreter path, or delete the line if you do not use Python.

## Extension list

| Extension ID | Purpose | Required |
| --- | --- | --- |
| `anandabibekray.intellij-idea-new-ui-theme` | Active `IntelliJ IDEA New UI` theme | Yes |
| `chadalen.vscode-jetbrains-icon-theme` | JetBrains 2023+ file icons | Yes |
| `k--kato.intellij-idea-keybindings` | Injects 220 IDEA key mappings | Yes |
| `redhat.java` | Java language server (JDT LS); semantic coloring depends on it | For Java development |
| `vscjava.vscode-java-pack` | Java debugging, dependency view, Maven integration | Optional |
| `vscjava.vscode-maven` / `vscjava.vscode-spring-initializr` | Maven and Spring project support | Optional |
| `madhavd1.javadoc-tools` | Javadoc generation | Optional |
| `monishkumarv.jetbrains-commit-manager` | JetBrains-style commit management | Optional |
| `alexti.intellij-idea-light-theme` / `qvist.jetbrains-new-ui-dark-theme` | Spare light / dark themes, not enabled | Optional |

## Implementation details

### Colors: three layers of overrides

| Layer | Setting | Value |
| --- | --- | --- |
| Base theme | `workbench.colorTheme` | `IntelliJ IDEA New UI` |
| File icons | `workbench.iconTheme` | `vscode-jetbrains-icon-theme-2023-light` |
| UI overrides | `workbench.colorCustomizations` | Title bar colors + editor colors scoped to `[IntelliJ IDEA New UI]` |
| Syntax colors A | `editor.semanticTokenColors` | 27 semantic token types |
| Syntax colors B | `editor.tokenColorCustomizations.textMateRules` | 10 TextMate scope groups |

**Why two syntax-color rulesets**: Java uses language-server semantic tokens, while other languages use TextMate scopes. Configuring only one gives "Java is colored, Vue/JS is not."

Key UI colors: selection `#A6D2FF`, current line `#F7F8FA`, line numbers `#A8ADBD`, indent guides `#EBECF0`.

Syntax colors come from the IDEA Classic Light palette:

```text
Keyword / modifier  #0033B3      String        #067D17
Number              #1750EB      Comment (italic) #8C8C8C
Function / method   #00627A      Property / field #871094
Annotation / decorator #9E880D   Class / interface #000000
```

### Behavior alignment: representative settings

| Setting | Value | Effect |
| --- | --- | --- |
| `window.commandCenter` / `window.menuBarVisibility` | `false` / `visible` | Disable command center, restore the classic menu bar |
| `window.titleBarStyle` | `custom` | Custom title bar colors |
| `editor.minimap.enabled` | `false` | Remove the minimap |
| `workbench.editor.enablePreview` | `false` | No italic preview tabs on single click |
| `editor.detectIndents` + `editor.tabSize` | `false` + `4` | Force 4 spaces, ignore file-based detection |
| `editor.suggest.preview` | `false` | Do not auto-insert completions |
| `editor.acceptSuggestionOnCommitCharacter` | `false` | Do not accept a suggestion when typing punctuation |
| `editor.acceptSuggestionOnEnter` | `on` | Accept with Enter or Tab |
| `editor.inlayHints.enabled` | `on` | Inline parameter name hints |
| `workbench.editor.wrapTabs` + `highlightModifiedTabs` | `true` / `true` | Multi-line tabs, highlight modified tabs |
| `explorer.compactFolders` | `false` | Do not collapse intermediate folders in the tree |
| `files.exclude` | Hide `.idea`, `target`, `node_modules`, etc. | Keep build artifacts out of the project view |
| `breadcrumbs.enabled` | `true` | Breadcrumb navigation |
| `editor.mouseWheelScrollSensitivity` and 2 others | `2.16` | Unify editor / list / terminal scrolling speed |

### Keybindings

`k--kato.intellij-idea-keybindings` injects 220 mappings. Common ones:

```text
Ctrl+B          Go to declaration   Ctrl+Alt+B      Go to implementation
Ctrl+Alt+O      Optimize imports    Alt+Enter       Quick fix
Ctrl+Q          Quick documentation Ctrl+P          Parameter hints
Shift+F6        Rename              Ctrl+E          Recent files
Ctrl+Shift+F    Find in files       Ctrl+Shift+A    Find action
Ctrl+N          Find symbol         Ctrl+/          Toggle line comment
```

The 5 entries in `keybindings.json` are manual patches:

- `F2` is rebound to `editor.action.rename`
- `Ctrl+Tab` / `Ctrl+Shift+Tab` are bound to recent-file list navigation
- `Ctrl+Alt+E` / `Ctrl+Alt+F12` also switch back and forth in the recent-file list

> **Known conflict**: the keybinding extension defines `F2` as "go to next error" (`-editor.action.rename` + `editor.action.marker.next`), which is IDEA's native behavior. User keybindings have higher priority, so this config overrides `F2` to rename. For a pure IDEA feel, delete the first entry in `keybindings.json`.

## Known trade-offs

- Three IDEA-style themes are installed; only `IntelliJ IDEA New UI` is active. The other two are spare light / dark themes.
- `editor.wordBasedSuggestions: "off"` already disables word-based completion, so `editor.suggest.showWords: true` is effectively redundant.
- `editor.formatOnSave` stays `false`, matching IDEA's default. Turn it on yourself if you want format-on-save.
- `workbench.editorAssociations` opens `*.md` in preview mode by default; remove it if you write Markdown often.

## Clone to a new machine

```bash
git clone https://github.com/<YOUR_GITHUB_USERNAME>/vscode-idea-setup.git
```

Then follow the four quick-start steps. The config depends on no private binaries — only public marketplace extensions and the JetBrains Mono font.

## License

MIT. See [LICENSE](LICENSE). Third-party extensions and fonts remain under their respective licenses.
