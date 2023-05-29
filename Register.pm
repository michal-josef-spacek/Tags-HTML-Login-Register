package Tags::HTML::Login::Register;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use List::MoreUtils qw(none);
use Readonly;

Readonly::Array our @FORM_METHODS => qw(post get);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_register', 'form_method', 'lang', 'link', 'title', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# CSS style for register box.
	$self->{'css_register'} = 'form-register';

	# Form method.
	$self->{'form_method'} = 'post';

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'password1_label' => 'Password #1',
			'password2_label' => 'Password #2',
			'register' => 'Register',
			'submit' => 'Register',
			'username_label' => 'User name',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	# Check form method.
	if (none { $self->{'form_method'} eq $_ } @FORM_METHODS) {
		err "Parameter 'form_method' has bad value.";
	}

	# TODO Check lang.

	# Check text for lang
	if (! defined $self->{'text'}) {
		err "Parameter 'text' is required.";
	}
	if (ref $self->{'text'} ne 'HASH') {
		err "Parameter 'text' must be a hash with language texts.";
	}
	if (! exists $self->{'text'}->{$self->{'lang'}}) {
		err "Texts for language '$self->{'lang'}' doesn't exist.";
	}

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	my $username_id = 'username';
	my $password1_id = 'password1';
	my $password2_id = 'password2';

	# Main content.
	$self->{'tags'}->put(
		['b', 'form'],
		['a', 'class', $self->{'css_register'}],
		['a', 'method', $self->{'form_method'}],

		['b', 'fieldset'],
		['b', 'legend'],
		['d', $self->_text('register')],
		['e', 'legend'],

		['b', 'p'],
		['b', 'label'],
		['a', 'for', $username_id],
		['e', 'label'],
		['d', $self->_text('username_label')],
		['b', 'input'],
		['a', 'type', 'text'],
		['a', 'name', $username_id],
		['a', 'id', $username_id],
		['e', 'input'],
		['e', 'p'],

		['b', 'p'],
		['b', 'label'],
		['a', 'for', $password1_id],
		['d', $self->_text('password1_label')],
		['e', 'label'],
		['b', 'input'],
		['a', 'type', 'password'],
		['a', 'name', $password1_id],
		['a', 'id', $password1_id],
		['e', 'input'],
		['e', 'p'],

		['b', 'p'],
		['b', 'label'],
		['a', 'for', $password2_id],
		['d', $self->_text('password2_label')],
		['e', 'label'],
		['b', 'input'],
		['a', 'type', 'password'],
		['a', 'name', $password2_id],
		['a', 'id', $password2_id],
		['e', 'input'],
		['e', 'p'],


		['b', 'p'],
		['b', 'button'],
		['a', 'type', 'submit'],
		['a', 'name', 'register'],
		['a', 'value', 'register'],
		['d', $self->_text('submit')],
		['e', 'button'],
		['e', 'p'],

		['e', 'fieldset'],

		['e', 'form'],
	);

	return;
}

# Process 'CSS::Struct'.
sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_register'}.' fieldset'],
		['d', 'border-color', 'red'],
		['e'],
	);

	return;
}

sub _text {
	my ($self, $key) = @_;

	if (! exists $self->{'text'}->{$self->{'lang'}}->{$key}) {
		err "Text for lang '$self->{'lang'}' and key '$key' doesn't exist.";
	}

	return $self->{'text'}->{$self->{'lang'}}->{$key};
}


1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Login::Register - Tags helper for login register.

=head1 SYNOPSIS

 use Tags::HTML::Login::Register;

 my $obj = Tags::HTML::Login::Register->new(%params);
 $obj->process;
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Login::Register->new(%params);

Constructor.

Returns instance of object.

=over 8

=item * C<css>

'CSS::Struct::Output' object for L<process_css> processing.

Default value is undef.

=item * C<form_method>

Form method.

Possible values are 'post' and 'get'.

Default value is 'post'.

=item * C<language>

Language in ISO 639-3 code.

Default value is 'eng'.

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=item * C<text>

Hash reference with keys defined language in ISO 639-3 code and value with hash
reference with texts.

Required keys are 'login', 'password_label', 'username_label' and 'submit'.

Default value is:

 {
 	'eng' => {
 		'password1_label' => 'Password #1',
 		'password2_label' => 'Password #2',
 		'register' => 'Register',
 		'username_label' => 'User name',
 		'submit' => 'Register',
 	},
 }

=back

=head2 C<process>

 $obj->process($percent_value);

Process Tags structure for gradient.

Returns undef.

=head2 C<process_css>

 $obj->process_css;

Process CSS::Struct structure for output.

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.
         From Tags::HTML::new():
                 Parameter 'css' must be a 'CSS::Struct::Output::*' class.
                 Parameter 'tags' must be a 'Tags::Output::*' class.

 process():
         From Tags::HTML::process():
                 Parameter 'tags' isn't defined.

 process_css():
         From Tags::HTML::process_css():
                 Parameter 'css' isn't defined.

=head1 EXAMPLE

 use strict;
 use warnings;

 use CSS::Struct::Output::Indent;
 use Tags::HTML::Login::Register;
 use Tags::Output::Indent;

 # Object.
 my $css = CSS::Struct::Output::Indent->new;
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Login::Register->new(
         'css' => $css,
         'tags' => $tags,
 );

 # Process login button.
 $obj->process_css;
 $obj->process;

 # Print out.
 print "CSS\n";
 print $css->flush."\n\n";
 print "HTML\n";
 print $tags->flush."\n";

 # Output:
 # TODO

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<List::MoreUtils>,
L<Readonly>,
L<Tags::HTML>.

=head1 SEE ALSO

=over

=item L<Tags::HTML::Login::Access>

Tags helper for login access.

=item L<Tags::HTML::Login::Button>

Tags helper for login button.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Tags-HTML-Login-Register>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2021-2022 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
