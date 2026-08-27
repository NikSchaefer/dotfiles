use std/util "path add"

#---------------------------------------------------environment
$env.BUN_INSTALL = ($nu.home-dir | path join ".bun")
$env.EDITOR = "nvim"
$env.CARAPACE_MATCH = "1" # 1 = case-insensitive.

path add "/opt/homebrew/bin"
path add ($nu.home-dir | path join "dotfiles" "bin")
path add ($env.BUN_INSTALL | path join "bin")
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
    blue: "122;162;247"       # #7aa2f7
    magenta: "187;154;247"    # #bb9af7
    orange: "255;158;100"     # #ff9e64
    green: "158;206;106"      # #9ece6a
    yellow: "224;175;104"     # #e0af68
    red: "247;118;142"        # #f7768e
    cyan: "137;221;255"       # #89ddff
    teal: "115;218;202"       # #73daca
    fg: "192;202;245"         # #c0caf5
    bg_highlight: "41;46;66"  # #292e42
    selection: "65;72;104"    # #414868
    comment: "86;95;137"      # #565f89
    bg_dark: "22;22;30"       # #16161e
}

def _hex [rgb: string] {
    "#" + ($rgb | split row ";" | each {|c|
        $c | into int | format number | get lowerhex | str replace "0x" ""
           | fill --alignment r --character "0" --width 2
    } | str join)
}

#---------------------------------------------------colors: nushell itself
# $TN as hex, which is the form `color_config` wants.
let TNH = ($TN | items {|k, v| {$k: (_hex $v)} } | reduce --fold {} {|it, acc| $acc | merge $it })

# Merged rather than replaced, so keys added upstream keep their defaults.
$env.config.color_config = ($env.config.color_config | merge {
    # syntax highlighting, live as you type
    shape_internalcall: $TNH.blue
    shape_external: $TNH.blue
    shape_external_resolved: $TNH.blue
    shape_externalarg: $TNH.fg
    shape_literal: $TNH.blue
    shape_custom: $TNH.green
    shape_match_pattern: $TNH.green
    shape_string: $TNH.green
    shape_raw_string: $TNH.green
    shape_string_interpolation: $TNH.teal
    shape_glob_interpolation: $TNH.teal
    shape_int: $TNH.orange
    shape_float: $TNH.orange
    shape_binary: $TNH.orange
    shape_range: $TNH.orange
    shape_bool: $TNH.orange
    shape_nothing: $TNH.orange
    shape_datetime: $TNH.orange
    shape_keyword: { fg: $TNH.magenta, attr: b }
    shape_variable: $TNH.magenta
    shape_vardecl: $TNH.magenta
    shape_operator: $TNH.cyan
    shape_pipe: $TNH.cyan
    shape_redirection: $TNH.cyan
    shape_flag: $TNH.yellow
    shape_filepath: $TNH.teal
    shape_directory: $TNH.teal
    shape_globpattern: $TNH.teal
    shape_signature: $TNH.teal
    shape_block: $TNH.fg
    shape_closure: $TNH.fg
    shape_record: $TNH.fg
    shape_list: $TNH.fg
    shape_table: $TNH.fg
    shape_matching_brackets: { attr: u }
    shape_garbage: { fg: $TNH.red, attr: b }

    # table output and values
    header: { fg: $TNH.blue, attr: b }
    separator: $TNH.comment
    row_index: $TNH.comment
    hints: $TNH.comment           # autosuggestion ghost text
    empty: $TNH.blue
    string: $TNH.fg
    int: $TNH.orange
    float: $TNH.orange
    filesize: $TNH.orange
    duration: $TNH.orange
    range: $TNH.orange
    bool: $TNH.orange
    binary: $TNH.orange
    datetime: $TNH.teal
    cell-path: $TNH.teal
    nothing: $TNH.comment
    record: $TNH.fg
    list: $TNH.fg
    block: $TNH.fg
    closure: $TNH.fg
    selection: { fg: $TNH.fg, bg: $TNH.selection }
    search_result: { fg: $TNH.bg_dark, bg: $TNH.yellow }
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
} | transpose role rgb | each {|r| $"($r.role):(_hex $r.rgb)" } | str join "," | $"--color=($in)")

#---------------------------------------------------prompt: pills
const CAPS = { l: "", r: "" }

# Text on a colored background, with matching caps on either side.
def _pill [rgb: string, text: string] {
    let c = (ansi --escape $"38;2;($rgb)m")
    let b = (ansi --escape $"48;2;($rgb);38;2;($TN.bg_dark)m")
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
    $" (ansi --escape $'1;38;2;($TN.green)m')($glyph)(ansi reset) "
}

$env.config.render_right_prompt_on_last_line = true
$env.PROMPT_COMMAND = {|| _dir }
$env.PROMPT_COMMAND_RIGHT = {||
    [(_git)] | where {|s| $s | is-not-empty } | str join " "
}
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = {|| _arrow "¬" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| _arrow ":" }
$env.PROMPT_MULTILINE_INDICATOR = $"(ansi --escape $'38;2;($TN.magenta)m')❯ (ansi reset)"
$env.config.menus = ($env.config.menus | each {|m| $m | update marker $" ($m.marker | str trim) " })

#---------------------------------------------------completions
$env.config.completions.external.completer = {|spans| carapace $spans.0 nushell ...$spans | from json }

#---------------------------------------------------aliases
alias v = nvim
alias cat = bat
alias gorepo = ^open (git remote get-url origin | str trim | str replace -r '\.git$' '')

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
]
