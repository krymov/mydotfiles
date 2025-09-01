# Data Analysis Environment

This flake provides a comprehensive data analysis and processing environment with tools for CSV/TSV, JSON/YAML, SQL, and data visualization.

## Quick Start

### Using direnv (Recommended)
1. Copy `.envrc` to your data project directory
2. Run `direnv allow`
3. The environment will automatically load when you enter the directory

### Manual Usage
```bash
# Enter the data analysis environment
nix develop ~/.dotfiles/flakes/data

# Or use the convenience script
~/.dotfiles/dev-env.sh data
```

## Available Tools

### CSV/TSV Processing
- **qsv** - Fast CSV swiss-army knife (Rust-based, most comprehensive)
- **tidy-viewer (tv)** - Pretty table viewer with colors and formatting
- **miller (mlr)** - Like awk but for structured data
- **csvkit** - Python suite: csvlook, csvcut, csvjoin, csvstat, etc.
- **csvtk** - Fast CSV/TSV toolkit written in Go
- **visidata (vd)** - Interactive terminal-based data explorer
- **daff** - Table-aware diffs for CSV files
- **xan** - Maintained CSV toolkit (xsv successor)

### JSON/YAML/TOML
- **jq/gojq** - JSON query and transformation (gojq is faster)
- **yq** - YAML ↔ JSON ↔ TOML processor
- **dasel** - Universal data selector (works with JSON/YAML/TOML/XML)
- **fx** - Interactive JSON viewer and processor
- **jo** - Build JSON objects from command line
- **jc** - Convert command outputs to JSON

### SQL and Databases
- **duckdb** - Query CSV/Parquet files with SQL
- **sqlite3** - SQLite command line interface
- **sqlite-utils** - Load CSVs into SQLite quickly

### Analysis and Visualization
- **sc-im** - Vim-like terminal spreadsheet
- **gnuplot** - Create plots from data files
- **hyperfine** - Benchmark data processing pipelines

### Text Processing Pipeline
- **ripgrep (rg)** - Fast text search
- **fd** - Fast file finder
- **bat** - Better cat with syntax highlighting
- **delta** - Better diffs for text
- **sd** - Intuitive sed replacement
- **choose** - Quick column selection
- **datamash** - Statistical operations on text
- **angle-grinder (ag)** - Query structured logs

### Pipeline and Utility Tools
- **parallel** - GNU parallel for concurrent processing
- **pv** - Pipe viewer (shows throughput and progress)
- **moreutils** - sponge, ts, vidir, and other useful tools

## Example Workflows

### Quick Data Exploration
```bash
# Pretty view of CSV
tv data.csv

# Quick statistics
qsv stats data.csv

# Interactive exploration
vd data.csv

# SQL queries on CSV
duckdb -c "SELECT column1, COUNT(*) FROM 'data.csv' GROUP BY column1"
```

### Data Processing Pipelines
```bash
# Clean and transform CSV
qsv select name,age,city data.csv | \
qsv search -s city "New York" | \
qsv sort -s age | \
tv

# Convert CSV to JSON with filtering
mlr --icsv --ojson filter '$age > 30' data.csv

# Process logs with structured queries
cat app.log | ag 'fields.level == "ERROR"' | head -20
```

### Data Format Conversions
```bash
# CSV to different formats
qsv to json data.csv > data.json
qsv to xlsx data.csv > data.xlsx

# YAML to JSON
yq eval -o=json config.yaml > config.json

# Command output to structured data
ps aux | jc --ps | jq '.[] | select(.cpu_percent > 1.0)'
```

### Analysis and Reporting
```bash
# Generate summary statistics
qsv frequency column_name data.csv
qsv stats --everything data.csv

# Create simple plots
echo "x,y\n1,2\n2,4\n3,6" | qsv plot line --output plot.png

# Spreadsheet-like analysis
sc-im data.csv
```

## Tips for Data Projects

1. **Use .envrc** - Copy the `.envrc` file to your project root for automatic environment loading
2. **Combine tools** - Each tool has strengths; qsv for speed, visidata for exploration, duckdb for SQL
3. **Pipe efficiently** - Use `pv` to monitor pipeline progress
4. **Benchmark** - Use `hyperfine` to optimize your data processing commands
5. **Version data** - Use `daff` to track changes in your datasets

## Environment Variables

The `.envrc` file supports these optional variables:
```bash
export DATA_DIR="./data"           # Default data directory
export OUTPUT_DIR="./output"       # Output directory
export CACHE_DIR="./.cache"        # Cache for intermediate results
```

## Integration with Other Languages

This environment works well with:
- **Python**: Use alongside `~/.dotfiles/flakes/python`
- **R**: Add R packages to a custom flake
- **Julia**: Create a julia-specific environment
- **Go**: Use with `~/.dotfiles/flakes/go` for data processing tools

## Performance Notes

- **qsv** is fastest for large CSV operations
- **gojq** is faster than jq for complex JSON processing
- **duckdb** excels at analytical queries on large datasets
- **visidata** is best for interactive exploration
- Use **parallel** for CPU-intensive operations on multiple files
