# very much experimental

# these lines SHOULD work once we put them in braces
# let homedir = if ("HOME" in (env).name) {$env.HOME} else if ("HOMEPATH" in (env).name) {["C:" $env.HOMEPATH] | path join} else {error make {msg: "could not find home directory"}}

# see https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git

# let dotdir = [$homedir ".dotfiles"] | path join

# alias config=git --git-dir=$dotdir --work-tree=$homedir

export def status [] {
    # config status
}

# TODO this should accept --no-commit

# Track these files with the ~/.dotfiles repository
export def track [
    ...filepaths: path # the filepaths to track (add to the ~/.dotfiles repository)
    --no_commit (-n) # dont create a commit to track the added files
    --message (-m): string # override the default message
] {
    let span = (metadata $filepaths).span
    if ($filepaths | length) < 1 {
        help track
        error make {msg: "No files to track were added", label: {text: "At least one file to track here", start: $span.start, end: $span.end}}
        # TODO this should also work with "--help"...
    };
    let message = if $message == null {
        # TODO <path> | path relative-to "Whatever" has horrible error output, reffering amongst others to element before the actual error
        "Now tracking: " + ($filepaths | each {|it| ($it | path split | last)} | reduce {|it, acc| $acc + ", " + $it})
    } else {$message}
    #  | replace -p "\\" -r "/"
    let message_long = "Long paths: \n* " + ($filepaths | each {|it| ($it | path relative-to "C:\\Users\\smaier")} | reduce {|it, acc| $acc + "\n* " + $it})
    if not $no_commit {
        echo "TODO commit, message following:"
        echo $message
        echo $message_long
    }
}