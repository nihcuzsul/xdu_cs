
def get_dict_from_singal():
    singal_dict = {}
    singal_dict['A'] = (0, 0.1)
    singal_dict['B'] = (0.1, 0.5)
    singal_dict['C'] = (0.5, 0.7)
    singal_dict['D'] = (0.7, 1)
    return singal_dict
'''
def get_dict_from_singal(singal):
    singal_dict = {}
    a1 = 0
    b1 = 0
    c1 = 0
    d1 = 0
    for c in singal:
        if c == 'A':
            a1 += 1
        if c == 'B':
            b1 += 1
        if c == 'C':
            c1 += 1
        if c == 'D':
            d1 += 1
    pa = a1 / len(singal)
    pb = b1 / len(singal)
    pc = c1 / len(singal)
    x = pa
    y = x + pb
    z = y + pc
    singal_dict['A'] = (0, x)
    singal_dict['B'] = (x, y)
    singal_dict['C'] = (y, z)
    singal_dict['D'] = (z, 1)
    return singal_dict
'''''

def encoder(singal, singal_dict):
    Low = 0
    High = 1
    for s in singal:
        CodeRange = High - Low
        High = Low + CodeRange * singal_dict[s][1]
        Low = Low + CodeRange * singal_dict[s][0]
    return Low


def dec2bin(dec):
    result = ['0.']
    for i in range(15):
        dec = dec*2
        dec_int = int(dec)
        result.append(str(dec_int))
        dec = dec -dec_int
        if dec == 0:
            break
    return ''.join(result)


def decoder(encoded_number, singal_dict, singal_length):
    singal = []
    while singal_length:
        for k, v in singal_dict.items():
            if v[0] <= encoded_number < v[1]:
                singal.append(k)
                range = v[1] - v[0]
                encoded_number -= v[0]
                encoded_number /= range
                break
        singal_length -= 1
    return singal



def main():
    singal_dict = get_dict_from_singal()
    singal = input('输入字符串:')
    #singal_dict = get_dict_from_singal(singal)
    ans = encoder(singal, singal_dict)
    print('十进制:')
    print('%.16f' % ans)
    print('二进制:')
    binans = dec2bin(ans)
    print(binans)
    singal_rec = decoder(ans, singal_dict, len(singal))
    decstr= ''.join(singal_rec)
    print('解码后字符串:')
    #print(singal_rec)
    print(decstr)

if __name__ == '__main__':
    main()