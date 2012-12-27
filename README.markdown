# Redl.vim -- Read Eval Debug Loop

This plugin integrates Vim with a running Clojure JVM. It provides a repl that
supports breakpoints, documentation lookup, source code navigation, and
omnicompletion.

## Installation

Redl.vim doesn't provide indenting or syntax highlighting, so you'll want
[a set of Clojure runtime files](https://github.com/guns/vim-clojure-static).

If you don't have a preferred installation method, I recommend
installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and
then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/dgrnbrg/vim-redl.git
    git clone git://github.com/guns/vim-clojure-static.git

Once help tags have been generated, you can view the manual with
`:help foreplay`.

## Features

This list isn't exhaustive; see the `:help` for details.

### Transparent setup

Foreplay.vim talks to nREPL.  With Leiningen 2, it connects automatically
based on `target/repl-port`, otherwise it's just a `:Connect` away.  You can
connect to multiple instances of nREPL for different projects, and it will
use the right one automatically.

The only external dependency is that you have Ruby installed.

Oh, and if you don't have an nREPL connection, it falls back to using
`java clojure.main`, using a class path based on your Leiningen or Maven
config.  This is a bit slow.

### Not quite a REPL

There are 2 repls in redl.vim. One of them is the vim-foreplay repl:  `cq`
(Think "Clojure Quasi-REPL") is the prefix for a set of commands that
bring up a *command-line window* — the same thing you get when you hit `q:`
— but set up for Clojure code.

`cqq` prepopulates the command-line window with the expression under the
cursor.  `cqc` gives you a blank line in insert mode.

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


### Evaluating from the buffer

Standard stuff here.  `:Eval` evaluates a range (`:%Eval` gets the whole
file), `:Require` requires a namespace with `:reload` (`:Require!` does
`:reload-all`), either the current buffer or a given argument.  There's a `cp`
operator that evaluates a given motion (`cpp` for the expression under the
cursor, `cpf` for the entire buffer).

### Navigating and Comprehending

I'm new to Clojure, so stuff that helps me understand code is a top priority.

* `:Source`, `:Doc`, `:FindDoc`, and `:Apropros`, which map to the underlying
  `clojure.repl` macro (with tab complete, of course).

* `K` is mapped to look up the symbol under the cursor with `doc`.

* `[d` is mapped to look up the symbol under the cursor with `source`.

* `[<C-D>` jumps to the definition of a symbol (even if it's inside a jar
  file).

* `gf`, everybody's favorite "go to file" command, works on namespaces.

### Omnicomplete

This feature requires redl to be loaded in the connected JVM, as this plugin
uses redl's advanced fuzzy completion engine.

### FAQ

> Why does it take so long for Vim to startup?

The short answer is because the JVM is slow.

The first time you load a Clojure file from any given project, redl.vim
sets about trying to determine your class path, leveraging either
`lein classpath` or `mvn dependency:build-classpath`.  This takes a couple of
seconds or so in the best case scenario, and potentially much longer if it
decides to hit the network.  (I don't understand why "tell me the class path"
requires hitting the network, but what do I know?)

Because the class path is oh-so-expensive to retrieve, foreplay.vim caches it
in `g:CLASSPATH_CACHE`.  By default, this disappears when you exit Vim, but
you can save it across sessions in `.viminfo` with this handy option:

    set viminfo+=!

The cache is expired when the timestamp on `project.clj` or `pom.xml` changes.

## Contributing

Please, open GitHub issues for bug reports and feature requests.  Even better than a
feature request is just to tell me the pain you're experiencing, and perhaps
some ideas for what might eliminate it.

This plugin was made by borrowing generous amounts of code from vimclojure and vim-foreplay.

## License

Copyright © Tim Pope, David Greenberg, and Meikel Brandmeyer.
Distributed under the same terms as Vim itself.
See `:help license`.
