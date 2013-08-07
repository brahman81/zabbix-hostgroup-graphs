#!/usr/bin/perl
#
#   Author: Tom Llewellyn-Smith <tom@onixconsulting.co.uk>
#   Date: 07/08/2013
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

package Zabbix::Graph::Application;

=head2 Zabbix::Graph::Application::get_app_items()

get a list of all itemids in application, adds a dash of color... ;-)

=cut
sub get_app_items {
    my $self = shift;
    if (@_) {
        my $applicationid = shift;
        my $hostid = shift;
        # retrieve all application items
        my $query = {
            "jsonrpc" => "2.0",
            "method" => "item.get",
            "params" => {
                "output" => "extend",
                "hostids" => $hostid,
                "applicationids" => $applicationid,
                "sortfield" => "name",
            },
            "auth" => $self->{authid},
            "id" => 1
        };

        my $response = $self->{'rpc_client'}->call($self->{'url'}, $query);
        if ($response->is_success == 1) {
            $self->output("info: processing application/host ($applicationid/$hostid)");
            foreach my $item (@{$response->{content}->{result}}) {
                if (${$item}{key_}) {
                    $self->output("info: found ${$item}{key_}");
                    push(@{$self->{application_items}{$hostid}},${$item}{itemid});
                }
            }
            for(my $i=0; $i < @{$self->{application_items}{$hostid}}; ++$i) {
                push(@{$self->{colored_application_items}},{'itemid' => ${$self->{application_items}{$hostid}}[$i],'color' => ${$self->{graph_colors}}[$i]});
            }
        }
        return @{$self->{colored_application_items}};
    }
}

1;
