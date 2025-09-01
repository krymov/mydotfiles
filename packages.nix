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
    # Core EDA engines
    duckdb           # SQL on CSV/Parquet/JSON; fast columnar queries
    sqlite           # lightweight DB for ad-hoc loading/indexing  
    sqlite-utils     # load/query CSVs into SQLite quickly

    # CSV/TSV core tools
    qsv              # fast CSV swiss-army knife (schema, validate, join, sample)
    tidy-viewer      # pretty table viewer (command: tv)
    miller           # mlr: awk for CSV/TSV, reshaping, group-stats
    csvkit           # csvlook/csvcut/csvjoin, etc. (Python)
    csvtk            # fast CSV/TSV toolkit (Go) - cut, grep, uniq, join
    visidata         # interactive TUI data wrangler
    python3Packages.daff  # CSV/TSV diffs (table-aware)
    xan              # maintained xsv alternative

    # Data quality & profiling
    python3Packages.frictionless  # schema + validation for tabular data

    # JSON/YAML/TOML (extended)
    gojq             # JSON processors (gojq is faster/stricter)
    dasel            # jq-like for JSON/YAML/TOML/XML
    fx               # interactive JSON viewer
    jo               # build JSON from shell
    jc               # turn many command outputs into JSON

    # Text processing & pipelines
    angle-grinder    # agrind: structured log queries
    delta            # better diffs for text
    sd               # intuitive sed replacement
    choose           # quick column selector
    datamash         # quick reductions and statistical operations
    moreutils        # sponge, ts, vidir, etc.
    parallel         # GNU parallel for concurrent processing
    pv               # show pipe throughput
    hyperfine        # benchmark pipelines

    # Visualization & analysis
    sc-im            # vim-like terminal spreadsheet
    gnuplot          # quick plots from CSV/data files

    # Reproducibility & versioning
    dvc              # dataset & experiment tracking with remotes

    # Python environment with core ML/EDA packages (macOS optimized)
    (python3.withPackages (ps: with ps; [
      pandas           # DataFrame operations
      polars           # Fast DataFrame library (Rust-based) 
      numpy            # Numerical computing
      matplotlib       # Plotting
      seaborn          # Statistical visualization
      jupyter          # Notebook environment
      ipython          # Enhanced REPL
      requests         # HTTP library
      pyarrow          # Parquet support
      # Note: Excluding scipy, plotly temporarily to avoid CUDA warnings on macOS
      # You can install these separately if needed: pip install scipy plotly
    ]))
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

  # Environment-specific package selection
  environmentPackages =
    if environment == "server" then
      corePackages ++ platformPackages
    else if environment == "minimal" then
      corePackages ++ platformPackages
    else # development (default)
      corePackages ++ dataPackages ++ platformPackages ++ devPackages;

in
  environmentPackages
