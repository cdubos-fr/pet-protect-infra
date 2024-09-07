[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![security: bandit](https://img.shields.io/badge/security-bandit-yellow.svg)](https://github.com/PyCQA/bandit)
[![Checked with mypy](https://www.mypy-lang.org/static/mypy_badge.svg)](https://mypy-lang.org/)

Infrastructure for the Pet Protect project

# Installation

```bash
pip install <path-to-this-project>
```
or
```bash
pip install git+<git-url>
```

to install it in editable mode:
```bash
pip install -e .
```

to add developpement dependencies:
```bash
pip install -e ".[dev]"
```

# Setup dev' environment

Use [Nix](https://zero-to-nix.com/) with [direnv](https://github.com/nix-community/nix-direnv) to automatically build your development environment,
or simply run `nix develop`.

# Use CI environment

To use `CI` environment instead of development, you can execute `nix develop .#ci`

# Build

Use [Nix](https://zero-to-nix.com/) command: `nix build`
