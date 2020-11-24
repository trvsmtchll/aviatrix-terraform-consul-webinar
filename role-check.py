import subprocess
import json

try:
    process = subprocess.Popen(['aws','iam', 'get-role', '--role-name', 'aviatrix-role-ec2'], stdout=subprocess.PIPE)
    out, err = process.communicate()
    d = json.loads(out)
    print(d)

except:
    f = json.dumps(['false'])
    print(f)
