use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::SQL::AST::Grammar::ISO_IEC_9075_2_2003::Actions;

# ABSTRACT: SQL 2003 grammar actions

# VERSION

=head1 DESCRIPTION

This modules give the actions associated to ISO_IEC_9075_2_2003 grammar.

=cut

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);
    return $self;
}

1;
