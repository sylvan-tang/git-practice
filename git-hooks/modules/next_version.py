import sys


def next_version(version_prefix, tag_version, release_version, hotfix_version, version_mode):
    tag_version = tag_version.strip(version_prefix)
    release_version = release_version.strip(version_prefix)
    hotfix_version = hotfix_version.strip(version_prefix)

    if not tag_version:
        tag_version = "0.0.0"
    if not release_version:
        release_version = "0.0.0"
    if not hotfix_version:
        hotfix_version = f"{release_version}.0"

    # 使用 HOTFIX 模式
    if version_mode == "HOTFIX":
        tag_version = f"{tag_version}.0"[:7]
        release_version = f"{hotfix_version}.0"[:7]
    else:
        tag_version = tag_version[:5]
        release_version = release_version[:5]

    tag_version_number = [int(n) for n in tag_version.split(".")]
    release_version_number = [int(n) for n in release_version.split(".")]
    version_number = release_version_number
    for i, n in enumerate(tag_version_number):
        if n > release_version_number[i]:
            version_number = tag_version_number
            break

    if version_mode == "HOTFIX":
        version_number[-1] += 1
    elif version_mode == "RELEASE":
        version_number[-1] += 1
    elif version_mode == "FRAME":
        version_number[-1] = 0
        version_number[-2] += 1
    else:
        version_number[-1] = 0
        version_number[-2] = 0
        version_number[-3] += 1
    return f"{version_prefix}{'.'.join([str(n) for n in version_number])}"


if __name__ == "__main__":
    print(next_version(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]))
