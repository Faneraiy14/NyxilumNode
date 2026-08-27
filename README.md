# NyxilumNode

*[Українською](README.uk.md)*

Runs programs written in **NyxilumLang** (`.nx` files). The equivalent
of `node.js`, but for NyxilumLang: a ready-made binary, an installer, a
library manager — no need to install .NET.

The language's own source code lives in a separate repository:
[github.com/Faneraiy14/NyxilumLang](https://github.com/Faneraiy14/NyxilumLang).

## Installation

Download the archive for your platform from the
[Releases](../../releases/latest) page and unpack it.

**Windows:**

1. Right-click `install-nx.ps1` → **"Run with PowerShell"**
   (or `powershell -ExecutionPolicy Bypass -File install-nx.ps1`).
2. Open a **new** terminal window (PATH only updates in new ones).

If Windows shows "Windows protected your PC" — the file isn't signed
with a paid certificate. Click "More info" → "Run anyway".

**Linux/Mac:**

```bash
bash install-nx.sh
source ~/.bashrc   # or ~/.zshrc, or just open a new terminal
```

GUI (`guiWindow` etc.) and graphics (`createCanvas` etc.) only work on
Windows — under the hood they use Windows Forms, which doesn't exist
outside Windows. The rest of the language (the compiler, VM, and almost
the entire standard library) works the same on all three platforms.

Verify the install (any platform):

```bash
nx --version
```

## Commands

| Command | What it does |
|---|---|
| `nx file.nx` | run a file |
| `nx` | REPL — executes line by line, `exit()` to quit |
| `nx install owner/repo` | install a library from a public GitHub repository |
| `nx install` | install everything listed in the current folder's `nx.json` |
| `nx uninstall name` | remove a library from `nx.json` and from `nx_modules/` |
| `nx update` / `nx update name` | update all libraries, or one, to the current default branch |
| `nx format file.nx` | format a file |
| `nx lint file.nx` | check a file for common mistakes |
| `nx check file.nx` | check syntax only (no code execution) |
| `nx --version` | version |

## First program

```nx
func main() {
    print("Hello, NyxilumLang!")
}
```

```bash
nx hello.nx
```

## Libraries

A package is any public GitHub repository with `main.nx` at its root:

```bash
nx install owner/repo
```

This pulls it into `nx_modules/<repo>/` and adds the dependency to
`nx.json` next to your file — pinned to the exact commit SHA, not a
branch name, so a repeated `nx install` always reproduces the exact
same byte-for-byte content, even if the package's branch is later
updated or rewritten. Importing it needs no `.nx` extension and no
path:

```nx
import "repo"

func main() {
    print(someFunctionFromThePackage())
}
```

Without an argument, `nx install` installs everything already listed
in the current folder's `nx.json`.

## Sandbox for untrusted code

If a `.nx` script runs under your service's identity (e.g. AI-generated
code) — `NX_SANDBOX=1 nx script.nx` restricts file access to the current
directory and fully blocks network access and reading environment
variables. Off by default.

## Language syntax

Full reference — [GUIDE.md](GUIDE.md): variables, functions, closures,
structs, maps, arrays, loops (including `break`/`continue`), `try/catch`,
`import`, higher-order functions, GUI, HTTP server, graphics.
