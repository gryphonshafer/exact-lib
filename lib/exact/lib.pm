package exact::lib;
# ABSTRACT: Compile-time @INC manipulation extension for exact

use 5.014;
use exact;
use strict;
use FindBin;

# VERSION

sub import {
    my ( $self, $caller, $input ) = @_;

    $input //= 'lib';
    $input =~ s/(^\s+|\s+$)//g;

    for my $dir ( map { s/\\ / /g; $_ } split( /(?<!\\)\s/, $input ) ) {
        if ( index( $dir, '/', 0 ) == 0 ) {
            _add_to_inc($dir);
        }
        elsif ( index( $dir, '.', 0 ) == 0 ) {
            _add_to_inc( $FindBin::Bin . '/' . $dir );
        }
        else {
            my $found_dir = _find_dir($dir);
            _add_to_inc($found_dir) if ($found_dir);
        }
    }
}

sub _add_to_inc {
    for my $lib (@_) {
        unshift( @INC, $lib ) unless ( grep { $_ eq $lib } @INC );
    }
}

sub _find_dir {
    my ($suffix) = @_;

    my @search_path = split( '/', $FindBin::Bin );
    while ( @search_path > 0 ) {
        my $dir = join( '/', @search_path, $suffix );
        return $dir if ( -d $dir );
        pop @search_path;
    }

    return;
}

1;
__END__
=pod

=begin :badges

=for markdown
[![build](https://github.com/gryphonshafer/exact-lib/workflows/build/badge.svg)](https://github.com/gryphonshafer/exact-lib/actions?query=workflow%3Abuild)
[![codecov](https://codecov.io/gh/gryphonshafer/exact-lib/graph/badge.svg)](https://codecov.io/gh/gryphonshafer/exact-lib)

=end :badges

=head1 SYNOPSIS

    use exact -lib;       # add "lib" in $0 dir or closest ancestor dir to @INC
    use exact 'lib(lib)'; # same as above

    # add "../lib" relative to $0 dir to @INC; add abs dir "/other/dir" to @INC
    use exact 'lib( ../lib /other/dir )';

    # example of a path that includes with spaces
    use exact 'lib( /an/absolute/path\ with\ spaces/in/it )';

=head1 DESCRIPTION

L<exact::lib> is an extension for L<exact> that provides a means to easily
manipulate @INC at compile time. When called, it will look for what appears to
be space-separated list of paths. If such a list is not provided, it will assume
"lib" as the default value.

    use exact -lib;       # same as below
    use exact 'lib(lib)'; # same as above

For each path that is a relative path that does not begin with ".", a relative
path will be searched for at or above the directory of the program (C<$0>). If
found, that path will be added; if not found, nothing happens.

    use exact -lib;
    # will look for "lib" in program's directory first,
    # then if not found will look in the parent directory,
    # then if still not found, the parent's parent, and so on...

For any path in the list, if that item is an absolute path, that absolute path
will be directly added to the beginning of C<@INC>.

    use exact 'lib( /var/something /var/something_else )';

For relative paths that begin with ".", these paths will be added to the
beginning of C<@INC> as absolute paths relative to the program (C<$0>).

    # add "../lib" relative to $0 dir to @INC
    use exact 'lib(../lib)';

If a path contains spaces, you can escape them with a backslash:

    # example of a path that includes with spaces
    use exact 'lib( /an/absolute/path\ with\ spaces/in/it )';

See the L<exact> documentation for additional information about
extensions. The intended use of L<exact::lib> is via the extension interface
of L<exact>.

    use exact -lib, -conf, -noutf8;

However, you can also use it directly, which will also use L<exact> with
default options:

    use exact::lib;

=head1 SEE ALSO

You can look for additional information at:

=for :list
* L<GitHub|https://github.com/gryphonshafer/exact-lib>
* L<MetaCPAN|https://metacpan.org/pod/exact::lib>
* L<GitHub Actions|https://github.com/gryphonshafer/exact-lib/actions>
* L<Codecov|https://codecov.io/gh/gryphonshafer/exact-lib>
* L<CPANTS|http://cpants.cpanauthors.org/dist/exact-lib>
* L<CPAN Testers|http://www.cpantesters.org/distro/D/exact-lib.html>

=cut
