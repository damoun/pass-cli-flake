# pass-cli-flake

A Nix Flake for the [Proton Pass CLI](https://github.com/protonpass/pass-cli).

This flake packages the official pre-compiled binaries from Proton, ensuring reproducibility and pure evaluation by tracking versions and hashes in a local `versions.json` manifest.

## Usage

### Run directly

```bash
nix run github:damoun/pass-cli-flake -- --help
```

### Use as a Flake Input

Add it to your `flake.nix`:

```nix
{
  inputs = {
    pass-cli.url = "github:damoun/pass-cli-flake";
  };

  outputs = { self, nixpkgs, pass-cli, ... }: {
    # Use pass-cli.packages.${system}.default in your configuration
  };
}
```

## Automation

- **Renovate**: Automatically tracks new tags in the [upstream repository](https://github.com/protonpass/pass-cli).
- **GitHub Actions**: When Renovate detects a new version, a GitHub Action automatically updates `versions.json` and validates it against a formal [JSON Schema](schema.json).
- **Security**: Includes automated security scanning via reusable workflows.

## License

This flake and its Nix expressions are licensed under the MIT License. The `pass-cli` binary itself is subject to Proton's own licensing terms.
