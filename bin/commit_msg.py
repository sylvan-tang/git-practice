import re
import sys

msg_patterns = [
    re.compile("^(Feature|Hotfix|Bugfix):( \S+)+( Closes \#\d+)+$"),
    re.compile("^Merge branch.*$"),
    re.compile("^Revert.*$"),
    re.compile("^Release.*$"),
]


def check_msg_format():
    for line in sys.stdin.readlines():
        for msg_pattern in msg_patterns:
            m = msg_pattern.match(line.strip())
            if m:
                return True
    print(f"commit message with regex patterns:")
    for msg_pattern in msg_patterns:
        print(f"    {msg_pattern.__str__()}")
    return False


if __name__ == "__main__":
    exit(0 if check_msg_format() else 1)
