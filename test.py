import re

pattern = r"([^\r\n\t\f\v= \"<>']+)(?:=([\"'])?((?:.(?!\2?\s+(?:\S+)=|\2))+.)\2?)?"

text = '<script type="text/javascript" defer async id="something" onload="alert(\'hello\');"></script>'

matches_with_groups = re.finditer(pattern, text)

# Print all matches and groups
for match in matches_with_groups:
    print("Full match:", match.group(0))
    print("Username:", match.group(1))
    print("Domain:", match.group(2))
    print()