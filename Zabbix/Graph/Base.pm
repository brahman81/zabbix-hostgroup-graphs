#!/usr/bin/perl
#
#   Author: Tom Llewellyn-Smith <tom@onixconsulting.co.uk>
#   Date: 20/6/2013
#
#   Copyright: © Onix Consulting Limited 2012-2013. All rights reserved.
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
use strict;
use warnings;

package Zabbix::Graph::Base;

=head 2

connects to a zabbix server stores authid in object as well as returning authid

=cut
sub connect
{
    my $self = shift;
    if($self->{'rpc_client'} and $self->{'username'} and $self->{'password'})
    {
        my $auth_json = {
            jsonrpc => "2.0",
            method => "user.login",
            params => {
                user => $self->{'username'},
                password => $self->{'password'},
            },
            id => 1
        };

        my $response = $self->{'rpc_client'}->call($self->{'url'}, $auth_json);
        $self->{'authid'} = $response->content->{'result'};
    }
    return $self->{'authid'}
}

=head2

print message if $self->{verbose} = 1, appending a newline

=cut
sub output {
    my $self = shift;
    if (@_) {
        my $message = shift;
        if ($self->{verbose}) {
            chomp($message); # remove extra newlines
            print $message . "\n";
        }
    }
}

1;
