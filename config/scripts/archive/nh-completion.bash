# ARCHIVED: Custom bash completion for legacy nh script wrapper from shell.nix
# This completion function was used alongside the custom nh script workaround.

function _nh_complete() {
  local cur prev words cword
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  cword="$COMP_CWORD"

  case "$cword" in
    1)
      COMPREPLY=( $(compgen -W "os home clean diff update" -- "$cur") )
      ;;
    2)
      case "${COMP_WORDS[1]}" in
        os)
          COMPREPLY=( $(compgen -W "switch test boot dry-build build" -- "$cur") )
          ;;
        home)
          COMPREPLY=( $(compgen -W "switch build" -- "$cur") )
          ;;
        clean)
          COMPREPLY=( $(compgen -W "7d 14d 30d" -- "$cur") )
          ;;
      esac
      ;;
    3)
      case "${COMP_WORDS[1]}" in
        os|home)
          COMPREPLY=( $(compgen -W "--dry --fast --show-trace --help" -- "$cur") )
          ;;
      esac
      ;;
  esac
}
complete -F _nh_complete nh
