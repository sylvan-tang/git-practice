import re
import sys

msg_pattern = re.compile("^(Feature|Hotfix|Bugfix):( \S+)+( Closes \#\d+)+$")


def check_msg_format():
    for line in sys.stdin.readlines():
        m = msg_pattern.match(line.strip())
        if m:
            return True
    print(f"commit message with regex pattern: {msg_pattern.__str__()}")
    return False


if __name__ == "__main__":
    exit(0 if check_msg_format() else 1)
