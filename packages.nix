# Nix packages for cross-platform development
# This file defines all the packages that should be available in your environment

{ pkgs ? import <nixpkgs> {}, environment ? "development" }:

let
  # Core development tools (always included)
  corePackages = with pkgs; [
    nix-search-cli
    # Shell and terminal
    zsh
    tmux

    # File management
    stow
    tree

    # Screenshots
    flameshot

    # Text processing and search (essential)
    ripgrep
    fd
    fzf
    bat
    eza

    # Development tools
    git
    lazygit
    gh
    direnv
    cachix

    # System utilities
    curl
    wget
    htop

    # Editors
    # neovim  # Removed - configured via programs.neovim in home.nix

    # Basic data tools (lightweight, useful everywhere)
    jq
    yq-go            # Use yq-go instead of python yq to avoid conflicts

    just             # Command runner (like make but simpler)

    cloudflared
    ngrok
    
    unixtools.watch
  ];

  # Data analysis and processing tools (for development environments)
  dataPackages = with pkgs; [
    # CSV/TSV core
    qsv              # fast CSV swiss-army knife (Rust)
    tidy-viewer      # pretty viewer (command: tv)
    miller           # mlr: awk for CSV/TSV
    csvkit           # csvlook/csvcut/csvjoin, etc. (Python)
    csvtk            # fast CSV/TSV toolkit (Go)
    visidata         # interactive TUI data wrangler
    python3Packages.daff  # CSV/TSV diffs (table-aware)

    # JSON/YAML/TOML (extended)
    gojq             # JSON processors (gojq is faster/stricter)
    dasel            # jq-like for JSON/YAML/TOML/XML
    fx               # interactive JSON viewer
    jo               # build JSON from shell

    # SQL-on-files / light DBs
    duckdb           # query CSV/Parquet with SQL
    sqlite           # sqlite3 CLI
    sqlite-utils     # load/query CSVs into SQLite quickly

    # Logs & text pipelines
    angle-grinder    # agrind: structured log queries
    delta            # better diffs for text
    sd               # intuitive sed replacement
    choose           # quick column selector
    datamash         # one-liner aggregations
    # moreutils      # sponge, ts, vidir, etc. (conflicts with parallel)
    parallel
    pv               # show pipe throughput
    hyperfine        # benchmark pipelines

    # Spreadsheet/TUI & quick plots
    sc-im            # vim-like terminal spreadsheet
    gnuplot          # quick plots from CSV

    # Optional/Legacy
    xan              # maintained xsv alternative
    jc               # turn many command outputs into JSON
  ];

  # Platform-specific packages
  platformPackages = with pkgs; [
    # Add platform-specific packages here
  ] ++ (if pkgs.stdenv.isLinux then [
    # Linux-specific packages
    kitty
    xclip
  ] else [
    # macOS-specific packages (can be empty if using Homebrew)
  ]);

  # Optional development packages (core tools for fast project startup)
  devPackages = with pkgs; [
    # Python development (core tools always available)
    python312
    pipx            # Install Python CLI tools globally (use: pipx install youtrack-cli)
    uv              # Fast Python package manager
    ruff            # Fast Python linter and formatter

    # Node.js development (modern stack)
    nodejs_22       # Latest LTS Node.js
    pnpm            # Fast, disk-efficient package manager
    # bun             # Ultra-fast JavaScript runtime (uncomment if needed)

    # Go development
    go              # Go compiler and tools
    golangci-lint   # Go linter
    hugo
    # JavaScript tooling (for React/frontend)
    nodePackages.typescript
    nodePackages.eslint
    nodePackages.prettier
    # nodePackages.npm
    # nodePackages.yarn

    # Rust development
    # rustup

    # Go development
    # go

    # Docker and containers
    # docker
    # docker-compose

    # Kubernetes tools
    kubectl
    kubectx
    stern
    kubernetes-helm

    # Cloud tools
    # awscli2
    # google-cloud-sdk
    # terraform
    dotnet-sdk_8
    doctl

    # Database tools
    # postgresql
    # redis
    # sqlite

    pandoc texliveFull
  ];

  # Crypto development packages
  cryptoPackages = with pkgs; [
    # Core tools
    nodejs
    # yarn  # Removed to avoid conflict - use pnpm instead (already included in devPackages)
    docker
    websocat
    grpcurl
    openssl

    # EVM (Polygon, ETH)
    # foundry-bin  # Comment out if not available in current nixpkgs
    go-ethereum
    # nodePackages.hardhat  # Comment out if not available
    # nodePackages.truffle  # Comment out if not available

    # Bitcoin-style key derivation (for HD wallets)
    # libbitcoin-explorer  # Removed - obsolete version of Boost, no maintainer
    # python3Packages.mnemonic  # Comment out if not available
    # python3Packages.hdwallet  # Comment out if not available

    # Secrets / Hardware
    age
    gnupg
    yubikey-manager
  ];

  # Environment-specific package selection
  environmentPackages =
    if environment == "server" then
      corePackages ++ platformPackages
    else if environment == "minimal" then
      corePackages ++ platformPackages
    else # development (default)
      corePackages ++ dataPackages ++ platformPackages ++ devPackages ++ cryptoPackages;

in
  environmentPackages
