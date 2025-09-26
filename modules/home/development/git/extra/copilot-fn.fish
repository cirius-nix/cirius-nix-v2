function ghcs --description "Wrapper around gh copilot suggest"
    set -l TARGET shell
    set -l GH_DEBUG $GH_DEBUG
    set -l GH_HOST $GH_HOST

    set -l __USAGE "
Wrapper around \`gh copilot suggest\` to suggest a command based on natural language.
Supports executing suggested commands if applicable.

USAGE
  ghcs [flags] <prompt>

FLAGS
  -d, --debug              Enable debugging
  -h, --help               Display help usage
      --hostname HOST      The GitHub host to use for authentication
  -t, --target TARGET      Target for suggestion; must be shell, gh, git
                           default: $TARGET
"

    argparse d/debug h/help 't/target=' 'hostname=' -- $argv
    or return 1

    if set -q _flag_debug
        set GH_DEBUG api
    end
    if set -q _flag_help
        echo $__USAGE
        return 0
    end
    if set -q _flag_hostname
        set GH_HOST $_flag_hostname
    end
    if set -q _flag_target
        set TARGET $_flag_target
    end

    set -l TMPFILE (mktemp -t gh-copilotXXXXXX)
    function __ghcs_cleanup --on-event fish_exit
        rm -f $TMPFILE
    end

    if env GH_DEBUG=$GH_DEBUG GH_HOST=$GH_HOST gh copilot suggest -t $TARGET $argv --shell-out $TMPFILE
        if test -s $TMPFILE
            set -l FIXED_CMD (cat $TMPFILE)
            commandline -f execute # record last line into history
            builtin history merge
            echo
            eval $FIXED_CMD
        end
    else
        return 1
    end
end

function ghce --description "Wrapper around gh copilot explain"
    set -l GH_DEBUG $GH_DEBUG
    set -l GH_HOST $GH_HOST

    set -l __USAGE "
Wrapper around \`gh copilot explain\` to explain a given input command in natural language.

USAGE
  ghce [flags] <command>

FLAGS
  -d, --debug      Enable debugging
  -h, --help       Display help usage
      --hostname   The GitHub host to use for authentication
"

    argparse d/debug h/help 'hostname=' -- $argv
    or return 1

    if set -q _flag_debug
        set GH_DEBUG api
    end
    if set -q _flag_help
        echo $__USAGE
        return 0
    end
    if set -q _flag_hostname
        set GH_HOST $_flag_hostname
    end

    env GH_DEBUG=$GH_DEBUG GH_HOST=$GH_HOST gh copilot explain $argv
end
