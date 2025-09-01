# Enhanced completions for cross-platform tools

# Initialize completion system
autoload -Uz compinit
# Only run compinit if needed (for performance)
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Create cache directory if it doesn't exist
[[ ! -d ~/.zsh/cache ]] && mkdir -p ~/.zsh/cache
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# Kill command completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# Enable completion for aliases
setopt complete_aliases

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Fuzzy matching of completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Ignore completion for commands we don't have
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Docker completion
if command -v docker >/dev/null; then
  # Docker completion
  if [[ -f "$HOME/.nix-profile/share/zsh/site-functions/_docker" ]]; then
    autoload -U "$HOME/.nix-profile/share/zsh/site-functions/_docker"
  fi
fi

# Kubectl completion
if command -v kubectl >/dev/null; then
  source <(kubectl completion zsh)
  # Enable completion for k alias
  compdef k=kubectl
fi

# Google Cloud completion
if command -v gcloud >/dev/null; then
  # Source gcloud completion if available
  if [[ -f "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc"
  elif [[ -f "/usr/share/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "/usr/share/google-cloud-sdk/completion.zsh.inc"
  elif [[ -f "$HOME/.nix-profile/share/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "$HOME/.nix-profile/share/google-cloud-sdk/completion.zsh.inc"
  fi
fi

# AWS CLI completion
if command -v aws >/dev/null; then
  # AWS CLI v2 completion
  if command -v aws_completer >/dev/null; then
    autoload -U bashcompinit && bashcompinit
    complete -C aws_completer aws
  fi
fi

# Docker completion
if command -v docker >/dev/null; then
  # Docker completion for macOS (Homebrew)
  if [[ -f "/opt/homebrew/share/zsh/site-functions/_docker" ]]; then
    autoload -U "/opt/homebrew/share/zsh/site-functions/_docker"
  # Docker completion for Linux/NixOS
  elif [[ -f "$HOME/.nix-profile/share/zsh/site-functions/_docker" ]]; then
    autoload -U "$HOME/.nix-profile/share/zsh/site-functions/_docker"
  elif [[ -f "/usr/share/zsh/vendor-completions/_docker" ]]; then
    autoload -U "/usr/share/zsh/vendor-completions/_docker"
  fi
fi

# Terraform completion
if command -v terraform >/dev/null; then
  terraform -install-autocomplete 2>/dev/null || true
fi

# Helm completion
if command -v helm >/dev/null; then
  source <(helm completion zsh)
fi

# Nix completion
if command -v nix >/dev/null; then
  # Enable nix completion if available
  if [[ -f "$HOME/.nix-profile/share/zsh/site-functions/_nix" ]]; then
    autoload -U "$HOME/.nix-profile/share/zsh/site-functions/_nix"
  fi
fi

# Tmux completion
if command -v tmux >/dev/null; then
  # Custom tmux session completion
  _tmux_sessions() {
    local sessions
    sessions=($(tmux list-sessions -F '#S' 2>/dev/null))
    _describe 'sessions' sessions
  }

  # Add completion for our tmux aliases
  compdef _tmux_sessions ta
  compdef _tmux_sessions tk
fi

# Custom completions for our functions
compdef '_path_files -/' mkcd  # Directory completion for mkcd
compdef '_files' extract       # File completion for extract

# SSH host completion from ~/.ssh/config
if [[ -f ~/.ssh/config ]]; then
  _ssh_config_hosts() {
    if [[ -r ~/.ssh/config ]]; then
      hosts=($(awk '/^Host [^*]/ {print $2}' ~/.ssh/config))
      _describe 'hosts' hosts
    fi
  }
  compdef _ssh_config_hosts ssh
fi

# Data processing tools completions
# ================================

# qsv (CSV toolkit) completion
if command -v qsv >/dev/null; then
  # Enable qsv completion if available
  if [[ -f "$HOME/.nix-profile/share/zsh/site-functions/_qsv" ]]; then
    autoload -U "$HOME/.nix-profile/share/zsh/site-functions/_qsv"
  else
    # Basic qsv completion for common commands
    _qsv() {
      local commands=(
        'stats:compute statistics'
        'headers:show headers'
        'select:select columns'
        'search:search records'
        'filter:filter records'
        'sort:sort records'
        'join:join CSV files'
        'count:count records'
        'frequency:frequency table'
        'slice:slice records'
        'sample:sample records'
        'index:create index'
        'input:validate input'
        'excel:convert to/from Excel'
        'jsonl:convert to/from JSONL'
        'table:tabular output'
        'tojsonl:convert to JSONL'
        'transpose:transpose data'
        'flatten:flatten nested data'
        'schema:infer schema'
        'validate:validate data'
        'sqlp:SQL operations'
        'apply:apply operations'
        'foreach:iterate operations'
        'reverse:reverse records'
        'cat:concatenate files'
        'split:split files'
        'fixlengths:fix field lengths'
        'fmt:format CSV'
        'rename:rename columns'
        'replace:replace values'
        'fill:fill missing values'
        'sniff:detect delimiter'
        'dedup:remove duplicates'
        'exclude:exclude columns'
        'explode:explode column'
        'pseudo:generate pseudo data'
        'py:Python operations'
        'lua:Lua operations'
        'describecols:describe columns'
        'enum:enumerate records'
        'luau:Luau operations'
        'partition:partition data'
        'diff:compare files'
        'fetch:fetch from URLs'
        'fetchpost:POST to URLs'
        'geocode:geocode addresses'
        'safenames:safe column names'
        'behead:remove headers'
        'round:round numbers'
        'prompt:interactive prompt'
        'excel:Excel operations'
      )
      _describe 'qsv commands' commands
    }
    compdef _qsv qsv
  fi
fi

# duckdb completion
if command -v duckdb >/dev/null; then
  _duckdb() {
    local context state line
    _arguments \
      '-c[Execute command]:command:' \
      '-cmd[Execute .cmd file]:file:_files' \
      '-csv[Output in CSV format]' \
      '-json[Output in JSON format]' \
      '-markdown[Output in Markdown format]' \
      '-list[Output in list format]' \
      '-readonly[Open in read-only mode]' \
      '*:database file:_files -g "*.db(-.)"'
  }
  compdef _duckdb duckdb
fi

# visidata completion
if command -v vd >/dev/null; then
  _visidata() {
    _arguments \
      '--help[Show help]' \
      '--version[Show version]' \
      '--config[Configuration file]:file:_files' \
      '--play[Replay saved commands]:file:_files' \
      '--batch[Non-interactive mode]' \
      '--debug[Debug mode]' \
      '*:data file:_files'
  }
  compdef _visidata vd
  compdef _visidata visidata
fi

# miller (mlr) completion
if command -v mlr >/dev/null; then
  _miller() {
    local commands=(
      'altersep:alter field separators'
      'bar:bar charts'
      'bootstrap:bootstrap sampling'
      'cat:concatenate files'
      'check:check for issues'
      'clean-whitespace:clean whitespace'
      'count:count records'
      'count-distinct:count distinct values'
      'cut:select fields'
      'filter:filter records'
      'flatten:flatten nested data'
      'format-values:format field values'
      'fraction:compute fractions'
      'grep:grep for patterns'
      'gsub:global substitution'
      'having-fields:filter by field presence'
      'head:first N records'
      'histogram:compute histogram'
      'join:join files'
      'label:add/modify field labels'
      'nest:nest fields'
      'nothing:do nothing'
      'put:add computed fields'
      'regex-replace:regex replacement'
      'remove-empty-columns:remove empty columns'
      'rename:rename fields'
      'reorder:reorder fields'
      'repeat:repeat records'
      'sample:sample records'
      'sec2dur:seconds to duration'
      'sec2durh:seconds to duration (human)'
      'seqgen:generate sequences'
      'shuffle:shuffle records'
      'skip-trivial-records:skip trivial records'
      'sort:sort records'
      'stats1:univariate statistics'
      'stats2:bivariate statistics'
      'step:step functions'
      'sub:substitution'
      'tac:reverse records'
      'tail:last N records'
      'tee:write to file and continue'
      'top:top N records'
      'uniq:unique records'
      'unsparsify:unsparsify data'
    )
    _describe 'miller commands' commands
  }
  compdef _miller mlr
fi

# jq completion enhancement
if command -v jq >/dev/null; then
  _jq() {
    _arguments \
      '-c[Compact output]' \
      '-r[Raw output]' \
      '-R[Raw input]' \
      '-s[Slurp mode]' \
      '-n[Null input]' \
      '-e[Exit with status]' \
      '-S[Sort keys]' \
      '-C[Colorize]' \
      '-M[Monochrome]' \
      '-a[ASCII output]' \
      '-j[Join output]' \
      '--tab[Use tabs]' \
      '--arg[Set variable]:name:value:' \
      '--argjson[Set JSON variable]:name:json:' \
      '*:filter:' \
      '*:file:_files'
  }
  compdef _jq jq
fi

# yq completion enhancement
if command -v yq >/dev/null; then
  _yq() {
    _arguments \
      '-r[Raw output]' \
      '-y[YAML output]' \
      '-j[JSON output]' \
      '-x[XML output]' \
      '-c[CSV output]' \
      '-t[TSV output]' \
      '-v[Verbose]' \
      '--help[Show help]' \
      '*:query:' \
      '*:file:_files'
  }
  compdef _yq yq
fi

# fd completion enhancement
if command -v fd >/dev/null; then
  _fd() {
    _arguments \
      '-t[Filter by type]:type:(f d l x e s p)' \
      '-e[Filter by extension]:extension:' \
      '-E[Exclude pattern]:pattern:' \
      '-H[Include hidden files]' \
      '-I[Include ignored files]' \
      '-L[Follow symlinks]' \
      '-p[Print full path]' \
      '-0[Separate by null]' \
      '-x[Execute command]:command:_command_names' \
      '-X[Execute command (batch)]:command:_command_names' \
      '--max-depth[Maximum depth]:depth:' \
      '--min-depth[Minimum depth]:depth:' \
      '*:pattern:' \
      '*:path:_files -/'
  }
  compdef _fd fd
fi

# ripgrep completion enhancement
if command -v rg >/dev/null; then
  _ripgrep() {
    _arguments \
      '-i[Case insensitive]' \
      '-S[Smart case]' \
      '-w[Word boundaries]' \
      '-v[Invert match]' \
      '-c[Count matches]' \
      '-l[Files with matches]' \
      '-L[Files without matches]' \
      '-n[Line numbers]' \
      '-H[Show filename]' \
      '-h[Hide filename]' \
      '-A[Lines after]:num:' \
      '-B[Lines before]:num:' \
      '-C[Lines context]:num:' \
      '-t[File type]:type:' \
      '-T[Exclude type]:type:' \
      '--type-list[List types]' \
      '*:pattern:' \
      '*:file:_files'
  }
  compdef _ripgrep rg
fi

# csvkit completion
if command -v csvstat >/dev/null; then
  # csvstat completion
  _csvstat() {
    _arguments \
      '--names[Show column names]' \
      '--count[Count rows]' \
      '--min[Minimum values]' \
      '--max[Maximum values]' \
      '--sum[Sum values]' \
      '--mean[Mean values]' \
      '--median[Median values]' \
      '--stdev[Standard deviation]' \
      '--nulls[Null value counts]' \
      '--unique[Unique value counts]' \
      '--freq[Most frequent values]' \
      '--len[String length stats]' \
      '*:file:_files -g "*.csv"'
  }
  compdef _csvstat csvstat

  # csvcut completion
  _csvcut() {
    _arguments \
      '-c[Columns]:columns:' \
      '-C[Exclude columns]:columns:' \
      '-x[Delete empty rows]' \
      '*:file:_files -g "*.csv"'
  }
  compdef _csvcut csvcut

  # csvgrep completion
  _csvgrep() {
    _arguments \
      '-c[Column]:column:' \
      '-m[Pattern]:pattern:' \
      '-r[Regex]:regex:' \
      '-f[File with patterns]:file:_files' \
      '-i[Case insensitive]' \
      '-v[Invert match]' \
      '*:file:_files -g "*.csv"'
  }
  compdef _csvgrep csvgrep

  # csvjoin completion
  _csvjoin() {
    _arguments \
      '-c[Columns]:columns:' \
      '--left[Left join]' \
      '--right[Right join]' \
      '--outer[Outer join]' \
      '*:file:_files -g "*.csv"'
  }
  compdef _csvjoin csvjoin
fi

# polars-cli completion
if command -v polars >/dev/null; then
  _polars() {
    local commands=(
      'cat:show file contents'
      'describe:describe data'
      'head:show first rows'
      'tail:show last rows'
      'sample:sample rows'
      'shape:show dimensions'
      'dtypes:show data types'
      'unique:show unique values'
      'sql:execute SQL query'
    )
    _describe 'polars commands' commands
  }
  compdef _polars polars
fi

# hyperfine completion
if command -v hyperfine >/dev/null; then
  _hyperfine() {
    _arguments \
      '--warmup[Warmup runs]:num:' \
      '--min-runs[Minimum runs]:num:' \
      '--max-runs[Maximum runs]:num:' \
      '--prepare[Preparation command]:command:' \
      '--cleanup[Cleanup command]:command:' \
      '--export-csv[Export CSV]:file:_files' \
      '--export-json[Export JSON]:file:_files' \
      '--export-markdown[Export Markdown]:file:_files' \
      '--show-output[Show command output]' \
      '--ignore-failure[Ignore command failures]' \
      '*:command:'
  }
  compdef _hyperfine hyperfine
fi

# Completion for our custom data aliases
if type tv >/dev/null; then
  compdef '_files -g "*.csv *.tsv *.json *.jsonl"' tv
fi

if type qsv >/dev/null; then
  compdef '_files -g "*.csv *.tsv"' qsv
fi
