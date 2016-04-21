#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Clone;

plan tests => 6;

use_ok( 'Hash::Sanitize' ) || print "Cannot load Hash::Sanitize !\n";

{ #void context

    my %hash = (
                a => 1,
                b => [qw/a s d f/],
                c => 2,
                d => {e=> 3, f=> 4},
    );
    
    my $expected = {a => 1, d => {e=> 3, f=> 4}};
    
    Hash::Sanitize::sanitize_hash(\%hash,[qw/a d/]);
    
    is_deeply(\%hash,$expected,"sanitize_hash in void context");

}


{ #hash context

    my %hash = (
                a => 1,
                b => [qw/a s d f/],
                c => 2,
                d => {e=> 3, f=> 4},
    );
    
    my $hash_clone = Clone::clone(\%hash);
    
    my $expected = {a => 1, d => {e=> 3, f=> 4}};
    
    my %sanitized_hash = Hash::Sanitize::sanitize_hash(\%hash,[qw/a d/]);
    
    is_deeply(\%hash,$hash_clone,"sanitize_hash in hash context : original hash is not modified");
    
    is_deeply(\%sanitized_hash,$expected,"sanitize_hash in Hash context : returned hash is sanitized");
}


{ #scalar context

    my %hash = (
                a => 1,
                b => [qw/a s d f/],
                c => 2,
                d => {e=> 3, f=> 4},
    );
    
    my $hash_clone = Clone::clone(\%hash);
    
    my $expected = {a => 1, d => {e=> 3, f=> 4}};
    
    my $sanitized_hash = Hash::Sanitize::sanitize_hash(\%hash,[qw/a d/]);
    
    is_deeply(\%hash,$hash_clone,"sanitize_hash in scalar context : original hash is not modified");
    
    is_deeply($sanitized_hash,$expected,"sanitize_hash in scalar context : returned hash is sanitized");
    
}
