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

package Zabbix::Graph::Group;

=head2 Zabbix::Graph::Group::get_groups()

retrieve a list of all host groups matching filter name.

=cut
sub get_groups {
    my $self = shift;
    my $filter = shift || undef;
    my $query;
    # retrieve all host groups
    unless ($filter) {
        $query = {
            "jsonrpc" => "2.0",
            "method" => "hostgroup.get",
            "params" => {
                "output" => "extend",
            },
            "auth" => $self->{authid},
            "id" => 1,
        };
    } else {
        $query = {
            "jsonrpc" => "2.0",
            "method" => "hostgroup.get",
            "params" => {
                "output" => "extend",
                "filter" => {
                    "name" => [
                        $filter,
                    ]
                }
            },
            "auth" => $self->{authid},
            "id" => 1,
        };
    }

    # process host groups using filter, store in a list
    my $response = $self->{'rpc_client'}->call($self->{'url'}, $query);
    if ($response->is_success == 1) {
        $self->output("info: processing host groups");
        foreach my $hostgroup (@{$response->{content}->{result}}) {
            $self->output("info: found ${$hostgroup}{name}");
            $self->{hostgroups}{${$hostgroup}{name}} = ${$hostgroup}{groupid};
        }
        return %{$self->{hostgroups}};
    }
}

=head2 Zabbix::Graph::Group::get_group_id()

return hostgroup id given hostgroup name

=cut
sub get_group_id {
    my $self = shift;
    if (@_) {
        my $group_name = shift;
        $self->output("info: searching for $group_name");
        if ($self->{hostgroups}{$group_name}) {
            return $self->{hostgroups}{$group_name};
        }
    }
}

=head2 Zabbix::Graph::Group::get_hosts()

retrieve a list of all hosts in a given host group

=cut
sub get_hosts {
    my $self = shift;

    if (@_) {
        my $group = shift;
        my $group_id = $self->get_group_id($group);

        # retrieve all hosts in group
        my $query = {
            "jsonrpc" => "2.0",
            "method" => "host.get",
            "params" => {
                "output" => "extend",
                "groupids" => $group_id,
            },
            "auth" => $self->{authid},
            "id" => 1
        };
    
        # process returned hosts, store in a list
        my $response = $self->{'rpc_client'}->call($self->{'url'}, $query);
        if ($response->is_success == 1) {
            $self->output("info: processing $group");
            foreach my $host (@{$response->{content}->{result}}) {
                $self->output("info: found ${$host}{name}");
                $self->{hosts}{$group}{${$host}{name}} = ${$host}{hostid};
            }
            return %{$self->{hosts}};
        }
    }
}

1;
