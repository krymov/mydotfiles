# Nix packages for cross-platform development
# This file defines all the packages that should be available in your environment

{ pkgs ? import <nixpkgs> {}, environment ? "development" }:

let
  # Core development tools (always included)
  corePackages = with pkgs; [
    # Shell and terminal
    zsh
    tmux

    # File management
    stow
    tree

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

    # System utilities
    curl
    wget
    htop

    # Editors
    neovim

    # Basic data tools (lightweight, useful everywhere)
    jq
    yq
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
    moreutils        # sponge, ts, vidir, etc.
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

  # Optional development packages (uncomment as needed)
  devPackages = with pkgs; [
    # Python development
    # python3
    # python3Packages.pip
    # python3Packages.virtualenv

    # Node.js development
    # nodejs
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
    # kubectl
    # kubectx
    # stern

    # Cloud tools
    # awscli2
    # google-cloud-sdk
    # terraform

    # Database tools
    # postgresql
    # redis
    # sqlite
  ];

  # Crypto development packages
  cryptoPackages = with pkgs; [
    # Core tools
    nodejs
    yarn
    docker
    websocat
    grpcurl
    openssl

    # EVM (Polygon, ETH)
    foundry-bin
    go-ethereum
    nodePackages.hardhat
    nodePackages.truffle

    # Bitcoin-style key derivation (for HD wallets)
    libbitcoin-explorer
    python3Packages.mnemonic
    python3Packages.hdwallet

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
