{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Rust toolchain
            rust-bin.stable.latest.default
            rust-analyzer
            cargo-watch
            cargo-edit
            cargo-audit
            
            # System dependencies
            pkg-config
            openssl
            
            # Development utilities
            git
            curl
            jq
          ];

          shellHook = ''
            echo "🦀 Rust development environment loaded!"
            echo "Rust version: $(rustc --version)"
            echo "Cargo version: $(cargo --version)"
            echo ""
            echo "Available tools:"
            echo "  rustc      - Rust compiler"
            echo "  cargo      - Rust package manager"
            echo "  rust-analyzer - Language server"
            echo "  cargo-watch - Auto-rebuild on changes"
            echo "  cargo-edit - Add/remove dependencies"
            echo "  cargo-audit - Security audit"
            echo ""
            
            echo "Quick start:"
            echo "  cargo init                     # Initialize new project"
            echo "  cargo build                    # Build project"
            echo "  cargo run                      # Run project"
            echo "  cargo watch -x run            # Auto-rebuild and run"
            echo "  cargo add <crate>              # Add dependency"
          '';
        };
      });
}