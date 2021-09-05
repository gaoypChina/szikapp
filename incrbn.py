string = ''
with open('pubspec.yaml', 'r') as pubspec:
    lines = pubspec.readlines()
    for line in lines:
        if 'version:' in line:
            codes = line.strip().split('+')
            code = int(codes[1])
            code += 1
            print(f'Incrased version code: {code-1} to {code}')
            string += f'{codes[0]}+{code}\n'
        else:
            string += line

with open('pubspec.yaml', 'w') as pubspec:
    pubspec.writelines(string)
