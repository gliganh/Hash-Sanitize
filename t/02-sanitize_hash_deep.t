#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Clone;

plan tests => 8;

use_ok( 'Hash::Sanitize' ) || print "Cannot load Hash::Sanitize !\n";

{ #void context

    my %hash = (
                a => 1,
                b => [qw/a s d f/],
                c => 2,
                d => {e=> 3, f=> 4},
    );
    
    my $expected = {a => 1, d => {e=> 3}};
    
    Hash::Sanitize::sanitize_hash_deep(\%hash,[qw/a d e/]);
    
    is_deeply(\%hash,$expected,"sanitize_hash_deep in void context");

}

{ #void context 2

    my %hash = (
                a => 1,
                b => [qw/a s d f/],
                c => 2,
                d => {e=> 3, f=> 4},
    );
    
    my $expected = {a => 1, d => {f=> 4}};
    
    Hash::Sanitize::sanitize_hash_deep(\%hash,[qw/a d f/]);
    
    is_deeply(\%hash,$expected,"sanitize_hash_deep in void context");

}

{ #void context 3

    my %hash = (
                a => 1,
                b => [qw/a s d f/],
                c => 2,
                d => {e=> 3, f=> 4},
    );
    
    my $expected = {a => 1,c => 2};
    
    Hash::Sanitize::sanitize_hash_deep(\%hash,[qw/a c/]);
    
    is_deeply(\%hash,$expected,"sanitize_hash_deep in void context");

}



{ #hash context

    my %hash = (
                a => 1,
                b => [qw/a s d f/],
                c => 2,
                d => {e=> 3, f=> 4},
    );
    
    my $hash_clone = Clone::clone(\%hash);
    
    my $expected = {a => 1, d => {e=> 3}};
    
    my %sanitized_hash = Hash::Sanitize::sanitize_hash_deep(\%hash,[qw/a d e/]);
    
    is_deeply(\%hash,$hash_clone,"sanitize_hash_deep in hash context : original hash is not modified");
    
    is_deeply(\%sanitized_hash,$expected,"sanitize_hash_deep in hash context : returned hash is sanitized");

}


{ #scalar context

    my %hash = (
                a => 1,
                b => [qw/a s d f/],
                c => 2,
                d => {e=> 3, f=> 4},
    );
    
    my $hash_clone = Clone::clone(\%hash);
    
    my $expected = {a => 1, d => {e=> 3}};
    
    my $sanitized_hash = Hash::Sanitize::sanitize_hash_deep(\%hash,[qw/a d e/]);
    
    is_deeply(\%hash,$hash_clone,"sanitize_hash_deep in scalar context : original hash is not modified");
    
    is_deeply($sanitized_hash,$expected,"sanitize_hash_deep in scalar context : returned hash is sanitized");
    
}
