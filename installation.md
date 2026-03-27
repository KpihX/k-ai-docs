# 🚀 Installation Without Guesswork

> **Problem we had:** install scripts are often "successful" only if the user already understands the project.

`k-ai` tries to invert that.

---

## What The Installer Actually Decides

Installation is not just "pip install a package".

It decides:

- whether `uv` is used
- what happens if `uv` is missing
- whether the runtime store becomes a local git repo
- which tool capability families start enabled
- which editor should open config files later
- whether the Python sandbox is created now
- which default sandbox packages get installed
- whether `qmd` should be prepared
- whether the bundled MCP filesystem server should be installed

---

## The Three Inputs

```text
scripts/install.sh
      +
install/install.yaml
      +
interactive user choices
```

That means:

- the script defines the flow
- `install.yaml` defines defaults
- the user can still override those defaults live

---

## Files You Should Know

- Install profile: [github.com/KpihX/k-ai/blob/master/install/install.yaml](https://github.com/KpihX/k-ai/blob/master/install/install.yaml)
- Install guide: [github.com/KpihX/k-ai/blob/master/install/README.md](https://github.com/KpihX/k-ai/blob/master/install/README.md)
- Main project README: [github.com/KpihX/k-ai/blob/master/README.md](https://github.com/KpihX/k-ai/blob/master/README.md)
- PyPI package: [pypi.org/project/kpihx-ai](https://pypi.org/project/kpihx-ai/)

---

## Install Paths

### Source install

```bash
git clone https://github.com/kpihx/k-ai.git
cd k-ai
./scripts/install.sh
```

### Explicit default profile

```bash
./scripts/install.sh -p defaults
```

### Custom install profile

```bash
./scripts/install.sh --path /path/to/my-install.yaml
```

### PyPI install

```bash
uv tool install kpihx-ai
# or
pipx install kpihx-ai
```

The product name stays `k-ai`.
Only the PyPI distribution name is `kpihx-ai`.

---

## Bootstrap Strategy

```text
prefer uv
   │
   ├─ uv already installed
   │     -> use uv workflow
   │
   ├─ uv missing, user accepts install
   │     -> install uv, then use uv workflow
   │
   └─ uv missing or declined
         -> isolated bootstrap virtualenv
            no pollution of the system Python
```

---

## Capability Setup

The installer asks which live families should start enabled:

- `exa`
- `python`
- `shell`
- `qmd`
- `mcp`

Those choices are then written into runtime config and later exposed live via:

```text
/tools capabilities
/tools enable <family>
/tools disable <family>
```

So install-time choices are not a trap.
They are just the initial state.

---

## MCP Filesystem Setup

The installer can also provision the official filesystem MCP server.

That means:

- package: `@modelcontextprotocol/server-filesystem`
- binary: `mcp-server-filesystem`
- installer path: `bun` first when available, then `npm`

And the result is not just "package installed somewhere".
The runtime config is updated so that `k-ai` can immediately treat it as the first bundled MCP server.

---

## Python Sandbox Setup

The installer can create the dedicated Python sandbox immediately.

It can also:

- ask package-by-package for the default set
- keep asking for extra packages until the user enters an empty line
- persist the chosen package baseline into runtime config

This is why the sandbox stays rebuildable later without guesswork.

---

## Verification Phase

By default, the installer verifies the checkout after setup.

That behavior is now configurable:

- `verification.enabled: true` -> run the final verification phase
- `verification.enabled: false` -> skip it entirely

This matters in two cases:

- constrained environments
- automated harnesses where recursive test execution would be wasteful

---

## Runtime Store Git

The installer also prepares a narrow git repo in `~/.k-ai/`.

Tracked:

- `config.yaml`
- `MEMORY.json`
- `sessions/index.json`
- `sessions/*.jsonl`

Ignored:

- `sandbox/`
- everything else outside the durable runtime state

That behavior comes from the managed template:

- [github.com/KpihX/k-ai/blob/master/install/.gitignore.runtime](https://github.com/KpihX/k-ai/blob/master/install/.gitignore.runtime)

And the runtime can later auto-commit on chat exit with a subject derived from the session digest.

---

## Purge Strategy

The purge path is intentionally conservative.

```bash
./scripts/purge.sh --yes
./scripts/purge.sh --yes --runtime-dir /path/to/runtime
```

Rules:

- without `--yes`, non-interactive purge aborts safely
- `--runtime-dir` exists for installs that do not use the default `~/.k-ai/`
- purge derives the QMD session collection from the runtime config when available
- purge removes the uv tool install using the real PyPI distribution name, not the CLI executable name

---

## Visual Summary

```text
install.sh
   │
   ├─ read install/install.yaml
   ├─ ask user where choices matter
   ├─ bootstrap uv or isolated fallback
   ├─ configure editor
   ├─ configure capability families
   ├─ install managed runtime .gitignore
   ├─ init ~/.k-ai git repo + first commit
   ├─ create python sandbox
   ├─ install default + extra sandbox packages
   └─ write ~/.k-ai/config.yaml
```

See also:

- [⚙️ Live Config](live-config.md)
- [🧪 Safety & Tests](safety-and-tests.md)
- [🩺 Doctor & Recovery](doctor-recovery.md)
