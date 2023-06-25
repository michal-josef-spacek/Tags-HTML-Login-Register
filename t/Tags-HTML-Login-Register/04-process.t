use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Login::Register;
use Tags::Output::Structure;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $tags = Tags::Output::Structure->new;
my $obj = Tags::HTML::Login::Register->new(
	'tags' => $tags,
);
$obj->process;
my $ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'form'],
		['a', 'class', 'form-register'],
		['a', 'method', 'post'],
		['b', 'fieldset'],

		['b', 'legend'],
		['d', 'Register'],
		['e', 'legend'],

		['b', 'p'],
		['b', 'label'],
		['a', 'for', 'username'],
		['e', 'label'],
		['d', 'User name'],
		['b', 'input'],
		['a', 'type', 'text'],
		['a', 'name', 'username'],
		['a', 'id', 'username'],
		['e', 'input'],
		['e', 'p'],

		['b', 'p'],
		['b', 'label'],
		['a', 'for', 'password1'],
		['d', 'Password #1'],
		['e', 'label'],
		['b', 'input'],
		['a', 'type', 'password'],
		['a', 'name', 'password1'],
		['a', 'id', 'password1'],
		['e', 'input'],
		['e', 'p'],

		['b', 'p'],
		['b', 'label'],
		['a', 'for', 'password2'],
		['d', 'Password #2'],
		['e', 'label'],
		['b', 'input'],
		['a', 'type', 'password'],
		['a', 'name', 'password2'],
		['a', 'id', 'password2'],
		['e', 'input'],
		['e', 'p'],

		['b', 'p'],
		['b', 'button'],
		['a', 'type', 'submit'],
		['a', 'name', 'register'],
		['a', 'value', 'register'],
		['d', 'Register'],
		['e', 'button'],
		['e', 'p'],

		['e', 'fieldset'],
		['e', 'form'],
	],
	'Default registering form.',
);

# Test.
$obj = Tags::HTML::Login::Register->new;
eval {
	$obj->process;
};
is($EVAL_ERROR, "Parameter 'tags' isn't defined.\n",
	"Parameter 'tags' isn't defined.");
clean();
