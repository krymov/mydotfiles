{
  description = "Data analysis and processing environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core shell tools
            zsh bash
            git direnv

            # CSV/TSV core
            qsv              # fast CSV swiss-army knife (Rust)
            tidy-viewer      # pretty viewer (command: tv)
            miller           # mlr: awk for CSV/TSV
            csvkit           # csvlook/csvcut/csvjoin, etc. (Python)
            csvtk            # fast CSV/TSV toolkit (Go)
            visidata         # interactive TUI data wrangler
            python3Packages.daff  # CSV/TSV diffs (table-aware)

            # JSON/YAML/TOML
            jq gojq          # JSON processors (gojq is faster/stricter)
            yq               # YAML <-> JSON (also TOML)
            dasel            # jq-like for JSON/YAML/TOML/XML
            fx               # interactive JSON viewer
            jo               # build JSON from shell

            # SQL-on-files / light DBs
            duckdb           # query CSV/Parquet with SQL
            sqlite           # sqlite3 CLI
            sqlite-utils     # load/query CSVs into SQLite quickly

            # Logs & text pipelines
            angle-grinder    # agrind: structured log queries
            ripgrep fd       # fast search & find
            bat delta        # better cat & diffs for text
            sd               # intuitive sed replacement
            choose           # quick column selector
            datamash         # one-liner aggregations
            moreutils        # sponge, ts, vidir, etc.
            parallel pv      # parallelize; show pipe throughput
            hyperfine        # benchmark pipelines

            # Spreadsheet/TUI & quick plots
            sc-im            # vim-like terminal spreadsheet
            gnuplot          # quick plots from CSV

            # Optional
            xan              # maintained xsv alternative
            jc               # turn many command outputs into JSON

            # Text editors for data work
            neovim

            # File management
            tree eza
            fzf
          ];

          shellHook = ''
            echo "📊 Data Analysis Environment Loaded!"
            echo ""
            echo "🗂️  CSV/TSV Tools:"
            echo "  qsv         - Swiss army knife for CSV (fastest, most features)"
            echo "  tv          - Pretty table viewer (tidy-viewer)"
            echo "  mlr         - Miller: awk for structured data"
            echo "  csvkit      - Python suite: csvlook, csvcut, csvjoin, etc."
            echo "  csvtk       - Go-based CSV toolkit"
            echo "  vd          - VisiData: interactive data explorer"
            echo "  daff        - Table-aware diffs"
            echo "  xan         - Maintained CSV toolkit (xsv successor)"
            echo ""
            echo "🔧 JSON/YAML/TOML:"
            echo "  jq/gojq     - JSON query and transformation"
            echo "  yq          - YAML/JSON/TOML processor"
            echo "  dasel       - Universal data selector"
            echo "  fx          - Interactive JSON viewer"
            echo "  jo          - Build JSON from command line"
            echo "  jc          - Convert command output to JSON"
            echo ""
            echo "🗄️  SQL & Databases:"
            echo "  duckdb      - Query CSV/Parquet with SQL"
            echo "  sqlite3     - SQLite command line"
            echo "  sqlite-utils - Load CSVs into SQLite quickly"
            echo ""
            echo "📈 Analysis & Visualization:"
            echo "  sc-im       - Vim-like spreadsheet"
            echo "  gnuplot     - Quick plots from data"
            echo "  hyperfine   - Benchmark data pipelines"
            echo ""
            echo "🚀 Text Processing:"
            echo "  rg/fd       - Fast search and find"
            echo "  bat/delta   - Better cat and diffs"
            echo "  sd          - Intuitive sed replacement"
            echo "  choose      - Quick column selection"
            echo "  datamash    - Statistical operations"
            echo "  ag          - Angle-grinder: structured log queries"
            echo ""
            echo "⚡ Pipeline Tools:"
            echo "  parallel    - GNU parallel"
            echo "  pv          - Pipe viewer (show throughput)"
            echo "  sponge      - Soak up input before writing"
            echo "  ts          - Timestamp input"
            echo ""
            echo "Quick start examples:"
            echo "  qsv stats data.csv                    # Quick statistics"
            echo "  tv data.csv                           # Pretty table view"
            echo "  duckdb -c \"SELECT * FROM 'data.csv'\"  # SQL on CSV"
            echo "  vd data.csv                           # Interactive exploration"
            echo ""
          '';
        };
      });
}