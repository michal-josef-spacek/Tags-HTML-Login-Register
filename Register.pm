package Tags::HTML::Login::Register;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use List::Util qw(none);
use Readonly;
use Scalar::Util qw(blessed);

Readonly::Array our @FORM_METHODS => qw(post get);

our $VERSION = 0.03;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_register', 'form_method', 'lang', 'link', 'title', 'text', 'width'], @params);
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

	# Login box width.
	$self->{'width'} = '300px';

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
	my ($self, $messages_ar) = @_;

	if (defined $messages_ar) {
		if (ref $messages_ar ne 'ARRAY') {
			err "Bad list of messages.";
		}
		foreach my $message (@{$messages_ar}) {
			if (! blessed($message) || ! $message->isa('Data::Message::Simple')) {
				err "Message must be a instance of 'Data::Message::Simple' object.";
			}
		}
	}

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
	);

	if (defined $messages_ar && @{$messages_ar}) {
		$self->{'tags'}->put(
			['b', 'div'],
			['a', 'class', 'messages'],
		);
		my $count = 0;
		foreach my $message (@{$messages_ar}) {
			$count++;
			if ($count > 1) {
				$self->{'tags'}->put(
					['b', 'br'],
					['e', 'br'],
				);
			}
			$self->{'tags'}->put(
				['b', 'span'],
				['a', 'class', $message->type],
				defined $message->lang
					? (['a', 'lang', $message->lang])
					: (),
				['d', $message->text],
				['e', 'span'],
			);
		}
		$self->{'tags'}->put(
			['e', 'div'],
		);
	}

	$self->{'tags'}->put(
		['e', 'form'],
	);

	return;
}

# Process 'CSS::Struct'.
sub _process_css {
	my ($self, $message_types_hr) = @_;

	if (defined $message_types_hr && ref $message_types_hr ne 'HASH') {
		err 'Message types must be a hash reference.';
	}

	$self->{'css'}->put(
		['s', '.'.$self->{'css_register'}],
		['d', 'width', $self->{'width'}],
		['d', 'background-color', '#f2f2f2'],
		['d', 'padding', '20px'],
		['d', 'border-radius', '5px'],
		['d', 'box-shadow', '0 0 10px rgba(0, 0, 0, 0.2)'],
		['e'],

		['s', '.'.$self->{'css_register'}.' fieldset'],
		['d', 'border', 'none'],
		['d', 'padding', 0],
		['d', 'margin-bottom', '20px'],
		['e'],

		['s', '.'.$self->{'css_register'}.' legend'],
		['d', 'font-weight', 'bold'],
		['d', 'margin-bottom', '10px'],
		['e'],

		['s', '.'.$self->{'css_register'}.' p'],
		['d', 'margin', 0],
		['d', 'padding', '10px 0'],
		['e'],

		['s', '.'.$self->{'css_register'}.' label'],
		['d', 'display', 'block'],
		['d', 'font-weight', 'bold'],
		['d', 'margin-bottom', '5px'],
		['e'],

		['s', '.'.$self->{'css_register'}.' input[type="text"]'],
		['s', '.'.$self->{'css_register'}.' input[type="password"]'],
		['d', 'width', '100%'],
		['d', 'padding', '8px'],
		['d', 'border', '1px solid #ccc'],
		['d', 'border-radius', '3px'],
		['e'],

		['s', '.'.$self->{'css_register'}.' button[type="submit"]'],
		['d', 'width', '100%'],
		['d', 'padding', '10px'],
		['d', 'background-color', '#4CAF50'],
		['d', 'color', '#fff'],
		['d', 'border', 'none'],
		['d', 'border-radius', '3px'],
		['d', 'cursor', 'pointer'],
		['e'],

		['s', '.'.$self->{'css_register'}.' button[type="submit"]:hover'],
		['d', 'background-color', '#45a049'],
		['e'],

		['s', '.'.$self->{'css_register'}.' .messages'],
		['d', 'text-align', 'center'],
		['e'],
	);

	foreach my $message_type (keys %{$message_types_hr}) {
		$self->{'css'}->put(
			['s', '.'.$message_type],
			['d', 'color', $message_types_hr->{$message_type}],
			['e'],
		);
	}

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
 $obj->process($messages_ar);
 $obj->process_css($message_types_hr);

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

 $obj->process($messages_ar);

Process Tags structure for register form.
Variable C<$message_ar> is reference to array with L<Data::Message::Simple>
instances.

Returns undef.

=head2 C<process_css>

 $obj->process_css($message_types_hr);

Process CSS::Struct structure for register form.
Variable C<$message_types_hr> is reference to hash with message type keys and
CSS color as value. Message types are defined in L<Data::Message::Simple>.

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
         Message must be a instance of 'Data::Message::Simple' object.

 process_css():
         From Tags::HTML::process_css():
                 Parameter 'css' isn't defined.
         Message types must be a hash reference.

=head1 EXAMPLE

=for comment filename=print_block_html_and_css.pl

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
 # CSS
 # .form-register {
 # 	width: ;
 # 	background-color: #f2f2f2;
 # 	padding: 20px;
 # 	border-radius: 5px;
 # 	box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
 # }
 # .form-register fieldset {
 # 	border: none;
 # 	padding: 0;
 # 	margin-bottom: 20px;
 # }
 # .form-register legend {
 # 	font-weight: bold;
 # 	margin-bottom: 10px;
 # }
 # .form-register p {
 # 	margin: 0;
 # 	padding: 10px 0;
 # }
 # .form-register label {
 # 	display: block;
 # 	font-weight: bold;
 # 	margin-bottom: 5px;
 # }
 # .form-register input[type="text"], .form-register input[type="password"] {
 # 	width: 100%;
 # 	padding: 8px;
 # 	border: 1px solid #ccc;
 # 	border-radius: 3px;
 # }
 # .form-register button[type="submit"] {
 # 	width: 100%;
 # 	padding: 10px;
 # 	background-color: #4CAF50;
 # 	color: #fff;
 # 	border: none;
 # 	border-radius: 3px;
 # 	cursor: pointer;
 # }
 # .form-register button[type="submit"]:hover {
 # 	background-color: #45a049;
 # }
 # 
 # HTML
 # <form class="form-register" method="post">
 #   <fieldset>
 #     <legend>
 #       Register
 #     </legend>
 #     <p>
 #       <label for="username">
 #       </label>
 #       User name
 #       <input type="text" name="username" id="username">
 #       </input>
 #     </p>
 #     <p>
 #       <label for="password1">
 #         Password #1
 #       </label>
 #       <input type="password" name="password1" id="password1">
 #       </input>
 #     </p>
 #     <p>
 #       <label for="password2">
 #         Password #2
 #       </label>
 #       <input type="password" name="password2" id="password2">
 #       </input>
 #     </p>
 #     <p>
 #       <button type="submit" name="register" value="register">
 #         Register
 #       </button>
 #     </p>
 #   </fieldset>
 # </form>

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<List::Util>,
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

© 2021-2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.03

=cut
