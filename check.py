#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys, os, codecs, re

OS_SEP = os.path.sep

# VAR
oids_pattern = '((?:[0-9]+\.)+[0-9]+)+'
# for certutil (win)
extKeyUsage_pattern = '.*2\.5\.29\.37.*?(?:SEQUENCE)(.*?)(?:SEQUENCE)(?:.*)'
# for dumpasn1 (nix)
extKeyUsage_pattern = '.*2.5.29.37.*?(?:SEQUENCE)(.*?)(?:SEQUENCE)(?:.*)'

path = sys.argv[1]

#list_dir = os.listdir(path+ '/asn')
list_dir = os.listdir(os.path.join(path, 'asn'))
list_dir.sort()

#result_file = open(path + '/result.txt', 'w')
result_file = open(os.path.join(path, 'result.txt'), 'w')

#global_oids = [line.rstrip() for line in open(os.path.dirname(sys.argv[0]) + '/oid.txt')]
global_oids = [line.rstrip() for line in open(os.path.join(os.path.dirname(sys.argv[0]), 'oid.txt'))]

# DEF
def get_oids (data):
	extKeyUsage = re.search(extKeyUsage_pattern,data,re.MULTILINE|re.DOTALL)
	oids = re.findall(oids_pattern, extKeyUsage.group(1))
	return oids

def compare_oids (oids):
	errors =[]
	for oid in oids:
		if oid not in global_oids:
			errors.append(oid)
	return errors

def find_errors(name, path):
    result = []
    for root, dirs, files in os.walk(path):
        if name in files:
            result.append(os.path.join(root, name))
    return result

def rename(files):
	for file in files:
		oldname = file
		newname = file.replace(OS_SEP + 'req' + OS_SEP, OS_SEP + 'req_err' + OS_SEP)
		os.renames(oldname, newname)


# MAIN
for _file in list_dir:
	errors = []
	oids = []

#	asn_file = codecs.open(path + '/asn/' + _file, 'r', 'cp1251')
	asn_file = codecs.open(os.path.join(path, 'asn', _file), 'r', 'cp1251')
	asn_data = asn_file.read()

	oids = get_oids(asn_data)
	errors = compare_oids(oids)

	if errors:
#		error_files = find_errors(_file.rstrip('.txt') + '.req',path + '/req')
		error_files = find_errors(_file.rstrip('.txt') + '.req',os.path.join(path, 'req'))
		rename(error_files)
	result_file.write(_file.rstrip('.txt') + '\t' + ', '.join(errors) + '\n')

result_file.close()
