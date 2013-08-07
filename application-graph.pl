#!/usr/bin/perl
#
#   Author: Tom Llewellyn-Smith <tom@onixconsulting.co.uk>
#   Date: 7/8/2013
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
use Zabbix::Graph;

my $url = 'https://zabbix.example.com/zabbix/api_jsonrpc.php';
my $username = 'username';
my $password = 'password';
my $application_name = 'Apache2'
my $graph_name = 'Apache2 Items';
my $hostid = '12345'; # id of host the graph should be applied to

my $obj = Zabbix::Graph->new({url => $url,username => $username,password => $password, verbose => '1'});

$obj->connect();

# main()
my $app_id = $obj->get_host_app_id($hostid,$application_name);
my @items = $obj->get_app_items($app_id,$hostid);
$obj->graph($graph_name,\@items);
