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
use JSON::RPC::Client;

package Zabbix::Graph;

use Zabbix::Graph::Application;
use Zabbix::Graph::Base;
use Zabbix::Graph::Create;
use Zabbix::Graph::Group;
use Zabbix::Graph::Host;

@Zabbix::Graph::ISA = qw( Zabbix::Graph::Application Zabbix::Graph::Base Zabbix::Graph::Create Zabbix::Graph::Group Zabbix::Graph::Host );

=head2 Zabbix::Graph::new()

create a Zabbix::Graph object

=cut
sub new {
    my $class   = shift;
    my $self = {};

    # Allow direct access to the object data structure. Not keen on setter/getters...
    if (@_) {
        $self    = shift;
    }

    # Set some defaults
    $self->{now} = time();
    $self->{rpc_client} = new JSON::RPC::Client;
    $self->{graph_colors} = [qw(
        FF0000 00FF00 0000FF FFFF00
        00FFFF FF00FF FFFF99 FF6699
        99FF99 993399 6960EC 736AFF
        357EC7 488AC7 C8A2C8 E6A9EC
        3090C7 659EC7 87AFC7 95B9C7
        46C7C7 43BFC7 3EA99F 3B9C9C
        438D80 348781 307D7E 64E986
        5EFB6E 00FF00 5FFB17 87F717
        8AFB17 6AFB92 7D0552 7F4E52
        7F5A58 7F525D B38481 C5908E
        C48189 E3319D F433FF D16587
        C25A7C CA226B C12869 C12267
        9172EC 9E7BFF D462FF E238EC
        C38EC7
    )];

    bless($self, $class);
}

1;
