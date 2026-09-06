final: prev: {
  todoman = prev.todoman.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cat >> $out/share/fish/vendor_completions.d/todo.fish <<'EOF'

      function __fish_todo_complete_lists
          set -l python (__fish_anypython) || return
          todo --porcelain lists | $python -c '
      import json
      import sys
      for name in json.load(sys.stdin):
          print(name)
      '
      end

      complete -c todo \
          -n "__fish_seen_subcommand_from new" \
          -x -s l -l list \
          -a "(__fish_todo_complete_lists)" \
          -d "List"
      EOF
    '';
  });
}
