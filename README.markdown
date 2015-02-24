# Redl.vim -- Read Eval Debug Loop

This plugin integrates Vim with a running Clojure JVM. It provides a repl that
supports breakpoints, documentation lookup, source code navigation, and
omnicompletion.

## Installation

Vim Redl depends on [fireplace.vim](https://github.com/tpope/vim-fireplace).
Please install fireplace first.

First, you'll need to install this as a Vim plugin. Do that with

    cd ~/.vim/bundle
    git clone git://github.com/dgrnbrg/vim-redl.git

You'll need Pathogen so that vim-redl gets loaded. Otherwise, if you are
a user of Vundle or NeoBundle, you can just use `Plugin 'dgrnbrg/vim-redl'`
or `NeoBundle 'dgrnbrg/vim-redl'` respectively to install the Vim component.

Then, you'll need to install the Clojure component. To get this, you just need to add 2 lines
to your `~/.lein/profiles.clj`.

- `:injections [(require '[redl core complete])]` ensure that redl is loaded on jvm startup
- `:dependencies [[redl "0.2.4"]]` ensures that redl is available on the classpath

A minimal profiles.clj (including REDL, Spyscope, and `lein pprint`) would look like:

```clojure
{:user {:dependencies [[spyscope "0.1.3"]
                       [redl "0.2.4"]]
        :injections [(require 'spyscope.core)
                     (require '[redl complete core])]}}
```

### A REPL

To access the other repl, use `:Repl` or `:ReplHere`. The former opens a new
split window containing a repl in the namespace `user`. The latter opens the
repl in the namespace of the current file.

To open this repl in a vertical split (rather than horizontal), you can set this option in your .vimrc:

    let g:redl_use_vsplit = 1

The default controls for the repl are:

- `ctrl-e` in insert mode evaluates the current line, regardless of cursor position.
- `return` in insert mode at the end of the line evaluates the line, otherwise inserts a newline.
- `ctrl-up` in insert mode goes up in the history
- `ctrl-down` in insert mode goes down in the history

If some of these key bindings don't work on your machine, you can try to redefine them in your .vimrc. For example, to bind moving up in the history to Ctrl-Shift-K:

    imap <silent> <C-S-K> <Plug>clj_repl_uphist.

To change other key bindings, the plugs for the repl are:

    <Plug>clj_repl_enter.
    <Plug>clj_repl_eval.
    <Plug>clj_repl_hat.
    <Plug>clj_repl_Ins.
    <Plug>clj_repl_uphist.
    <Plug>clj_repl_downhist.

To use the breakpoint feature, check out [dgrnbrg/redl](https://github.com/dgrnbrg/redl)
(short version: `(redl.core/break)`, and then `(redl.core/continue)` in the debug sub-repl).

### Omnicomplete

This feature requires redl to be loaded in the connected JVM, as this plugin
uses redl's advanced fuzzy completion engine.

## Contributing

Please, open GitHub issues for bug reports and feature requests.  Even better than a
feature request is just to tell me the pain you're experiencing, and perhaps
some ideas for what might eliminate it.

This plugin was made by borrowing generous amounts of code from vimclojure Meikel Brandmeyer.

## License

Copyright © David Greenberg, Tim Pope, and Meikel Brandmeyer.
Distributed under the same terms as Vim itself.
See `:help license`.
