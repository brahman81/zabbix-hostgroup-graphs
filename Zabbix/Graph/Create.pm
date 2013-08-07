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

package Zabbix::Graph::Create;

=head2 Zabbix::Graph::Create::graph()

creates a zabbix graph

=cut
sub graph
{
    my $self = shift;
    if(@_) {
        my $graph_name = shift;
        my $item_key = shift;
        my $group = shift;

        unless ($graph_name and $item_key and $group) {
            exit 123;
        }

        # get a list reference with color and item id
        my $items_ref = $self->graph_items($item_key,$group);

        my $query = {
            "jsonrpc" => "2.0",
            "method" => "graph.create",
            "params" => {
                "name" => "$graph_name ($group)",
                "width" => 900,
                "height" => 200,
                "gitems" => $items_ref,
            },
            "auth" => $self->{authid},
            "id" => 1
        };

        my $response = $self->{'rpc_client'}->call($self->{'url'}, $query);
        if ($response->is_success == 1) {
            $self->output("info: creating $graph_name ($group)");
        }
    }
}

=head2 Zabbix::Graph::Create::graph_items()

creates a data structure of items for use with graph()

=cut
sub graph_items {
    my $self = shift;
    my @graph_items;
    if (@_) {
        my $item_key = shift;
        my $group = shift;
        my %hosts = $self->get_hosts($group);
        if (scalar %hosts) {
            while (my ($hostgroup, $hosts_ref) = each(%hosts)) {
                if (scalar %{$hosts_ref}) {
                    while (my ($host,$hostid) = each(%{$hosts_ref})) {
                        $self->output("info: $host ($hostgroup)");
                        $self->get_items($item_key,$hostgroup,$hostid);
                    }
                } else {
                    $self->output("warning: $group is empty");
                    @{$self->{hostitems}{$group}} = ();
                }
            }
            if (scalar @{$self->{hostitems}{$group}}) {
                for(my $i=0; $i < @{$self->{hostitems}{$group}}; ++$i) {
                    push(@graph_items,{'itemid' => ${$self->{hostitems}{$group}}[$i],'color' => ${$self->{graph_colors}}[$i]});
                }
            }
        }
    }
    return \@graph_items;
}

=head2 Zabbix::Graph::Create::delete_graph()

delete graph if already exists, ensures the graph represents the latest Zabbix information

=cut
sub delete_graph {
    #TODO
}

1;
