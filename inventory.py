#!/usr/bin/env python

'''
Example custom dynamic inventory script for Ansible, in Python.
'''

import os
import sys
import argparse

try:
    import json
except ImportError:
    import simplejson as json


class DynamicInventory(object):

    def __init__(self):
        self.inventory = {}
        self.inventory = { '_meta': {'hostvars': {}}}


    def print_json(self):
        print ( json.dumps(self.inventory, indent=4, sort_keys=True) )


    def add_group(self, group_name, hosts, vars=[]):
        parent = self.inventory

        if group_name not in parent:
            # preparing group
            group = {}
            group['hosts'] = hosts
            l = len(vars)
            if l > 0:
                group['vars'] = vars

            # adding group to inventory
            parent[group_name] = group
        else:
            for h in hosts:
                parent[group_name]['hosts'].append(h)


    def add_host_var(self, host_name, key, value):
        parent = self.inventory['_meta']['hostvars']

        if host_name not in parent:
            host = {}
            host[key] = value
            parent[host_name] = host
        else:
            parent[host_name][key] = value




class TerraformDynamicInventory(object):

    def __init__(self):
        self.inventory = DynamicInventory()


    def print_json(self):
        self.inventory.print_json()


    def add_group(self, attributes):
        if 'tags.Group' in attributes and 'private_ip' in attributes:
            tags_group = attributes['tags.Group']
            private_ip = attributes['private_ip']
            self.inventory.add_group(tags_group, [ private_ip ])


    def add_tag(self, attributes, attribute):
        if 'tags.Name' in attributes and attribute in attributes:
            tags_name = attributes['tags.Name']
            value = attributes[attribute]
            self.inventory.add_host_var(tags_name, attribute, value)


    def add_host_var(self, host_name, key, value):
        self.inventory.add_host_var(host_name, key, value)


    def parse_tfstate_file(self, filename):
        data = json.load(open(file))
        resources = data['modules'][0]['resources']

        for r in resources:
            resource = resources[r]
            primary = resource['primary']
            attributes = primary['attributes']

            if resource['type'] == "aws_instance":
                self.add_group(attributes)
                self.add_tag(attributes, 'public_ip')
                self.add_tag(attributes, 'tags.is_bastion')

        #print ( json.dumps(resources, indent=4, sort_keys=True) )






inventory = TerraformDynamicInventory()

file = 'terraform/server/terraform.tfstate'
inventory.parse_tfstate_file(file)
inventory.print_json()
