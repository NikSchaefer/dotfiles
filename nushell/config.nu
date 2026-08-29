use std/util "path add"

#---------------------------------------------------environment
$env.BUN_INSTALL = ($nu.home-dir | path join ".bun")
$env.EDITOR = "nvim"
$env.CARAPACE_MATCH = "1" # 1 = case-insensitive.

path add "/opt/homebrew/bin"
path add ($env.BUN_INSTALL | path join "bin")
path add ($nu.home-dir | path join "dotfiles" "bin")
path add ($nu.home-dir | path join "go" "bin")
path add ($nu.home-dir | path join ".cargo" "bin")
path add ($nu.home-dir | path join ".local" "bin") # claude, uv tools
$env.PATH = ($env.PATH | uniq)

#---------------------------------------------------options
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"

$env.config.completions.algorithm = "fuzzy"

$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 1_000_000

#---------------------------------------------------colors
# Tokyo Night
const TN = {
    blue: "#7aa2f7"
    magenta: "#bb9af7"
    orange: "#ff9e64"
    green: "#9ece6a"
    yellow: "#e0af68"
    red: "#f7768e"
    cyan: "#89ddff"
    teal: "#73daca"
    fg: "#c0caf5"
    bg_highlight: "#292e42"
    selection: "#414868"
    comment: "#565f89"
    bg_dark: "#16161e"
}

#---------------------------------------------------colors
$env.config.color_config = ($env.config.color_config | merge {
    # syntax highlighting, live as you type
    shape_internalcall: $TN.blue
    shape_external: $TN.blue
    shape_external_resolved: $TN.blue
    shape_externalarg: $TN.fg
    shape_literal: $TN.blue
    shape_custom: $TN.green
    shape_match_pattern: $TN.green
    shape_string: $TN.green
    shape_raw_string: $TN.green
    shape_string_interpolation: $TN.teal
    shape_glob_interpolation: $TN.teal
    shape_int: $TN.orange
    shape_float: $TN.orange
    shape_binary: $TN.orange
    shape_range: $TN.orange
    shape_bool: $TN.orange
    shape_nothing: $TN.orange
    shape_datetime: $TN.orange
    shape_keyword: { fg: $TN.magenta, attr: b }
    shape_variable: $TN.magenta
    shape_vardecl: $TN.magenta
    shape_operator: $TN.cyan
    shape_pipe: $TN.cyan
    shape_redirection: $TN.cyan
    shape_flag: $TN.yellow
    shape_filepath: $TN.teal
    shape_directory: $TN.teal
    shape_globpattern: $TN.teal
    shape_signature: $TN.teal
    shape_block: $TN.fg
    shape_closure: $TN.fg
    shape_record: $TN.fg
    shape_list: $TN.fg
    shape_table: $TN.fg
    shape_matching_brackets: { attr: u }
    shape_garbage: { fg: $TN.red, attr: b }

    # table output and values
    header: { fg: $TN.blue, attr: b }
    separator: $TN.comment
    row_index: $TN.comment
    hints: $TN.comment           # autosuggestion ghost text
    empty: $TN.blue
    string: $TN.fg
    int: $TN.orange
    float: $TN.orange
    filesize: $TN.orange
    duration: $TN.orange
    range: $TN.orange
    bool: $TN.orange
    binary: $TN.orange
    datetime: $TN.teal
    cell-path: $TN.teal
    nothing: $TN.comment
    record: $TN.fg
    list: $TN.fg
    block: $TN.fg
    closure: $TN.fg
    selection: { fg: $TN.fg, bg: $TN.selection }
    search_result: { fg: $TN.bg_dark, bg: $TN.yellow }
})

# fzf
$env.FZF_DEFAULT_OPTS = ({
    fg: $TN.fg, "fg+": $TN.fg, label: $TN.fg
    "bg+": $TN.bg_highlight, "selected-bg": $TN.selection
    hl: $TN.red, "hl+": $TN.red, header: $TN.red
    info: $TN.magenta, prompt: $TN.magenta
    pointer: $TN.orange, spinner: $TN.orange
    marker: $TN.blue
    border: $TN.comment
} | items {|role, color| $"($role):($color)" } | str join "," | $"--color=($in)")

#---------------------------------------------------prompt: pills
const CAPS = { l: "", r: "" }

# Text on a colored background, with matching caps on either side.
def _pill [color: string, text: string] {
    let c = (ansi {fg: $color})
    let b = (ansi {fg: $TN.bg_dark, bg: $color})
    let r = (ansi reset)
    $"($c)($CAPS.l)($b) ($text) ($r)($c)($CAPS.r)($r)"
}

# cwd with $HOME as ~, truncated to the last 2 segments once deeper than 3.
def _dir [] {
    let p = if ($env.PWD | str starts-with $nu.home-dir) {
        $env.PWD | str replace $nu.home-dir "~"
    } else { $env.PWD }
    let parts = ($p | split row "/")
    _pill $TN.blue (if ($parts | length) > 3 { $"…/($parts | last 2 | str join '/')" } else { $p })
}

# "⇡2" when non-zero, else null so `compact` drops it.
def _n [sym: string, n: int] { if $n > 0 { $"($sym)($n)" } }

#---------------------------------------------------prompt: git
# Nearest .git walking upwards
def _gitdir [] {
    mut d = ($env.PWD | path expand)
    loop {
        let g = ($d | path join ".git")
        match ($g | path type) {
            "dir" => { return $g }
            "file" => { return ($d | path join (open --raw $g | str trim | str replace "gitdir: " "")) }
        }
        let up = ($d | path dirname)
        if $up == $d { return null }
        $d = $up
    }
}

# In-progress operation, detected from marker files in the git dir.
def _gitop [g: string] {
    [[marker op];
     ["rebase-merge" REBASE] ["rebase-apply" REBASE] ["MERGE_HEAD" MERGE]
     ["CHERRY_PICK_HEAD" "CHERRY-PICK"] ["REVERT_HEAD" REVERT] ["BISECT_LOG" BISECT]]
    | where {|r| ($g | path join $r.marker) | path exists } | get --optional 0.op
}

# branch + behind/ahead/stash/dirty/op, from a single status call. "" outside a repo.
def _git [] {
    let g = (_gitdir)
    if $g == null { return "" }
    let st = (^git --no-optional-locks status --porcelain=v2 --branch | complete)
    if $st.exit_code != 0 { return "" }
    let lines = ($st.stdout | lines)
    let field = {|k| $lines | where {|l| $l starts-with $k } | get --optional 0 | default "" | str replace $k "" }

    let head = (do $field "# branch.head ")
    if ($head | is-empty) { return "" }

    # "+2 -3" when tracking a remote, empty otherwise.
    let ab = (do $field "# branch.ab " | split row " " | where {|x| $x | is-not-empty } | into int)
    let ahead = ($ab | get --optional 0 | default 0)
    let behind = ($ab | get --optional 1 | default 0 | math abs)

    let stash = (try { open --raw ($g | path join "logs" "refs" "stash") | lines | length } catch { 0 })
    # porcelain v2 line kinds: 1/2 = tracked change, u = unmerged conflict, ? = untracked
    let dirty = ($lines | any {|l| ($l | str substring 0..<2) in ["1 " "2 " "u " "? "] })
    let bits = ([
        (_n "⇣" $behind) (_n "⇡" $ahead) (_n "⚑" $stash)
        (if $dirty { "*" }) (_gitop $g)
    ] | compact)

    _pill $TN.magenta ([$head] ++ $bits | str join " ")
}

#---------------------------------------------------prompt: assembly
# Indicator glyph
def _arrow [glyph: string] {
    $" (ansi {fg: $TN.green, attr: b})($glyph)(ansi reset) "
}

$env.config.render_right_prompt_on_last_line = true
$env.PROMPT_COMMAND = {|| _dir }
$env.PROMPT_COMMAND_RIGHT = {||
    [(_git)] | where {|s| $s | is-not-empty } | str join " "
}
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = {|| _arrow "¬" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| _arrow ":" }
$env.PROMPT_MULTILINE_INDICATOR = $"(ansi {fg: $TN.magenta})❯ (ansi reset)"
$env.config.menus = ($env.config.menus | each {|m| $m | update marker $" ($m.marker | str trim) " })

#---------------------------------------------------completions
$env.config.completions.external.completer = {|spans| carapace $spans.0 nushell ...$spans | from json }

#---------------------------------------------------aliases
alias v = nvim
alias cat = bat
alias gorepo = ^open (git remote get-url origin | str trim | str replace -r '\.git$' '')
alias empty = osascript -e 'tell app "Finder" to empty'

#---------------------------------------------------commands
# yazi, landing in whatever directory it was left in.
def --env f [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open --raw $tmp | str trim)
    if ($cwd | is-not-empty) and ($cwd != $env.PWD) { cd $cwd }
    rm -f $tmp
}

# Fuzzy-find anything under ~, cd to it, and open files with a handler by extension.
def --env ff [] {
    let picked = (
        fd . $nu.home-dir --follow
            --exclude .git --exclude Library --exclude Applications --exclude go
        | fzf
        | complete
    )
    if $picked.exit_code != 0 { return }
    let sel = ($picked.stdout | str trim)
    if ($sel | is-empty) { return }

    if ($sel | path type) == "dir" {
        cd $sel
        return
    }
    cd ($sel | path dirname)
    match ($sel | path parse | get extension | str lowercase) {
        "pdf" => { tdf $sel -m 1 -f }
        "png" | "jpg" | "jpeg" | "gif" | "webp" | "svg" | "bmp" | "tiff"
        | "mp4" | "mov" | "avi" | "mkv" | "webm" | "m4v" => { ^open $sel }
        _ => { nvim $sel }
    }
}

#---------------------------------------------------keybindings
$env.config.keybindings ++= [
    {
        name: fuzzy_find
        modifier: control
        keycode: char_f
        mode: [emacs vi_normal vi_insert]
        event: { send: executehostcommand, cmd: "ff" }
    }
    {
        # opt+delete
        name: backspace_word
        modifier: alt
        keycode: backspace
        mode: [emacs vi_normal vi_insert]
        event: { edit: backspaceword }
    }
    {
        # cmd+delete
        name: cut_from_start
        modifier: control
        keycode: char_u
        mode: [emacs vi_normal vi_insert]
        event: { edit: cutfromstart }
    }
]

