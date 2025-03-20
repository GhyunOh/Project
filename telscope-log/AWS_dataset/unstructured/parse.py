
pat = {}
for i in range(0, 26):
    pat[i] = {}

with open('attack.log', 'r') as f:
    for l in f:
        t = l.split()
        print(len(t), l)
        cnt = 0
        for i in t:
            i = i.strip()
            if not i in pat[cnt]:
                pat[cnt][i] = 1
            else:
                pat[cnt][i] += 1

            print('%2d [%s]' % (cnt, i))
            cnt += 1
        print()

print('-------profile----------')
col = {}
col[0] = "Time" # remove it
col[1] = "Bucket Owner"
col[2] = "Requester"
col[3] = "Remote IP"
col[4] = "Access Point ARN"
col[5] = "Request ID" # remove it
col[6] = "Operation"
col[7] = "Key"
col[8] = "Request-URI"
col[9] = "HTTP status"
col[10] = "Error Code"
col[11] = "Bytes Sent" # remove it
col[12] = "Object Size" # remove it
col[13] = "Total Time" # remove it
col[14] = "Turn-Around Time" # remove it
col[15] = "Referer" # remove it
col[16] = "User-Agent"
col[17] = "Version Id"
col[18] = "Host Id" # remove it
col[19] = "Signature Version"
col[20] = "Cipher Suite"
col[21] = "Authentication Type"
col[22] = "Host Header"
col[23] = "TLS version"
col[24] = "aclRequired/Unknown"
col[25] = "aclRequired/Unknown"

for i in range(0, 26):
    print(i, col[i], len(pat[i]), 'different values')
    for j in pat[i]:
        print('   %s %d' % (j, pat[i][j]))
    print()
