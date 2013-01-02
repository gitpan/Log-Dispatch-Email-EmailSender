#
# This file is part of Log-Dispatch-Email-EmailSender
#
# This software is copyright (c) 2013 by Loïc TROCHET.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
package Log::Dispatch::Email::EmailSender;
{
  $Log::Dispatch::Email::EmailSender::VERSION = '0.130020';
}
# ABSTRACT: Subclass of Log::Dispatch::Email that uses Email::Sender

use strict;
use warnings;

use Params::Validate qw(validate SCALAR);
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;

use Log::Dispatch::Email;
use parent qw(Log::Dispatch::Email);

Params::Validate::validation_options( allow_extra => 1 );


sub new
{
    my $this = shift;
    my $class = ref $this || $this;

    my %p = validate
    (
        @_
    ,   {
            smtp => { type => SCALAR, optional =>  1 }
        ,   port => { type => SCALAR, default  => 25 }
        }
    );

    my $self = $class->SUPER::new(%p);

    $self->{to} = join ', ', @{$self->{to}} if ref $self->{to};

    if (exists $p{smtp})
    {
        $self->{smtp} = $p{smtp};
        $self->{port} = $p{port};
    }

    return $self;
}


sub send_email
{
    my $self = shift;
    my %p = @_;

    my $email = Email::Simple->create
                (
                    header => [
                                  To      => $self->{to}
                              ,   From    => $self->{from}
                              ,   Subject => $self->{subject}
                              ]
                ,   body => $p{message}
                );

    my $args;

    $args = {transport => Email::Sender::Transport::SMTP->new({host => $self->{smtp}, port => $self->{port}})}
        if exists $self->{smtp};

    sendmail($email, $args);
}

1;

__END__

=pod

=head1 NAME

Log::Dispatch::Email::EmailSender - Subclass of Log::Dispatch::Email that uses Email::Sender

=head1 VERSION

version 0.130020

=head1 SYNOPSIS

    use Log::Dispatch;

    my $log = Log::Dispatch->new(
        outputs => [
            [
                'Email::EmailSender'
            ,   min_level => 'emerg'
            ,   to        => [qw( foo@example.com bar@example.org )]
            ,   subject   => 'Big error!'
            ]
        ]
    );

    $log->emerg("Something bad is happening");

or you can specify a transport:

    use Log::Dispatch;

    my $log = Log::Dispatch->new(
        outputs => [
            [
                'Email::EmailSender'
            ,   min_level => 'emerg'
            ,   smtp      => 'smtp.foo.com'
            ,   port      => 9856
            ,   to        => [qw( foo@example.com bar@example.org )]
            ,   subject   => 'Big error!'
            ]
        ]
    );

    $log->emerg("Something bad is happening");

=head1 DESCRIPTION

This is a subclass of Log::Dispatch::Email that implements the send_email method using the L<Email::Sender> module.

=head1 METHODS

=head2 new

The constructor can take the following optional parameters in addition to the standard parameters documented
in L<Log::Dispatch::Email>:

=over 4

=item * smtp ($)

SMTP server.

=item * port ($)

Unusual SMTP server port. Default to 25.

=back

=head2 send_email

The L<Log::Dispatch::Email> subclassed method.

=head1 SEE ALSO

L<Log::Dispatch::Email::MIMELite>

L<Log::Dispatch::Email::MailSend>

L<Log::Dispatch::Email::EmailSend>

L<Log::Dispatch::Email::MailSender>

L<Log::Dispatch::Email::MailSendmail>

=encoding utf8

=head1 AUTHOR

Loïc TROCHET <losyme@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Loïc TROCHET.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
