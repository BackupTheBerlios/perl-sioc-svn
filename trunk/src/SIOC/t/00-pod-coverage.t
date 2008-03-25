#!perl

use Test::More;
eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;

my $params = {
    also_private => [ qw(meta) ],
    coverage_class => 'Pod::Coverage::CountParents',
};
all_pod_coverage_ok($params);
