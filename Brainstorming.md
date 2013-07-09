# Brainstorming

## Challenges

  * Vimscript is a moving target; the parser would have to accommodate all current options/Ex commands, and be able to easily add new ones.  It would also need to know which version of Vim to lint against.
  * There's currently no standard of what Vimscript "best practices" are.
  * I'm not certain about which implementation language to use; this is especially tricky, since Vim brings programmers from various language backgrounds in together.  I was thinking about maybe decoupling the implementation language from the plugin environment, so that users can write plugins in whatever language they feel comfortable with.

There are undoubtedly others; I'll document them as a I think of them.

## Implementation Details

  * Plugins, plugins, plugins.
  * I think it's important to implement a full Vimscript parser; I think the program should build up a parse tree and hand it off to the plugins for checking.
  * The individual token objects should have starting/ending line/column information.
  * Comments should *not* be ignored by the parser; they should exist as full-fledged objects.  Why?  So we can check "metadata" comments that Vimscript files tend to start with.
  * A user should be able to have multiple "profiles"; for example, I should be able to have a set of plugins to use for my vimrc files, Vimscript plugin development, and syntax file development.
  * Plugins should probably be able to consider a set of files rather than each file in isolation; I may, for example, want to check my entire vimrc setup to make sure I'm not blowing away function definitions.
  * I don't know which language to implement this in yet (see challenge #3); ideally users would be able to write plugins in whatever language they feel comfortable with.  The only "appropriate" language, I suppose,
    would be Vimscript. =/

## Policy Ideas

  * Check that you use full option names (not `set tw`, but `set textwidth`)
  * Check that you use full command names (not `:se`, but `:set`)
  * Check that `if`/`while`/`for`/`function`/etc all end with `endif`/`endwhile`/`endfor`/`endfunction` (not just `end`)
  * Check that you use `function!` (and not `function`)
  * Check that you put all autocmds into a group, and that you use `autocmd!` to clear them
  * Check that you don't clear an autocmd group after setting it up earlier in the script (like I did with my Custom group)
  * Check that you use `==#`/`==?` instead of `==`
  * Check that you use `inoremap` instead of `imap`
  * Don't use `map`; be explicit about using `imap`, `nmap`, etc
  * Don't use `abbrev`; be explicit about using `iabbrev`, `cabbrev`, etc
  * Make sure autocommands don't end in `<CR>`
  * Make sure a vimrc clears all mapping/abbreviations?
  * Enforce formatting?
  * preserve `&cpo`
  * checking if a script has been loaded
  * Use `''` for strings
  * Stylistic ones (`<Esc>` vs `<esc>`, `<C-u>` vs `<c-u>`)
  * If we could somehow detect setlocal for options set by an autocommand...
  * Detecting `if exists('g:option') && g:option`
  * Detecting unnecessary evals
  * Prefer `normal!` to `normal` (don't use mappings)
  * Enforce format/style of mode lines
  * Enforce indentation style and other whitespace
  * Make sure to check for has('perl') before doing perl << PERL, etc

## Other Ideas

  * It should be very easy to write tests for new policies.  We don't want to break any policies in future development.
  * A configuration should be compiled from a configuration file and command line options, and passed to policy plugins as an associative array.  This is so that a plugin may "opt out" of certain configurations.
    For example, let's say that we wish to implement a "severity" feature similar to Perl::Critic.  A plugin could opt out of checking if its self-assigned severity doesn't meet the desired level.  A plugin
    loading engine can process certain key/value pairs on its own as well.
  * A target Vimscript can tell vimlint to not apply certain policies via a special comment (ala Perl::Critic's `no critic` comment)
  * Installing custom policies should use Vim's runtime path, so custom policies can work easily with Pathogen and other tools.
  * Should users have to explicitly list which plugins they want to use?  Perl::Critic uses all the ones that are installed (minus a blacklist), and I'm not too keen on this behavior.
