import re
import sys

msg_patterns = [
    re.compile("^(Feature|Hotfix|Bugfix):( \S+)+( Ref \#\d+)+$"),
    re.compile("^(Feature|Hotfix|Bugfix):( \S+)+( Related to \#\d+)+$"),
    re.compile("^Merge branch.*$"),
    re.compile("^Revert.*$"),
    re.compile("^Hotfix.*$"),
    re.compile("^Release.*$"),
]


def check_msg_format():
    for line in sys.stdin.readlines():
        for msg_pattern in msg_patterns:
            m = msg_pattern.match(line.strip())
            if m:
                return True
    print(f"commit message with one of regex patterns below:")
    for msg_pattern in msg_patterns:
        print(f"    {msg_pattern.__str__()}")
    return False


if __name__ == "__main__":
    exit(0 if check_msg_format() else 1)
