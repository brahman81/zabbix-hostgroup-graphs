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

package Zabbix::Graph::Host;

=head2 Zabbix::Graph::Host::get_items()

get a list of itemids for all members of group X given item.key

=cut
sub get_items {
    my $self = shift;
    if (@_) {
        my $item_key = shift;
        my $hostgroup = shift;
        my $hostid = shift;
        # retrieve all host items
        my $query = {
            "jsonrpc" => "2.0",
            "method" => "item.get",
            "params" => {
                "output" => "extend",
                "hostids" => $hostid,
                "sortfield" => "name",
                "search" => {
                    "key_" => $item_key,
                },
            },
            "auth" => $self->{authid},
            "id" => 1
        };

        my $response = $self->{'rpc_client'}->call($self->{'url'}, $query);
        if ($response->is_success == 1) {
            $self->output("info: processing host ($hostid)");
            foreach my $item (@{$response->{content}->{result}}) {
                if (${$item}{key_}) {
                    $self->output("info: found ${$item}{key_}");
                    push(@{$self->{hostitems}{$hostgroup}},${$item}{itemid});
                }
            }
        }
    }
}

sub get_host_app_id {
    my $self = shift;
    if (@_) {
        my $hostid = shift;
        my $application_name = shift;
        my $applicationid;

        my $query = {
            "jsonrpc" => "2.0",
            "method" => "application.get",
            "params" => {
                "output" => "extend",
                "hostids" => $hostid,
                "sortfield" => "name",
                "filter" => {
                    "name" => $application_name,
                }
            },
            "auth" => $self->{authid},
            "id" => 1
        };

        my $response = $self->{'rpc_client'}->call($self->{'url'}, $query);
        if ($response->is_success == 1) {
            foreach my $item (@{$response->{content}->{result}}) {
                if (${$item}{applicationid}) {
                    $self->output("info: found $application_name (${$item}{applicationid})");
                    $applicationid = ${$item}{applicationid};
                }
            }
        }
        return $applicationid;
    }
}

1;
