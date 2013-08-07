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
use v5.10.1;
use Getopt::Std;
use Zabbix::Graph;

my %opts;
getopts('g:',\%opts);

my $url = 'https://zabbix.example.com/zabbix/api_jsonrpc.php';
my $username = 'username';
my $password = 'password';
my $graph_name = 'CPU user time';

my $obj = Zabbix::Graph->new({url => $url,username => $username,password => $password, verbose => '1'});

$obj->connect();

given ($opts{'g'}) {
    when (/all/) {
        my %groups = $obj->get_groups();
        while (my ($group,$groupid) = each(%groups)) {
            $obj->hostgroup_graph($graph_name,'system.cpu.util[,user]',$group);
        }
    }
    default {
        my %groups = $obj->get_groups($opts{'g'});
        while (my ($group,$groupid) = each(%groups)) {
            $obj->hostgroup_graph($graph_name,'system.cpu.util[,user]',$group);
        }
    }
}
