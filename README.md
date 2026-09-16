# AgenticHighway Homebrew Tap

Homebrew formulae for AgenticHighway CLI tools.

## Install

Homebrew 6.0.0 and later require non-official taps to be explicitly trusted. Trust only the formula you need:

```bash
brew tap AgenticHighway/tap
brew trust --formula AgenticHighway/tap/vettd
brew install vettd
```

```bash
brew tap AgenticHighway/tap
brew trust --formula AgenticHighway/tap/kelvinclaw
brew install kelvinclaw
```

Or in one line. A fully-qualified install trusts just that item:

```bash
brew install AgenticHighway/tap/vettd
brew install AgenticHighway/tap/kelvinclaw
```

Alternatively, trust the whole tap with `brew trust AgenticHighway/tap`, but Homebrew recommends trusting only the formula you need.

## Available formulae

- [`vettd`](https://github.com/AgenticHighway/vettd-cli) — Detect, analyze, and report AI execution artifacts
- [`kelvinclaw`](https://github.com/AgenticHighway/kelvinclaw) — Secure, stable, and modular harness for agentic AI workflows
