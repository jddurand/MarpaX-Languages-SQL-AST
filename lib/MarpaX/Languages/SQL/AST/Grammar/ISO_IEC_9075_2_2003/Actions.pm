use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::SQL::AST::Grammar::ISO_IEC_9075_2_2003::Actions;
use parent 'MarpaX::Languages::SQL::AST::Grammar::Actions';
use SUPER;

# ABSTRACT: SQL 2003 grammar generic actions

# VERSION

=head1 DESCRIPTION

This modules give the actions associated to ISO_IEC_9075_2_2003 grammar.

=cut

#
# Done like this because Marpa is using $CODE{}

sub new                 { super() }
sub nonTerminalSemantic { super() }
sub fakedLexeme         { super() }

1;
