#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;

use HTML::ExtractText::Extra;

{
    my $ext = HTML::ExtractText::Extra->new;
    can_ok($ext,
        qw/new  extract  error  last_results  separator  ignore_not_found
            whitespace  nbsp/
    );
    isa_ok($ext, 'HTML::ExtractText::Extra');
}

{ # check defaults
    my $ext = HTML::ExtractText::Extra->new;
    is $ext->whitespace, 1, 'default whitespace';
    is $ext->nbsp, 1, 'default nbsp';
}

{ # check basic extraction
    my $ext = HTML::ExtractText::Extra->new;
    my $result = $ext->extract(
        {
            p => 'p',
            a => [ '[href]', qr/a.+/ ],
            b => [ 'b', sub { return "[$_[0]]" } ],
        },
        '<p>Paras1</p><a href="#">Linkas</a><p>Paras2</p><b>Foo</b>',
    );

    my $expected_result = {
        p => "Paras1\nParas2",
        a => 'Link',
        b => '[Foo]',
    };

    cmp_deeply $result, $expected_result, 'return of ->extract';
    cmp_deeply +{%$ext}, $expected_result, 'hash interpolation of object';
    cmp_deeply $ext->last_results, $expected_result,
        'return from ->last_results()';
}

done_testing();