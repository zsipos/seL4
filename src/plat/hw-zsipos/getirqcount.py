import sys

file= sys.argv[0].replace('src/plat/hw-zsipos/getirqcount.py', 'tools/dts/hw-zsipos.dts')
extern_found = False
with open(file, 'r') as f:
	for i in f.readlines():
		if i.find('external-interrupts') > -1:
			extern_found = True
		elif extern_found and i.find('interrupts = ') > -1:
			print(len(i.split('0x'))-1, end='')
			break

