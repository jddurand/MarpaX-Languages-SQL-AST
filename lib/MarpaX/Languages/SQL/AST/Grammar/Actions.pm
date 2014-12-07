use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::SQL::AST::Grammar::Actions;
use XML::LibXML;
use Carp qw/croak/;

# ABSTRACT: SQL grammar generic actions

# VERSION

=head1 DESCRIPTION

This modules give the actions associated to SQL grammar

=cut

sub new {
    my $class = shift;
    my $self = {
		dom => XML::LibXML::Document->new(),
	       };
    bless($self, $class);
    return $self;
}

sub nonTerminalSemantic {
  my $self = shift;

  my ($lhs, @rhs) = $self->getRuleDescription();
  my $maxRhs = $#rhs;

  $lhs =~ s/^<//;
  $lhs =~ s/>$//;

  my $node = XML::LibXML::Element->new($lhs);

  foreach (0..$#_) {
    my $child;
    if (ref($_[$_]) eq 'ARRAY') {
      $child = XML::LibXML::Element->new('_Lexeme');
      $child->setAttribute('text', $_[$_]->[0]);
    } else {
      $child = $_[$_];
    }
    $node->addChild($child);
  }

  if ($lhs eq 'SQL Start Sequence') {
    $self->{dom}->setDocumentElement($node);
    return $self->{dom};
  } else {
    return $node;
  }
}

sub getRuleDescription {
  my ($self) = @_;

  my $rule_id     = $Marpa::R2::Context::rule;
  my $slg         = $Marpa::R2::Context::slg;
  my ($lhs, @rhs) = map { $slg->symbol_display_form($_) } $slg->rule_expand($rule_id);

  return ($lhs, @rhs);
}

sub fakedLexeme {
  my ($self, @chars) = @_;

  return [join('', @chars)];
}

1;
