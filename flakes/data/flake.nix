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

            # Python environment (macOS optimized - no CUDA dependencies)
            (python3.withPackages (ps: with ps; [
              pandas          # DataFrame operations
              polars          # Fast DataFrame library
              numpy           # Numerical computing
              matplotlib      # Basic plotting
              jupyter         # Notebook environment
              ipython         # Enhanced REPL
              requests        # HTTP library
              pyarrow         # Parquet support
            ]))
          ];

          shellHook = ''
            echo "� Data Analysis Environment"
            echo "=============================="
            echo ""
            echo "📊 Data Processing Tools:"
            echo "  • qsv - CSV processing powerhouse"
            echo "  • xsv - CSV processing toolkit"
            echo "  • visidata - Interactive data explorer (vd <file>)"
            echo "  • duckdb - SQL analytics database"
            echo "  • polars-cli - Fast DataFrame CLI"
            echo "  • miller - Data processing (like awk/sed for CSV/JSON)"
            echo ""
            echo "📈 Analysis & Visualization:"
            echo "  • gnuplot - Plotting and graphing"
            echo "  • python3 - with pandas, polars, numpy, matplotlib, jupyter"
            echo ""
            echo "� Data Format Tools:"
            echo "  • jq - JSON processor"
            echo "  • yq - YAML processor"
            echo "  • csvkit - CSV utilities (csvstat, csvcut, etc.)"
            echo "  • sqlite - Database engine"
            echo ""
            echo "📁 File & Web Tools:"
            echo "  • fd, ripgrep - Fast search tools"
            echo "  • curl, httpie - HTTP clients"
            echo "  • git - Version control"
            echo ""
            echo "💡 Quick Start:"
            echo "  vd data.csv              # Explore CSV interactively"
            echo "  qsv stats data.csv       # Quick statistics"
            echo "  duckdb                   # SQL on files"
            echo "  python3 -m jupyter notebook  # Start Jupyter"
            echo ""
          '';
        };
      });
}