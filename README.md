# NAME

exact::lib - Compile-time @INC manipulation extension for exact

# VERSION

version 1.02

[![test](https://github.com/gryphonshafer/exact-lib/workflows/test/badge.svg)](https://github.com/gryphonshafer/exact-lib/actions?query=workflow%3Atest)
[![codecov](https://codecov.io/gh/gryphonshafer/exact-lib/graph/badge.svg)](https://codecov.io/gh/gryphonshafer/exact-lib)

# SYNOPSIS

    use exact -lib;       # add "lib" in $0 dir or closest ancestor dir to @INC
    use exact 'lib(lib)'; # same as above

    # add "../lib" relative to $0 dir to @INC; add abs dir "/other/dir" to @INC
    use exact 'lib( ../lib /other/dir )';

    # example of a path that includes with spaces
    use exact 'lib( /an/absolute/path\ with\ spaces/in/it )';

# DESCRIPTION

[exact::lib](https://metacpan.org/pod/exact%3A%3Alib) is an extension for [exact](https://metacpan.org/pod/exact) that provides a means to easily
manipulate @INC at compile time. When called, it will look for what appears to
be space-separated list of paths. If such a list is not provided, it will assume
"lib" as the default value.

    use exact -lib;       # same as below
    use exact 'lib(lib)'; # same as above

For each path that is a relative path that does not begin with ".", a relative
path will be searched for at or above the directory of the program (`$0`). If
found, that path will be added; if not found, nothing happens.

    use exact -lib;
    # will look for "lib" in program's directory first,
    # then if not found will look in the parent directory,
    # then if still not found, the parent's parent, and so on...

For any path in the list, if that item is an absolute path, that absolute path
will be directly added to the beginning of `@INC`.

    use exact 'lib( /var/something /var/something_else )';

For relative paths that begin with ".", these paths will be added to the
beginning of `@INC` as absolute paths relative to the program (`$0`).

    # add "../lib" relative to $0 dir to @INC
    use exact 'lib(../lib)';

If a path contains spaces, you can escape them with a backslash:

    # example of a path that includes with spaces
    use exact 'lib( /an/absolute/path\ with\ spaces/in/it )';

See the [exact](https://metacpan.org/pod/exact) documentation for additional information about
extensions. The intended use of [exact::lib](https://metacpan.org/pod/exact%3A%3Alib) is via the extension interface
of [exact](https://metacpan.org/pod/exact).

    use exact -lib, -conf, -noutf8;

However, you can also use it directly, which will also use [exact](https://metacpan.org/pod/exact) with
default options:

    use exact::lib;

# SEE ALSO

You can look for additional information at:

- [GitHub](https://github.com/gryphonshafer/exact-lib)
- [MetaCPAN](https://metacpan.org/pod/exact::lib)
- [GitHub Actions](https://github.com/gryphonshafer/exact-lib/actions)
- [Codecov](https://codecov.io/gh/gryphonshafer/exact-lib)
- [CPANTS](http://cpants.cpanauthors.org/dist/exact-lib)
- [CPAN Testers](http://www.cpantesters.org/distro/D/exact-lib.html)

# AUTHOR

Gryphon Shafer <gryphon@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2020-2021 by Gryphon Shafer.

This is free software, licensed under:

    The Artistic License 2.0 (GPL Compatible)
