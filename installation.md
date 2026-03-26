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

Those choices are then written into runtime config and later exposed live via:

```text
/tools capabilities
/tools enable <family>
/tools disable <family>
```

So install-time choices are not a trap.
They are just the initial state.

---

## Python Sandbox Setup

The installer can create the dedicated Python sandbox immediately.

It can also:

- ask package-by-package for the default set
- keep asking for extra packages until the user enters an empty line
- persist the chosen package baseline into runtime config

This is why the sandbox stays rebuildable later without guesswork.

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
