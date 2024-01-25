rm all-previously-installed-packages*.txt 2>/dev/null
rm not-available*.txt 2>/dev/null
rm available*.txt 2>/dev/null
rm to-install*.txt 2>/dev/null

awk '/Package:/ {pkg=$2} /Status: install ok installed/ {print pkg}' $1 >all-previously-installed-packages.txt
newname=$(cat all-previously-installed-packages.txt | wc -l)
mv all-previously-installed-packages.txt all-previously-installed-packages_$newname.txt

while read package; do
    if apt-cache show "$package" >/dev/null 2>/dev/null; then
        # echo "$package: available"
        echo "$package" >>available.txt
        if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
            echo "$package" >>to-install.txt
        fi
    else
        # echo "$package: not available"
        echo "$package" >>not-available.txt
    fi
done <"all-previously-installed-packages_$newname.txt"

newname_available="available_$(cat available.txt | wc -l).txt"
newname_notavailable="not-available_$(cat not-available.txt | wc -l).txt"
mv available.txt "$newname_available"
mv not-available.txt "$newname_notavailable"
newname_toinst="to-install_$(cat to-install.txt | wc -l).txt"
mv to-install.txt "$newname_toinst"
