# NyxilumNode

*[Українською](README.uk.md)*

Runs programs written in **NyxilumLang** (`.nx` files). The equivalent
of `node.js`, but for NyxilumLang: a ready-made binary, an installer, a
library manager — no need to install .NET.

The language's own source code lives in a separate repository:
[github.com/Faneraiy14/NyxilumLang](https://github.com/Faneraiy14/NyxilumLang).

## Installation

No .NET needed — everything is bundled.

**Windows** — an installer, like Node.js: download **`Nx-win-x64-setup.exe`** from
[Releases](../../releases/latest) and click "Next". No admin rights needed (installs for the
current user). You get an **"Nx IDE"** shortcut on the desktop and in the Start menu, the `nx`
command in the terminal, and uninstall via "Apps". If Windows shows "Windows protected your PC",
the installer just isn't signed with a paid certificate: "More info" → "Run anyway".

**Ubuntu / Debian** — download **`Nx-linux-x64.deb`** and open it with a double click
("Install"), or:

```bash
sudo apt install ./Nx-linux-x64.deb
```

**Any Linux or macOS** — one command, no sudo (everything goes to `~/.nyx`, an "Nx IDE"
shortcut in the menu and on the desktop):

```bash
curl -fsSL https://raw.githubusercontent.com/Faneraiy14/NyxilumNode/main/install.sh | bash
```

**macOS** — there is also a package, `Nx-osx-arm64.pkg` (Apple M1/M2/…) / `Nx-osx-x64.pkg`
(Intel): it isn't signed, so open it with right click → "Open".

**Manually** — the `.zip` / `.tar.gz` archive from the same page: unpack it and run
`install-nx.ps1` (Windows) or `bash install-nx.sh` (Linux/Mac).

Check (any platform, in a **new** terminal):

```bash
nx --version
```

**Updating:** `nx update-self` (or `nx update-self --check` to only check).
For `.deb`/`.pkg`, install the new package.

## Commands

| Command | What it does |
|---|---|
| `nx file.nx` | run a file |
| `nx ide` / `nx ide folder` | **Nx IDE** — a blocks (Scratch-like) + code environment with lessons and examples |
| `nx` | REPL — executes line by line, `exit()` to quit |
| `nx install owner/repo` | install a library from a public GitHub repository |
| `nx install` | install everything listed in the current folder's `nx.json` |
| `nx uninstall name` | remove a library from `nx.json` and from `nx_modules/` |
| `nx update` / `nx update name` | update all libraries, or one, to the current default branch |
| `nx format file.nx` | format a file |
| `nx lint file.nx` | check a file for common mistakes |
| `nx check file.nx` | check syntax only (no code execution) |
| `nx update-self` | update nx (and the IDE) to the latest release |
| `nx --version` | version |

## Nx IDE — programming from zero

```bash
nx ide
```

or the **"Nx IDE"** shortcut. It opens [Nx IDE](https://github.com/Faneraiy14/NyxilumIDE) —
an environment written in NyxilumLang itself, the same on Linux and Windows:

- **Blocks** (like Scratch): a hero on the stage, drawing, lists, your own blocks; "Open as code"
  and back — "Open as blocks".
- **Code** (like VS Code): completion, F12 — go to definition, F2 — rename everywhere, split
  editor, step-by-step run (debugger) and a stage for games right inside the IDE.
- **Lessons** with auto-checks and "Show me", examples, error hints in plain language.
- **Tools:** terminal, git (commit, branches, push), version history, extensions (built-in —
  Anylint; your own are written in NyxilumLang).
- **Look:** themes (dark, light, high contrast), antialiased fonts, 100–200% scale.

Programs live in `~/NyxПрограми` (or `nx ide other/dir`). The guide is `ide/ПОСІБНИК.md`
(Ukrainian).

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

## Standard library (`lib/`)

The archive ships a `lib/` folder next to `nx` — ready-made modules written in
NyxilumLang itself: `telegram.nx`, `discord.nx`, `http_client.nx`,
`postgres.nx` and `mysql.nx` (DB clients on top of raw TCP), `crypto.nx`
(SHA-1/SHA-256/MD5/HMAC/PBKDF2), `bytes.nx`, `datetime.nx`, `strings.nx`,
`collections.nx`, `testing.nx`. Import them by a path relative to your file
(copy `lib/` next to it or point at it):

```nx
import "lib/postgres.nx"

func main() {
    var db = pgConnect("postgres://user:pass@localhost:5432/mydb")
    print(toJson(pgQuery(db, "SELECT now() AS t", [])))
    pgClose(db)
}
```

Selective imports work too — `import "lib/postgres.nx" { pgConnect, pgQuery }`:
everything those functions depend on is pulled in automatically. Details in `GUIDE.md`.

## Sandbox for untrusted code

If a `.nx` script runs under your service's identity (e.g. AI-generated
code) — `NX_SANDBOX=1 nx script.nx` restricts file access to the current
directory and fully blocks network access and reading environment
variables. Off by default.

## Language syntax

Full reference — [GUIDE.md](GUIDE.md): variables, functions, closures,
structs, maps, arrays, loops (including `break`/`continue`), `try/catch`,
`import`, higher-order functions, GUI, HTTP server, graphics.
