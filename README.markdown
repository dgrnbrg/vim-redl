# Redl.vim -- Read Eval Debug Loop

This plugin integrates Vim with a running Clojure JVM. It provides a repl that
supports breakpoints, documentation lookup, source code navigation, and
omnicompletion.

## Installation

First, you'll need to install this as a Vim plugin. Do that with

    cd ~/.vim/bundle
    git clone git://github.com/dgrnbrg/vim-redl.git

You'll need Pathogen so that vim-redl gets loaded. Otherwise, if you are
a user of Vundle or NeoBundle, you can just use `Bundle 'dgrnbrg/vim-redl'`
or `NeoBundle 'dgrnbrg/vim-redl'` respectively to install the Vim component.

Then, you'll need to install the Clojure component. To get this, you just need to add 2 lines
to your `~/.lein/profiles.clj`.

- `:injections [(require '[redl core complete])]` ensure that redl is loaded on jvm startup
- `:dependencies [[redl "0.1.0"]]` ensures that redl is available on the classpath

A minimal profiles.clj (including REDL, Spyscope, and `lein pprint`) would look like:

```clojure
{:user {:dependencies [[spyscope "0.1.2"]
                       [redl "0.1.0"]]
        :injections [(require 'spyscope.core)
                     (require '[redl complete core])]
        :plugins [[lein-pprint "1.1.1"]]}}
```

### A REPL

To access the other repl, use `:Repl` or `:ReplHere`. The former opens a new
split window containing a repl in the namespace `user`. The latter opens the
repl in the namespace of the current file.

If you don't reconfigure the plugs below, these are the default controls for
the repl:

- `ctrl-e` in insert mode evaluates the current line, regardless of cursor position.
- `return` in insert mode at the end of the line evaluates the line, otherwise inserts a newline.
- `ctrl-up` goes up in the history
- `ctrl-down` goes down in the history

To use the breakpoint feature, check out dgrnbrg/redl (short version: `redl.core/break`
and `redl.core/continue`.

The plugs for the repl:

    <Plug>clj_repl_enter.
    <Plug>clj_repl_eval.
    <Plug>clj_repl_hat.
    <Plug>clj_repl_Ins.
    <Plug>clj_repl_uphist.
    <Plug>clj_repl_downhist.


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
